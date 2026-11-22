# Phase 1 - UIKit Fundamentals

# 4. UIKit Class Hierarchy

## 1. What Is a Class Hierarchy?

A class hierarchy describes how UIKit types are related through inheritance.

When a class inherits from another class, it:

- Inherits behavior from its parent class.
- Can use inherited properties and methods.
- Can override behavior when UIKit needs specialized behavior.
- Remains a member of the parent type.

For example, `UILabel` inherits from `UIView`. Therefore, a `UILabel` is:

- A `UILabel`.
- A `UIView`.
- An `UIResponder`.
- An `NSObject`.

This relationship matters because common behavior is implemented once in base classes and specialized behavior is added in subclasses.

```text
NSObject
   |
UIResponder
   |
UIView
   |
UILabel
```

In a UIKit application, the hierarchy is primarily organized around two large branches:

```text
NSObject
├── UIResponder
│   ├── UIView
│   │   ├── UIControl
│   │   │   ├── UIButton
│   │   │   ├── UITextField
│   │   │   ├── UISwitch
│   │   │   └── UISlider
│   │   ├── UILabel
│   │   ├── UIImageView
│   │   ├── UIScrollView
│   │   │   ├── UITableView
│   │   │   └── UICollectionView
│   │   └── UIStackView
│   └── UIViewController
│       ├── UINavigationController
│       ├── UITabBarController
│       └── UITableViewController
└── UIApplication
```

This is a practical subset of the hierarchy. UIKit contains many additional classes and protocols.

## 2. Why UIKit Uses a Hierarchy

UIKit defines common behavior in reusable base classes.

### `NSObject`

`NSObject` provides foundation behavior used throughout Objective-C-compatible Apple frameworks:

- Runtime identity.
- Memory and object management support.
- Method introspection.
- The Foundation object model used by UIKit.

You rarely subclass `NSObject` directly in modern UIKit code.

### `UIResponder`

`UIResponder` represents objects that can receive and respond to events.

It includes support for:

- Touch events.
- Motion events.
- Remote control events.
- The responder chain.
- First responder status, commonly used by text fields and text views.

Both `UIView` and `UIViewController` inherit from `UIResponder`, which is why they can participate in event handling.

### `UIView`

`UIView` is the base class for objects that draw and visually organize content on the screen.

Every `UIView` has:

- A frame and bounds.
- A background color.
- A transform and alpha value.
- A superview and subviews.
- Layout constraints or an autoresizing behavior.
- Participation in hit testing.

`UIView` also provides the core view hierarchy behavior. It does not become a specialized control merely because it can receive events.

### `UIControl`

`UIControl` inherits from `UIView` and provides control behavior.

Examples include:

- Buttons.
- Text fields.
- Switches.
- Sliders.

A control maintains an interaction state and sends target-action events. For example:

```swift
button.addTarget(
    self,
    action: #selector(loginButtonTapped),
    for: .touchUpInside
)
```

The control hierarchy solves a specific problem: all interactive controls share state and event behavior, while each subclass provides its own visual representation.

### `UIViewController`

`UIViewController` inherits from `UIResponder`, not from `UIView`.

This separation is intentional:

- A view controller manages a view and coordinates application behavior.
- A view draws and lays out visual content.
- A responder controller participates in events and can participate in the responder chain.

A typical controller loads or creates a view, responds to lifecycle events, and coordinates models and views.

## 3. Important Inheritance Relationships

### A. View Relationship

```swift
final class ProfileCardView: UIView { }

let card = ProfileCardView()

let view: UIView = card
let responder: UIResponder = card
let object: NSObject = card
```

This is valid because a subclass can be assigned to any inherited parent type.

The reverse is not automatic:

```swift
let value: NSObject = ProfileCardView()

// This requires type checking or casting.
if let card = value as? ProfileCardView {
    print(card)
}
```

Do not use `as!` for optional UIKit relationships when an `as?` check can verify the type safely.

### B. Control Relationship

```swift
let button = UIButton(type: .system)

let control: UIControl = button
let view: UIView = button
let responder: UIResponder = button
```

UIKit can treat the button as a general `UIControl` for shared control operations or as a `UIView` for layout operations.

### C. Scroll Container Relationship

`UITableView` and `UICollectionView` inherit from `UIScrollView`, which inherits from `UIView`.

This gives them scrolling behavior while allowing each subclass to add:

- Data source support.
- Reusable view management.
- Layout and selection behavior.
- Specialized scrolling behavior.

```text
UIView
  |
UIScrollView
  |
  ├── UITableView
  └── UICollectionView
```

## 4. Container and View Controllers

### `UIViewController`

`UIViewController` manages one screen or a reusable screen region.

It commonly:

- Creates or owns a root view.
- Loads and prepares subviews.
- Handles application lifecycle events.
- Responds to user interactions.
- Coordinates child view controllers.

### `UINavigationController`

`UINavigationController` inherits from `UIViewController` and manages a stack of view controllers.

