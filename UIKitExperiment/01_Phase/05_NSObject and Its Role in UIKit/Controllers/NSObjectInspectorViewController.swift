//
//  NSObjectInspectorViewController.swift
//  UIKitExperiment
//

import UIKit

final class NSObjectInspectorViewController: UIViewController {

    private let contentView = NSObjectInspectorView()

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        inspectObjects()
    }

    private func setupActions() {
        contentView.inspectButton.addTarget(
            self,
            action: #selector(inspectObjects),
            for: .touchUpInside
        )
    }

    @objc private func inspectObjects() {
        let record = NSObjectDemoRecord(
            title: "NSObjectDemoRecord",
            purpose: "Demonstrates a custom NSObject subclass"
        )

        let button = UIButton(type: .system)
        let label = UILabel()

        let isButtonNSObject = button is NSObject
        let isRecordNSObject = record is NSObject
        let buttonSuperclass = String(describing: UIButton.superclass()!)
        let className = String(describing: type(of: record))

        contentView.resultTextView.text = """
        Custom NSObject
        ├── Description: \(record)
        ├── Runtime class: \(className)
        └── Conforms to NSObject: \(isRecordNSObject)

        UIKit inheritance
        ├── UIButton -> UIControl -> UIView -> UIResponder -> NSObject
        ├── UILabel -> UIView -> UIResponder -> NSObject
        ├── UIViewController -> UIResponder -> NSObject
        └── UIButton superclass: \(buttonSuperclass)

        Runtime checks
        ├── UIButton is an NSObject: \(isButtonNSObject)
        ├── UILabel is an NSObject: \(label is NSObject)
        └── Custom record is an NSObject: \(isRecordNSObject)

        Every UIKit object shown above can participate in Foundation and Objective-C-compatible runtime behavior.
        """
    }
}
