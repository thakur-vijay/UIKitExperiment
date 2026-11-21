//
//  TaskListViewController.swift
//  UIKitExperiment
//
//  Created by Vijay Thakur on 21/11/26.
//

import UIKit

final class TaskListViewController: UIViewController {

    // MARK: - Properties

    private let contentView = TaskListView()

    private var tasks: [Task] = []

    // MARK: - Lifecycle

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupActions()
    }

    // MARK: - Setup

    private func setupTableView() {

        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self

    }

    private func setupActions() {

        contentView.addButton.addTarget(
            self,
            action: #selector(addTask),
            for: .touchUpInside
        )

    }

    // MARK: - Actions

    @objc private func addTask() {

        guard let title = contentView.taskTextField.text,
              !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return
        }

        let task = Task(title: title)

        tasks.append(task)

        contentView.taskTextField.text = ""

        contentView.tableView.reloadData()

    }

    // MARK: - Task Completion

    private func toggleTask(at index: Int) {

        tasks[index].isCompleted.toggle()

        contentView.tableView.reloadRows(
            at: [IndexPath(row: index, section: 0)],
            with: .automatic
        )

    }

}

// MARK: - UITableViewDataSource

extension TaskListViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        return tasks.count

    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TaskCell",
            for: indexPath
        )

        let task = tasks[indexPath.row]

        var configuration = cell.defaultContentConfiguration()

        configuration.text = task.title

        cell.contentConfiguration = configuration

        cell.accessoryType = task.isCompleted ? .checkmark : .none

        return cell

    }

}

// MARK: - UITableViewDelegate

extension TaskListViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        toggleTask(at: indexPath.row)

        tableView.deselectRow(at: indexPath, animated: true)

    }

}