```swift
let navigationController = UINavigationController(
    rootViewController: ProfileViewController()
)
```

Pushing a view controller places a new screen on the stack. Popping a view controller removes the current screen.

### `UITabBarController`

`UITabBarController` inherits from `UIViewController` and manages a set of tab view controllers.

```swift
let tabBarController = UITabBarController()
tabBarController.viewControllers = [
    feedNavigationController,
    profileNavigationController
]
```

Container view controllers add specialized navigation behavior while preserving the `UIViewController` interface.

## 5. Practical Implementation

We will build a small hierarchy inspector inside this topic folder.

The implementation will:

- Define custom UIKit subclasses.
- Print the inheritance relationship.
- Display a view hierarchy in a custom view.
- Demonstrate the difference between `UIView`, `UIControl`, and `UIViewController`.

### Proposed Folder Structure

Create the following folder structure:

```text
UIKitExperiment/
├── 01_Phase/
│   └── 04_UIKit Class Hierarchy/
│       ├── Views/
│       │   └── HierarchyInspectorView.swift
│       └── Controllers/
│           └── HierarchyInspectorViewController.swift
├── ViewController.swift
├── AppDelegate.swift
└── SceneDelegate.swift
```

Place the implementation inside this dedicated topic folder. Do not place the complete topic implementation in `ViewController`.

The project already uses a programmatic UIKit setup and no Storyboards.

### Step 1: Create the Custom View

Create:

```text
UIKitExperiment/01_Phase/04_UIKit Class Hierarchy/Views/HierarchyInspectorView.swift
```

Complete implementation:

```swift
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
```

`HierarchyInspectorView` is a custom subclass of `UIView`. It owns the screen presentation and layout but does not perform hierarchy inspection logic.

### Step 2: Create the View Controller

Create:

```text
UIKitExperiment/01_Phase/04_UIKit Class Hierarchy/Controllers/HierarchyInspectorViewController.swift
```

Complete implementation:

```swift
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
```

The controller owns the view, configures button behavior, and prints the runtime view hierarchy. The custom view provides layout and visual components.

### How the Components Communicate

```text
HierarchyInspectorViewController
          |
          | Sets self as target
          v
HierarchyInspectorView
          |
          | Contains
          v
UIButton / UILabel / UITextView
          |
          | Touch event
          v
inspectHierarchy()
          |
          v
Update text and print hierarchy
```

## 6. MainViewController Integration

Your project currently contains `ViewController`, and `SceneDelegate` has a separate direct root view controller setup. Keep the implementation isolated in the topic folder and choose one integration point.

### Option A: Integrate through `ViewController`

Replace only the topic-specific setup in `ViewController` with:

```swift
import UIKit

final class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let hierarchyController = HierarchyInspectorViewController()

        addChild(hierarchyController)

        hierarchyController.view.frame = view.bounds
        hierarchyController.view.autoresizingMask = [
            .flexibleWidth,
            .flexibleHeight
        ]
        view.addSubview(hierarchyController.view)

        hierarchyController.didMove(toParent: self)
    }
}
```

Ensure `SceneDelegate` uses `ViewController` as its root if you choose this route:

```swift
let window = UIWindow(windowScene: windowScene)
window.rootViewController = ViewController()
```

### Option B: Integrate directly in `SceneDelegate`

This keeps `ViewController` unchanged:

```swift
let window = UIWindow(windowScene: windowScene)
window.rootViewController = HierarchyInspectorViewController()
```

Do not embed both integration approaches into the app at the same time.

Before running, add both new Swift files to the Xcode target. In Xcode:

1. Open the project.
2. Add the `Views` and `Controllers` folders to the target group.
3. Verify each file is checked for the `UIKitExperiment` target in File Inspector.

## 7. Execution Flow

### Application Launch

1. `SceneDelegate` creates a window.
2. The selected root view controller creates its view hierarchy.
3. `loadView()` assigns `HierarchyInspectorView` as the controller's root view.
4. `viewDidLoad()` connects the button action.
5. The hierarchy description is displayed immediately.
6. The user taps **Inspect Hierarchy**.
7. UIKit sends `.touchUpInside` to the controller action.
8. The controller updates the text view and recursively prints the view hierarchy.

### Interaction Flow

```text
User tap
  -> UIButton
  -> target-action event
  -> UIViewController method
  -> HierarchyInspectorView update
```

## 8. Expected Output

The app should display:

- A **UIKit Hierarchy** title.
- An **Inspect Hierarchy** button.
- A monospace text area describing the hierarchy.
- The custom view on a white or system-background surface.

When the button is tapped, Xcode's console should display the runtime hierarchy. A simplified result may look like:

```text
UIButton
  UILabel
  UIImageView
  UIButtonLabel
```

Internal subview names may differ between iOS versions. The hierarchy should be used for conceptual verification, not exact string matching in tests.

## 9. Understanding `isKind(of:)` and `is`

