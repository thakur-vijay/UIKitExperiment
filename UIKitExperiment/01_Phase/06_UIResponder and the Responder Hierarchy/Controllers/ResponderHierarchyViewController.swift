//
//  ResponderHierarchyViewController.swift
//  UIKitExperiment
//
//  Created by Vijay Thakur on 25/11/26.
//

import UIKit

final class ResponderHierarchyViewController: UIViewController {

    private let contentView = ResponderHierarchyView()

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupActions()
        updateResponderChain()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateResponderChain()
    }

    private func setupActions() {
        contentView.becomeFirstResponderButton.addTarget(
            self,
            action: #selector(becomeTheFirstResponder),
            for: .touchUpInside
        )

        contentView.resignFirstResponderButton.addTarget(
            self,
            action: #selector(resignFromFirstResponder),
            for: .touchUpInside
        )

        contentView.inspectChainButton.addTarget(
            self,
            action: #selector(inspectResponderChain),
            for: .touchUpInside
        )

        contentView.touchView.onTouch = { [weak self] message in
            guard let self else { return }
            self.contentView.resultTextView.text = """
            \(message)

            First responder:
            \(self.contentView.textField.isFirstResponder ? "UITextField" : "None")

            Tap "Inspect Responder Chain" to view the next links.
            """
        }

        contentView.textField.delegate = self
    }

    @objc private func becomeTheFirstResponder() {
        guard contentView.textField.canBecomeFirstResponder else {
            contentView.resultTextView.text =
                "UITextField cannot become first responder."
            return
        }

        let didBecomeFirstResponder =
            contentView.textField.becomeFirstResponder()

        contentView.resultTextView.text = didBecomeFirstResponder
            ? "UITextField became the first responder. The keyboard should be visible."
            : "UITextField did not become the first responder."

        updateResponderChain()
    }

    @objc private func resignFromFirstResponder() {
        let didResign =
            contentView.textField.resignFirstResponder()

        contentView.resultTextView.text = didResign
            ? "UITextField resigned first responder. The keyboard should hide."
            : "UITextField was not the first responder."

        updateResponderChain()
    }

    @objc private func inspectResponderChain() {
        updateResponderChain()
    }

    private func updateResponderChain() {
        let textField = contentView.textField
        let responderNames = responderChainNames(from: textField)

        contentView.resultTextView.text = """
        First responder:
        \(textField.isFirstResponder ? "UITextField" : "None")

        Responder chain:
        \(responderNames.enumerated().map { index, name in
            "\(String(repeating: " ", count: index * 2))-> \(name)"
        }.joined(separator: "\n"))
        """
    }

    private func responderChainNames(
        from responder: UIResponder?
    ) -> [String] {
        var names: [String] = []
        var current = responder

        while let currentResponder = current {
            names.append(String(describing: type(of: currentResponder)))
            current = currentResponder.next
        }

        names.append("nil")
        return names
    }
}

extension ResponderHierarchyViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        updateResponderChain()
        return true
    }
}

