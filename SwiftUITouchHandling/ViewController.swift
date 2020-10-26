//
//  ViewController.swift
//  SwiftUITouchHandling
//
//  Created by Peter Steinberger on 26.10.20.
//

import UIKit
import SwiftUI


class CGRectBox {
    var rect: CGRect?
}

// Using a subclass is pretty self-explainatory I think.
class SwiftUIViewHostingController: UIHostingController<SwiftUIView>, UIGestureRecognizerDelegate {
    /// We can't use a `@Binding` or a `@State` here because we must pass it to `SwiftUIView` during `init`.
    /// Anyway a binding would make the view's `body` to be recomputed and we don't really want it.
    let rectBox = CGRectBox()
    
    init() {
        super.init(rootView: SwiftUIView(activeRectBox: rectBox))
        
        // SwiftUI (or UIKit ?) set a special gesture recognizer. Let's be its delegate.
        view.gestureRecognizers?.first?.delegate = self
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let activeRect = rectBox.rect else { return true }
        
        if activeRect.contains(touch.location(in: view)) {
            print("Tapped on button")
        } else {
            print("Tapped on background")
        }
        
        /// Returning `false` may disable the button but the events won't be forwarded to the UIKit button.
        return true
    }
    
    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let button = UIButton(type: .roundedRect, primaryAction: UIAction { _ in
            print("UIKit tapped")
        })
        button.frame = CGRect(x: 100, y: 100, width: 500, height: 500)
        button.setTitle("UIKit Button", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        view.addSubview(button)

        let swiftUI = SwiftUIViewHostingController()
        swiftUI.view.frame = CGRect(x: 150, y: 150, width: 150, height: 150)
        self.addChild(swiftUI)
        view.addSubview(swiftUI.view)
    }
}

