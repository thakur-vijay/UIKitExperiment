//
//  HierarchyInspectorViewController.swift
//  UIKitExperiment
//
//  Created by Vijay Thakur on 22/11/26.
//

import UIKit

final class HierarchyInspectorViewController: UIViewController {

    private let contentView = HierarchyInspectorView()

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        updateHierarchyDescription()
    }

    private func setupActions() {
        contentView.inspectButton.addTarget(
            self,
            action: #selector(inspectHierarchy),
            for: .touchUpInside
        )
    }

    @objc private func inspectHierarchy() {
        updateHierarchyDescription()

        printHierarchy(
            inspectButton,
            level: 0
        )
    }

    private func updateHierarchyDescription() {
        contentView.hierarchyTextView.text = """
        HierarchyInspectorViewController
        └── HierarchyInspectorView: UIView
            ├── titleLabel: UILabel
            ├── inspectButton: UIButton
            └── hierarchyTextView: UITextView

        Class relationships:
        UIButton -> UIControl -> UIView -> UIResponder -> NSObject
        UILabel -> UIView -> UIResponder -> NSObject
        UITextView -> UIScrollView -> UIView -> UIResponder -> NSObject
        """
    }

    private func printHierarchy(
        _ currentView: UIView,
        level: Int
    ) {
        let indentation = String(repeating: "  ", count: level)
        print("\(indentation)\(type(of: currentView))")

        for subview in currentView.subviews {
            printHierarchy(subview, level: level + 1)
        }
        
    }

    private var inspectButton: UIButton {
        contentView.inspectButton
    }
}

