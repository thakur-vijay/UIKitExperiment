//
//  ResponderHierarchyView.swift
//  UIKitExperiment
//
//  Created by Vijay Thakur on 25/11/26.
//

import UIKit

final class ResponderHierarchyView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Responder Hierarchy"
        label.font = .preferredFont(forTextStyle: .title2)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Tap to become first responder"
        field.borderStyle = .roundedRect
        field.autocorrectionType = .no
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    let becomeFirstResponderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Become First Responder", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let resignFirstResponderButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Resign First Responder", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let inspectChainButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Inspect Responder Chain", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let touchView: ResponderTraceView = {
        let view = ResponderTraceView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let resultTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.font = .preferredFont(forTextStyle: .body)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 12
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .systemBackground
        setupLayout()
    }

    private func setupLayout() {
        [
            titleLabel,
            textField,
            becomeFirstResponderButton,
            resignFirstResponderButton,
            inspectChainButton,
            touchView,
            resultTextView
        ].forEach(addSubview)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            textField.heightAnchor.constraint(equalToConstant: 44),

            becomeFirstResponderButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            becomeFirstResponderButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            resignFirstResponderButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            resignFirstResponderButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            inspectChainButton.topAnchor.constraint(equalTo: becomeFirstResponderButton.bottomAnchor, constant: 12),
            inspectChainButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            touchView.topAnchor.constraint(equalTo: inspectChainButton.bottomAnchor, constant: 20),
            touchView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            touchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            touchView.heightAnchor.constraint(equalToConstant: 100),

            resultTextView.topAnchor.constraint(equalTo: touchView.bottomAnchor, constant: 20),
            resultTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            resultTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            resultTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

final class ResponderTraceView: UIView {

    var onTouch: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        isUserInteractionEnabled = true
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAppearance()
        isUserInteractionEnabled = true
    }

    private func setupAppearance() {
        backgroundColor = .systemTeal
        layer.cornerRadius = 12

        let label = UILabel()
        label.text = "Tap this custom responder view"
        label.textAlignment = .center
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        onTouch?("ResponderTraceView received touchesBegan")
        super.touchesBegan(touches, with: event)
    }

    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        onTouch?("ResponderTraceView received touchesEnded")
        super.touchesEnded(touches, with: event)
    }
}