UIKit objects are reference types, so inheritance can be checked through Swift type checks.

```swift
let view: UIView = UIButton(type: .system)

if view is UIControl {
    print("This view is or inherits from UIControl")
}

if let button = view as? UIButton {
    print(button.currentTitle ?? "")
}
```

Use `is` when only a type check is required.

Use `as?` when the type must be accessed after checking.

Prefer not to use `as!` unless an invariant has already been proven.

## 10. Class Hierarchy and the Responder Chain

Event handling also follows UIKit's class relationships.

When a touch occurs:

1. UIKit performs hit testing.
2. It selects the deepest view that contains the touch.
3. The view becomes part of the active responder chain.
4. The event moves through responders until it is handled.

A simplified responder chain can look like:

```text
UIButton
  -> UITextField or UIView
  -> UIViewController
  -> UIWindow
  -> UIApplication
```

The exact chain depends on the view hierarchy and whether UIKit adds container view controllers or input views.

Important distinction:

- The view hierarchy defines parent and child visual relationships.
- The responder chain defines event-delivery relationships.
- They often overlap, but they are not always identical.

## 11. Production Engineering Perspective

### Real-World Uses

UIKit class hierarchy knowledge is useful when:

- Sharing layout or display behavior across custom views.
- Extending controls or container view controllers.
- Reviewing third-party UIKit subclasses.
- Debugging type mismatches.
- Understanding delegate and target-action APIs.
- Choosing the correct base class for a reusable component.

### Choose the Correct Base Class

| Requirement | Base Class |
|---|---|
| Draw or lay out custom visual content | `UIView` |
| Create an interactive labeled control | `UIControl` or an existing control subclass |
| Display scrollable text | `UITextView` |
| Display a vertical list | `UITableView` |
| Display a grid or compositional layout | `UICollectionView` |
| Manage a screen | `UIViewController` |
| Manage stacked screens | `UINavigationController` |
| Manage tabbed screens | `UITabBarController` |

### Avoid Unnecessary Subclassing

Prefer composition over subclassing when existing UIKit components already provide the needed behavior.

Do not subclass `UIView` only to host unrelated properties or business logic.

Do not subclass `UIViewController` merely to reuse helper functions. Use a shared helper or service only when the responsibility belongs outside the controller.

## 12. Common Mistakes

### Mistake 1: Confusing a View with a View Controller

```swift
// Incorrect: a view controller is not a view.
view.addSubview(MyViewController())
```

This is invalid in UIKit. A view controller must manage a view hierarchy through a view controller container relationship.

### Mistake 2: Adding Subviews to a ViewController

```swift
// Incorrect
hierarchyController.addSubview(button)
```

Use `hierarchyController.view.addSubview(button)`.

### Mistake 3: Assuming Every Subclass Is a Direct Implementation

A `UITableView` inherits from `UIScrollView`, but it is not implemented by copying the complete behavior of `UIScrollView` into `UITableView`. UIKit defines shared behavior in the parent and specialized behavior in the subclass.

### Mistake 4: Overusing `as!`

Forced casting can crash when runtime types differ.

Prefer:

```swift
guard let button = sender as? UIButton else {
    return
}
```

### Mistake 5: Subclassing Only for the Name

Subclassing creates a real runtime and maintenance cost.

Create a subclass when it adds behavior or identity that UIKit cannot provide through configuration or composition.

## 13. Independent Practice

Add a second custom control to `HierarchyInspectorView` and use it to print hierarchy relationships.

The task:

1. Add a `UISwitch` named `showInternalSubviews`.
2. Display it below the inspect button.
3. Modify the text view constraints so the hierarchy text area moves below the switch.
4. Update `inspectHierarchy` so it prints nested subviews only when the switch is enabled.
5. When the switch is disabled, print only the root hierarchy controller and its top-level subviews.

Expected result:

- The switch appears in the interface.
- Toggling it changes the console output.
- The text view layout remains valid.

Wait to implement this modification until you are ready to attempt it independently.

## 14. Interview and Industry Review

### Questions

**1. What does it mean for `UIButton` to inherit from `UIControl`?**

`UIButton` gains the shared state and event behavior implemented by `UIControl` while adding button-specific behavior.

**2. Why does `UIViewController` inherit from `UIResponder`?**

A view controller can participate in events and responder-chain behavior while coordinating a managed view hierarchy.

**3. Are `UIViewController` and `UIView` in a parent-child inheritance relationship?**

No. They are separate branches. Both inherit from `UIResponder`, but a view controller manages a view rather than inheriting from it.

**4. Why would you subclass `UIView`?**

To create a reusable view with specialized layout or drawing behavior. The inheritance should provide meaningful shared behavior.

**5. How does the hierarchy help with polymorphism?**

It allows UIKit APIs to operate on a parent type. For example, layout code can accept a `UIView` even when the actual object is a `UILabel`, `UIButton`, or custom view.