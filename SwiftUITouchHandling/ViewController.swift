//
//  ViewController.swift
//  SwiftUITouchHandling
//
//  Created by Peter Steinberger on 26.10.20.
//

import UIKit
import SwiftUI

class MyView: UIView {
    var hostingView: UIView?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let something = super.hitTest(point, with: event)
        
        // SwiftUI returns unusual views during hitTesting - there must be a smarter way to find
        // a match for the background, but demo purposes this is enough.
        if something?.frame.width == hostingView?.frame.width {
            return self.subviews.first
        } else {
            return something
        }
    }
}

class ViewController: UIViewController {
    
    override func loadView() {
        let myView = MyView()
        view = myView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        let button = UIButton(type: .roundedRect, primaryAction: UIAction { _ in
            print("UIKit tapped")
        })
        button.frame = CGRect(x: 100, y: 100, width: 500, height: 500)
        button.setTitle("UIKit Button", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.blue.cgColor
        view.addSubview(button)
        
        let swiftUI = UIHostingController(rootView: SwiftUIView())
        swiftUI.view.frame = CGRect(x: 150, y: 150, width: 150, height: 150)
        self.addChild(swiftUI)
        view.addSubview(swiftUI.view)
        
        let castView = view as! MyView
        
        castView.hostingView = swiftUI.view
    }
    
    
}
