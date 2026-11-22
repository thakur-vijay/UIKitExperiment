//
//  HierarchyInspectorView.swift
//  UIKitExperiment
//
//  Created by Vijay Thakur on 22/11/26.
//

import UIKit

final class HierarchyInspectorView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "UIKit Hierarchy"
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()

    let inspectButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Inspect Hierarchy", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        return button
    }()

    let hierarchyTextView: UITextView = {
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
        addSubview(hierarchyTextView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        inspectButton.translatesAutoresizingMaskIntoConstraints = false
        hierarchyTextView.translatesAutoresizingMaskIntoConstraints = false

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

            hierarchyTextView.topAnchor.constraint(
                equalTo: inspectButton.bottomAnchor,
                constant: 20
            ),
            hierarchyTextView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),
            hierarchyTextView.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),
            hierarchyTextView.bottomAnchor.constraint(
                equalTo: safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            )
        ])
    }
}
