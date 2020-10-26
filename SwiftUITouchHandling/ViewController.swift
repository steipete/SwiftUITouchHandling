//
//  ViewController.swift
//  SwiftUITouchHandling
//
//  Created by Peter Steinberger on 26.10.20.
//

import UIKit
import SwiftUI

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

        let swiftUI = UIHostingController(rootView: SwiftUIView())
        swiftUI.view.frame = CGRect(x: 150, y: 150, width: 150, height: 150)
        self.addChild(swiftUI)
        view.addSubview(swiftUI.view)
    }


}

