# Phase 1 — UIKit Fundamentals

# 3. UIKit and the Model-View-Controller (MVC) Pattern

## 1. What is MVC?

MVC stands for:

- **M — Model:** Manages application data and business logic.
- **V — View:** Displays information to the user and handles visual elements.
- **C — Controller:** Connects the Model and View. It handles user interactions and updates the View.

MVC is Apple's traditional architectural pattern for building UIKit applications.

The main purpose of MVC is to separate responsibilities instead of writing everything inside one UIViewController.

### Understand it with a simple example

Imagine we are building a Task Management application.

The screen displays a list of tasks.

Each task has:

- A title.
- A completion status.

Now, consider these responsibilities:

| Component                           | Responsibility                                            |
| ----------------------------------- | --------------------------------------------------------- |
| Task (Model)                        | Stores task information.                                  |
| TaskListView (View)                 | Displays task information.                                |
| TaskListViewController (Controller) | Fetches tasks, handles interactions and updates the View. |

### How MVC communicates

```text
          USER
            |
            | Interacts with UI
            v
     VIEW (TaskListView)
            |
            | User interaction
            v
  CONTROLLER (TaskListViewController)
            |
            | Reads / Updates
            v
       MODEL (Task)
            |
            | Updated data
            v
  CONTROLLER (TaskListViewController)
            |
            | Updates UI
            v
     VIEW (TaskListView)
```

**Important:** In UIKit, UIViewController acts as the Controller in MVC. It coordinates between the Model and View.

---

## 2. Understanding Each Component

### A. Model

The Model represents the application's data.

For example, a task can be represented using a Swift struct.

```swift
struct Task {

    let id: UUID
    var title: String
    var isCompleted: Bool

}
```

Let's understand each property:

- `id`: Uniquely identifies a task.
- `title`: Stores the task name.
- `isCompleted`: Indicates whether the task is completed.

Example:

```swift
let task = Task(
    id: UUID(),
    title: "Learn UIKit",
    isCompleted: false
)
```

**Remember:**

The Model should not know about UIKit.

Avoid putting `UILabel`, `UIButton`, `UIView`, or other UI-related code inside your Model.

The Model represents data, not the screen.

### B. View

The View is responsible for displaying information.

In UIKit, common View components include:

- UIView
- UILabel
- UIButton
- UITextField
- UITableView
- UICollectionView
- UIImageView

For our example, we will create a custom UIView that displays:

1. A screen title.
2. A text field.
3. An Add Task button.
4. A list of tasks.

The View should not decide how the application's business logic works.

It simply displays information and provides UI elements for interaction.

### C. Controller

The Controller coordinates everything.

In UIKit, we generally use UIViewController.

Its responsibilities include:

- Creating and managing the View.
- Handling button actions.
- Managing user interactions.
- Working with Model data.
- Updating the View when data changes.

For example:

When the user taps Add Task:

```text
User taps Add Task
        |
        v
Controller receives button action
        |
        v
Controller creates a Task Model
        |
        v
Controller updates the task list
        |
        v
View displays the updated list
```

This is the basic MVC workflow.

---

# 3. Practical Implementation — Build a Task Manager

Now we will implement a small UIKit application using MVC.

**Our goal:**

Build a screen where users can:

1. Enter a task name.
2. Tap Add Task.
3. See the task in a list.
4. Mark a task as completed.

We will use UIKit programmatically.

No Storyboards.

No SwiftUI.

No external libraries.

## 4. Project Folder Structure

Create the following folder structure inside your Xcode project:

```text
YourProject/
│
├── Phase1/
│   │
│   └── 03-MVC/
│       │
│       ├── Models/
│       │   └── Task.swift
│       │
│       ├── Views/
│       │   └── TaskListView.swift
│       │
│       └── Controllers/
│           └── TaskListViewController.swift
│
├── ViewController.swift
├── AppDelegate.swift
└── SceneDelegate.swift
```

**Our rule for this exercise:**

Write all MVC implementation code inside `Phase1/03-MVC/`.

We will only make a small change in the existing `ViewController.swift` to launch our MVC example.

---

# 5. Step 1 — Create the Model

**File:** `Models/Task.swift`

Create a new Swift file named `Task.swift`.

Write the following code:

```swift
import Foundation

struct Task {

    let id: UUID
    var title: String
    var isCompleted: Bool

    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }

}
```

### Understand the code

Why are we using a struct?

Because a Task is a simple data model.

Why are we using UUID?

Because every task needs a unique identifier.

Why is `isCompleted` initially false?

Because a newly created task should not automatically be marked as completed.

### Test your understanding

Try creating two Task objects:

```swift
let task1 = Task(title: "Learn UIKit")

let task2 = Task(
    title: "Understand MVC",
    isCompleted: true
)
```

Notice that we don't need to manually provide an ID or completion status.

Our initializer handles the default values.

**Step 1 complete.**

---

# 6. Step 2 — Create the View

**File:** `Views/TaskListView.swift`

