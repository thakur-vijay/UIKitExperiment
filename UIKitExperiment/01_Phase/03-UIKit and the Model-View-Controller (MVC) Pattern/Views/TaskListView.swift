//
//  TaskListView.swift
//  UIKitExperiment
//
//  Created by Vijay Thakur on 21/11/26.
//

import UIKit

final class TaskListView: UIView {

    // MARK: - UI Components

    let titleLabel: UILabel = {

        let label = UILabel()
        label.text = "My Tasks"
        label.font = .boldSystemFont(ofSize: 28)
        label.textAlignment = .center

        return label
    }()

    let taskTextField: UITextField = {

        let textField = UITextField()
        textField.placeholder = "Enter your task"
        textField.borderStyle = .roundedRect
        return textField
    }()

    let addButton: UIButton = {

        let button = UIButton(type: .system)
        button.setTitle("Add Task", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)

        return button
    }()

    let tableView: UITableView = {

        let tableView = UITableView()
        tableView.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "TaskCell"
        )

        return tableView
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup

    private func setupUI() {

        backgroundColor = .systemBackground

        addSubview(titleLabel)
        addSubview(taskTextField)
        addSubview(addButton)
        addSubview(tableView)

        setupConstraints()
    }

    // MARK: - Constraints

    private func setupConstraints() {

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        taskTextField.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

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

            taskTextField.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 30
            ),

            taskTextField.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 20
            ),

            taskTextField.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -20
            ),

            taskTextField.heightAnchor.constraint(equalToConstant: 45),

            addButton.topAnchor.constraint(
                equalTo: taskTextField.bottomAnchor,
                constant: 12
            ),

            addButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            tableView.topAnchor.constraint(
                equalTo: addButton.bottomAnchor,
                constant: 20
            ),

            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),

            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),

            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)

        ])
    }

}

