//
//  NSObjectInspectorView.swift
//  UIKitExperiment
//

import UIKit

final class NSObjectInspectorView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "NSObject in UIKit"
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()

    let inspectButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Inspect UIKit Objects"
        configuration.cornerStyle = .medium

        let button = UIButton(type: .system)
        button.configuration = configuration
        return button
    }()

    let resultTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = true
        textView.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 12
        textView.textContainerInset = UIEdgeInsets(
            top: 16,
            left: 16,
            bottom: 16,
            right: 16
        )
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemBackground

        addSubview(titleLabel)
        addSubview(inspectButton)
        addSubview(resultTextView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        inspectButton.translatesAutoresizingMaskIntoConstraints = false
        resultTextView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: safeAreaLayoutGuide.topAnchor,
                constant: 20
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),

            inspectButton.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 20
            ),
            inspectButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            resultTextView.topAnchor.constraint(
                equalTo: inspectButton.bottomAnchor,
                constant: 20
            ),
            resultTextView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
            resultTextView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),
            resultTextView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            )
        ])
    }
}