Create a new Swift file named `TaskListView.swift`.

This View will contain all UI elements.

```swift
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
```

### Understand the View

We created four UI components:

| Component     | Purpose                    |
| ------------- | -------------------------- |
| titleLabel    | Displays My Tasks.         |
| taskTextField | Accepts task name.         |
| addButton     | Allows users to add tasks. |
| tableView     | Displays the task list.    |

### Important architectural observation

Notice something:

We have not written any task-related business logic here.

We have not created a Task object.

We have not implemented the Add Task functionality.

We have only created UI components and constraints.

**This is exactly what we want from our View.**

One more important detail:

We declared UI components as `let` properties so that the Controller can access them without replacing the actual UI components.

---

# 7. Step 3 — Create the Controller

**File:** `Controllers/TaskListViewController.swift`

Create a new Swift file named `TaskListViewController.swift`.

This is where we will connect our Model and View.

Write the following code:

```swift
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
```

## 8. Understand the Controller Step by Step

Don't just copy the code. Understand why we wrote it.

### A. Creating the View

```swift
private let contentView = TaskListView()
```

We created an instance of our custom View.

The Controller owns this View and coordinates its behavior.

### B. Managing the Model

```swift
private var tasks: [Task] = []
```

We created an array of Task objects.

Initially, it is empty.

Whenever the user adds a task, we insert a new Task object into this array.

### C. loadView()

```swift
override func loadView() {
    view = contentView
}
```

This is an important UIKit lifecycle method.

Normally, UIViewController manages its own root View.

But here, we are providing our custom `TaskListView` as the Controller's root View.

Now:

```swift
view
```

and:

```swift
contentView
```

refer to the same root View instance.

### D. viewDidLoad()

```swift
override func viewDidLoad() {
    super.viewDidLoad()

    setupTableView()
    setupActions()
}
```

We configure our interactions after the View has been loaded.

We connect:

- UITableViewDataSource
- UITableViewDelegate
- Add Button action

### E. Button Action

```swift
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
```

Let's understand the actual flow.

1. User taps Add Task.
2. Controller reads the text field value.
3. Controller validates the text.
4. Controller creates a Task Model.
5. Controller inserts the Model into the tasks array.
6. Controller clears the text field.
7. Controller tells the table view to reload its data.

**Notice:** The Controller is responsible for coordinating this entire operation.

### F. UITableViewDataSource

```swift
func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
) -> Int {

    return tasks.count
}
```

UIKit asks the Controller:

"How many rows should I display?"

The Controller answers using:

```swift
tasks.count
```

Next:

```swift
func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
) -> UITableViewCell
```

UIKit asks:

"What should I display inside this particular row?"

The Controller retrieves the corresponding Task Model and configures the cell.

### G. UITableViewDelegate

```swift
func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
)
```

This method gets called when the user taps a table view row.

We update the corresponding Model:

```swift
tasks[index].isCompleted.toggle()
```

Then update the affected row.

**Important:** UITableViewDelegate and UITableViewDataSource are protocols that allow our Controller to respond to table view events and provide its data.

---

# 9. Step 4 — Run Your MVC Implementation

Now we need to display our newly created Controller.

Open your existing:

`ViewController.swift`

Add this code:

```swift
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
```

That's it.

You don't need to write the Task Model, View, or Controller inside this file.

Your existing ViewController is simply hosting our MVC example.

**Alternative:** You can also make `TaskListViewController` the app's root ViewController through your SceneDelegate. That is cleaner when you want this example to be the actual first screen rather than a child screen.

---

# 10. Expected Output

When you run the application, you should see:

```text
          My Tasks

    [ Enter your task ]

          Add Task


    Learn UIKit

    Understand MVC

    Build iOS App
```

When you tap a row, a checkmark appears.

When you add another task, the table view updates.

You have now implemented a basic UIKit application using MVC.

---

# 11. Understand the Complete MVC Flow

Let's take one real example.

Suppose the user enters:

"Learn Auto Layout"

And taps Add Task.

Here is what happens internally:

```text
STEP 1
User enters task name
        |
        v
STEP 2
User taps Add Task
        |
        v
STEP 3
Controller receives button action
        |
        v
STEP 4
Controller reads text from View
        |
        v
STEP 5
Controller creates Task Model
        |
        v
STEP 6
Controller adds Task to array
        |
        v
STEP 7
Controller reloads UITableView
        |
        v
STEP 8
UITableView asks Controller for data
        |
        v
STEP 9
Controller provides Task information
        |
        v
STEP 10
View displays the task
```

This is MVC in practical UIKit development.

---

# 12. The Biggest Problem with MVC in UIKit

Now let's discuss something important from an industry perspective.

MVC is simple, but UIKit MVC has a common problem called:

## Massive View Controller

Consider this situation.

Your application starts with:

- Login screen.
- Home screen.
- Profile screen.
- Payment screen.
- Chat screen.

As the application grows, developers may start putting everything inside UIViewController:

