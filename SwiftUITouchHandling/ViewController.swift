//
//  ViewController.swift
//  SwiftUITouchHandling
//
//  Created by Peter Steinberger on 26.10.20.
//

import UIKit
import SwiftUI

final class CGRectBox {
    var rect: CGRect?
}

final class PassthroughView: UIView {
    let activeRectBox: CGRectBox

    init(activeRectBox: CGRectBox) {
        self.activeRectBox = activeRectBox
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        activeRectBox.rect?.contains(point) ?? false
    }
}

final class SwiftUIViewHostingController: UIViewController {
    private let rectBox = CGRectBox()
    private lazy var hostingController = UIHostingController(rootView: SwiftUIView(activeRectBox: rectBox))

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func loadView() {
        view = PassthroughView(activeRectBox: rectBox)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(hostingController)
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }

    required init?(coder: NSCoder) {
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
        swiftUI.didMove(toParent: self)
    }
}
