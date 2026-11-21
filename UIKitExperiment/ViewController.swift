//
//  ViewController.swift
//  UIKitExperiment
//
//  Created by Vijay Thakur on 31/10/26.
//

import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mvcViewController = TaskListViewController()

        addChild(mvcViewController)

        view.addSubview(mvcViewController.view)

        mvcViewController.view.frame = view.bounds

        mvcViewController.view.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]

        mvcViewController.didMove(toParent: self)

    }

}