```swift
final class HomeViewController: UIViewController {

    // UI properties

    // API requests

    // Business logic

    // Database operations

    // Validation logic

    // Navigation logic

    // Image processing

    // Analytics

    // TableViewDataSource

    // CollectionViewDataSource

}
```

Eventually, the ViewController becomes responsible for too many things.

This creates several problems:

1. Difficult to maintain.
2. Difficult to test.
3. Difficult to reuse code.
4. Difficult to debug.
5. Changes in one feature can affect another feature.

This is commonly known as Massive View Controller.

### How can we improve it?

In larger applications, we can introduce additional components:

```text
Home/
│
├── Models/
│
├── Views/
│
├── Controllers/
│
├── Services/
│
├── Repositories/
│
└── ViewModels/
```

For example:

- Services can handle networking.
- Repositories can manage data access.
- ViewModels can handle presentation logic in architectures that use them.

**Reality check:** MVC does not mean every piece of code belongs inside UIViewController. A well-designed MVC application still separates responsibilities.

---

# 13. MVC vs MVVM — Basic Difference

You will study MVVM in more detail when exploring advanced iOS architecture.

For now, understand the difference.

| MVC                                               | MVVM                                            |
| ------------------------------------------------- | ----------------------------------------------- |
| Model-View-Controller                             | Model-View-ViewModel                            |
| Controller coordinates Model and View             | ViewModel handles presentation logic            |
| ViewController commonly manages UI state          | ViewModel exposes UI state                      |
| UIKit MVC often uses delegation and target-action | MVVM commonly uses bindings or observation      |
| Can become Massive View Controller                | Can become Massive ViewModel if poorly designed |

Don't assume MVVM is automatically better.

Architecture should solve actual problems, not introduce unnecessary complexity.

---

# 14. Practical Rules to Remember

### Model

- Represents application data.
- Should not depend on UIKit.
- Should not contain UI components.
- Should not directly update labels or buttons.

### View

- Responsible for UI.
- Displays information.
- Should not contain application business logic.
- Can expose UI components and interaction points to its Controller.

### Controller

- Coordinates Model and View.
- Handles user interactions.
- Updates Model data.
- Updates the View.
- Manages UIKit lifecycle and navigation.

---

# 15. Your Practical Assignments

Don't stop after completing the provided implementation.

Try these exercises yourself.

## Assignment 1 — Add Delete Task

**Difficulty: Easy**

Add the ability to delete a task.

Requirements:

1. Use UITableView editing.
2. Remove the selected task from the Model array.
3. Update the table view.

Hint:

```swift
tasks.remove(at: indexPath.row)
```

## Assignment 2 — Add Task Count

**Difficulty: Easy**

Display the number of tasks.

Example:

```text
My Tasks (3)
```

Requirements:

1. Add a new UILabel in TaskListView.
2. Update its text from the Controller.
3. Update the count whenever a task is added or deleted.

## Assignment 3 — Add Completed Task Styling

**Difficulty: Medium**

When a user completes a task:

- Show a checkmark.
- Change the task title's text color.
- Show completed and incomplete tasks differently.

Hint:

Use:

```swift
task.isCompleted
```

## Assignment 4 — Add Empty State

**Difficulty: Medium**

When there are no tasks, display:

```text
No tasks available.

Start by adding your first task!
```

Requirements:

1. Create a UILabel in the View.
2. Show it when `tasks.isEmpty` is true.
3. Hide it when tasks are available.

---

# 16. Self-Assessment

Before moving to the next UIKit topic, make sure you can answer these questions without looking at the README.

1. What is MVC?
2. What is the responsibility of Model?
3. Why should Model not depend on UIKit?
4. What is the responsibility of View?
5. What is the responsibility of Controller?
6. Why does UIViewController act as Controller in UIKit MVC?
7. What is the purpose of `loadView()`?
8. What happens when `viewDidLoad()` is called?
9. Why do we use UITableViewDataSource?
10. What is the difference between UITableViewDelegate and UITableViewDataSource?
11. What is Massive View Controller?
12. Why should we avoid putting all business logic inside UIViewController?

---

# 17. Industry Expectations

For an iOS Engineer with 3+ years of experience, simply knowing MVC definitions is not enough.

You should be able to:

- Implement MVC without Storyboards.
- Separate Model, View and Controller responsibilities.
- Understand UIViewController lifecycle.
- Handle user interactions using target-action and delegation.
- Work with UITableView and UICollectionView.
- Understand how UIKit communicates with its Controller.
- Avoid Massive View Controllers.
- Write maintainable and testable UIKit code.
- Know when MVC is sufficient and when additional abstractions are necessary.

A developer who only knows how to create UI components but cannot organize application responsibilities is not yet demonstrating strong UIKit engineering skills.

---

# 18. Final Takeaway

Remember these three statements:

**Model:** What data does my application have?

**View:** What should the user see?

**Controller:** How should the application respond to user interactions and coordinate everything?

If you understand these three responsibilities and can implement the practical Task Manager without copying the code, you have understood the foundation of UIKit MVC.
