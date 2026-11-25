# Phase 1 - UIKit Fundamentals

# 6. UIResponder and the Responder Hierarchy

## 1. What Is UIResponder?

`UIResponder` is the UIKit base class for objects that can receive and handle events.

It is inherited by the two main branches of the UIKit hierarchy:

```text
UIResponder
├── UIView
│   └── UIControl
│       ├── UIButton
│       ├── UITextField
│       └── UISwitch
└── UIViewController
    ├── UINavigationController
    └── UITabBarController
```

An event does not belong permanently to the object that initially receives it. UIKit asks the responder chain which object can handle it.

In simple English:

> A responder is an object that can receive an event. The responder hierarchy is the sequence UIKit follows to find an object that can handle that event.

Examples of events handled through `UIResponder` include:

- Touches.
- Motion events.
- Remote-control events.
- Editing menu events.
- Keyboard and input accessory events.
- Undo and redo commands.

The `UIResponder` class solves the problem of sending events to an appropriate object when the object that first receives the event cannot handle it.

## 2. Why the Responder Hierarchy Exists

Not every object needs to handle every event.

For example, a button tap may start in its internal view hierarchy:

```text
User taps UIButton
        |
        v
UIButton receives the event
        |
        v
UIControl handles target-action
        |
        v
UIViewController receives the update through the action
```

A keyboard input, however, has a different goal:

```text
User taps UITextField
        |
        v
UITextField becomes first responder
        |
        v
The keyboard appears
        |
        v
UITextField receives each typed character
        |
        v
UITextField is dismissed as first responder
        |
        v
The keyboard disappears
```

The hierarchy also allows an application to respond to commands when no specific object claims them.

For example, a view may provide an undo action, but the currently selected text field may be responsible for determining whether undo is available.

UIKit determines the active responder and searches outward through `next` until it finds an object that handles the event or command.

## 3. Important Terminology

### Responder

A responder is an object that inherits from `UIResponder` and can participate in event handling.

Examples include:

- `UIView`
- `UIButton`
- `UITextField`
- `UIViewController`
- `UIWindow`
- `UIApplication`

### Responder Chain

The responder chain is the linked sequence of responders returned by the `next` property.

Conceptually:

```text
UITextField
    -> containing UIView
    -> UIViewController
    -> UIWindow
    -> UIApplication
    -> nil
```

The actual chain depends on which view is in the hierarchy and whether view controller containment is in use.

### First Responder

A first responder is the object currently designated by UIKit to receive primary input.

The most common first responder is a focused `UITextField` or `UITextView`.

Ask a responder to take focus:

```swift
textField.becomeFirstResponder()
```

Ask it to stop taking focus:

```swift
textField.resignFirstResponder()
```

An object must return `true` from `canBecomeFirstResponder` before `becomeFirstResponder()` can succeed.

By default, `UITextField` and `UITextView` support becoming first responder. Plain `UIView` and `UIViewController` do not.

### Next Responder

The `next` property returns the next object in the responder chain:

```swift
var current: UIResponder? = textField

while let responder = current {
    print(type(of: responder))
    current = responder.next
}
```

Do not build application behavior that depends on a long, hand-written chain. Debugging or tracing the chain is useful, but normal event handling should rely on UIKit's established rules.

## 4. How Touch Events Reach a Responder

When a touch occurs, UIKit performs hit testing.

Hit testing identifies the deepest view under the touch:

```text
User touches the screen
        |
        v
UIApplication sends the touch to the active window
        |
        v
UIWindow finds the view under the touch
        |
        v
UIView hit testing finds the deepest interactive view
        |
        v
The deepest view becomes the initial responder for the touch
```

UIKit then delivers `touchesBegan`, `touchesMoved`, `touchesEnded`, or `touchesCancelled` to that responder.

The most important methods are:

```swift
override func touchesBegan(
    _ touches: Set<UITouch>,
    with event: UIEvent?
) {
    super.touchesBegan(touches, with: event)
}

override func touchesMoved(
    _ touches: Set<UITouch>,
    with event: UIEvent?
) {
    super.touchesMoved(touches, with: event)
}

override func touchesEnded(
    _ touches: Set<UITouch>,
    with event: UIEvent?
) {
    super.touchesEnded(touches, with: event)
}

override func touchesCancelled(
    _ touches: Set<UITouch>,
    with event: UIEvent?
) {
    super.touchesCancelled(touches, with: event)
}
```

Calling `super` lets UIKit continue normal handling for the type.

Do not assume that every `touches...` override automatically forwards the event to all superviews. Your responsibility is to implement the behavior for the responder or forward an event explicitly when that is the intended design.

### Touches Versus Target-Action

Use target-action for a reusable control such as a button:

```swift
button.addTarget(
    controller,
    action: #selector(controller.buttonTapped),
    for: .touchUpInside
)
```

Use touch overrides for custom `UIView` behavior:

```swift
override func touchesBegan(
    _ touches: Set<UITouch>,
    with event: UIEvent?
) {
    // Handle a custom gesture or visual interaction.
    super.touchesBegan(touches, with: event)
}
```

For standard buttons, switches, sliders, and text fields, use the control APIs instead of overriding touch methods.

## 5. Practical Implementation

### Proposed Folder Structure

```text
06_UIResponder and the Responder Hierarchy/
├── Views/
│   └── ResponderHierarchyView.swift
├── Controllers/
│   └── ResponderHierarchyViewController.swift
└── UIResponder and the Responder Hierarchy.md
```

### What We Are Building

The screen will demonstrate:

1. A custom view receiving touches.
2. A text field becoming and resigning first responder.
3. The keyboard appearing and disappearing.
4. The next responder chain being inspected.
5. A standard button using target-action instead of manual touch handling.

### View

Create `Views/ResponderHierarchyView.swift`:

```swift
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
```

### Controller

Create `Controllers/ResponderHierarchyViewController.swift`:

```swift
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
            action: #selector(becomeFirstResponder),
            for: .touchUpInside
        )

        contentView.resignFirstResponderButton.addTarget(
            self,
            action: #selector(resignFirstResponder),
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

    @objc private func becomeFirstResponder() {
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

    @objc private func resignFirstResponder() {
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
```

The view owns the visual layout and displays touch and first-responder status. The view controller owns the actions and inspects the chain. `ResponderTraceView` demonstrates a custom `UIResponder`-compatible view receiving touches.

## 6. MainViewController Integration

This project uses the programmatic app lifecycle. Replace the root view controller in `SceneDelegate` with:

```swift
let rootViewController = ResponderHierarchyViewController()
window.rootViewController = rootViewController
```

The complete topic implementation stays inside the `06_UIResponder and the Responder Hierarchy` folder.

Do not put the responder-chain inspection logic into `MainViewController` or `SceneDelegate`. They only select the root controller.

## 7. Execution Flow

1. `SceneDelegate` creates `UIWindow`.
2. `ResponderHierarchyViewController` becomes the root view controller.
3. `loadView()` assigns `ResponderHierarchyView` as the controller's view.
4. `viewDidLoad()` adds target-action handlers and an initial responder-chain inspection.
5. The text field remains the initial responder until the user taps or calls `becomeFirstResponder()`.
6. Tapping `Become First Responder` makes the text field the first responder.
7. UIKit brings up the keyboard and sends text input to the text field.
8. Tapping `Resign First Responder`, pressing Return, or dismissing the field calls `resignFirstResponder()`.
9. Tapping the teal custom view calls `touchesBegan` and `touchesEnded`.
10. Tapping `Inspect Responder Chain` reads `next` from the text field and traverses the chain until `nil`.

```text
User tap
  -> UIWindow / hit testing
  -> deepest UIView
  -> touch or control handling

UITextField becomes first responder
  -> UIResponder chain becomes input chain
  -> keyboard sends text to UITextField
  -> UITextFieldDelegate receives editing callbacks
```

## 8. Responder Chain Debugging

Use this pattern when understanding or debugging an event or action:

```swift
var responder: UIResponder? = startingResponder

while let current = responder {
    print(String(describing: type(of: current)))
    responder = current.next
}
```

Remember:

- `next` points to the next responder.
- `isFirstResponder` tells whether an object is currently active for primary input.
- `canBecomeFirstResponder` determines whether a responder can become active.
- `becomeFirstResponder()` and `resignFirstResponder()` control the keyboard and primary input state.
- The exact chain depends on the view hierarchy.

Do not call `next` recursively without a termination condition. UIKit can return `nil` at the end of the chain.

## 9. Common Mistakes

### Overriding Touches on Every Button

Incorrect:

```swift
override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Custom button behavior
}
```

Use `UIButton` and target-action for ordinary buttons.

### Expecting a UIView to Become the Keyboard Responder

Plain `UIView` cannot become first responder by default:

```swift
override var canBecomeFirstResponder: Bool {
    true
}
```

You can explicitly enable it for custom keyboard or command behavior, but it is usually unnecessary for standard text input.

### Forgetting to Return from textFieldShouldReturn

This code always resigns and correctly reports that it handled Return:

```swift
func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
}
```

If the text field is still needed, keep it active instead.

### Assuming All Events Bubble Automatically

Touch delivery and responder-chain command forwarding are separate concepts.

- Touches are delivered by hit testing.
- Control events use target-action.
- Commands may search the responder chain.
- Unhandled responder actions may continue through `next`.

Do not forward every touch manually unless the custom behavior requires it.

### Strong Reference Cycles

The closure assigned to `ResponderTraceView.onTouch` must capture `self` weakly:

```swift
contentView.touchView.onTouch = { [weak self] message in
    // Use the weakly captured view controller.
}
```

This prevents the view from retaining the controller through the closure and the controller retaining the view.

## 10. Expected Output

After integration, you should see:

- A title labeled "Responder Hierarchy".
- A text field for keyboard input.
- Three buttons for first-responder and chain operations.
- A teal custom responder view.
- A text area showing the first responder and chain.

Tapping `Become First Responder` should:

- Mark `UITextField` as first responder.
- Bring up the keyboard.
- Add `UITextField` to the chain.

Tapping the screen or pressing Return should:

- End editing when the resign action is used.
- Hide the keyboard.
- Update the text area.

Tapping the teal view should:

- Update the result text with `touchesBegan`.
- Update it again with `touchesEnded`.

Tapping `Inspect Responder Chain` should show responder types starting with `UITextField` and continuing through the containing view, controller, window, application, and `nil`, if those objects are attached.

## 11. Industry Perspective

In production UIKit applications, `UIResponder` matters most in these areas:

- Text field and text view focus.
- Keyboard dismissal and input accessory views.
- Custom controls.
- Gesture recognition.
- Editing and selection commands.
- Undo and redo.
- Debugging events that appear to go nowhere.

### Professional Use Cases

#### Custom Controls

Use `UIResponder` touch methods when building a specialized visual control that cannot be implemented cleanly with an existing `UIControl`.

Keep standard controls for standard interactions.

#### Keyboard Dismissal

View controllers commonly use `endEditing(_:)` instead of resigning every text field individually:

```swift
view.endEditing(true)
```

This asks the view hierarchy to end editing and is useful for tap-outside behavior.

#### Undo and Redo

Applications and custom editors can implement undo actions through the responder chain. The active editor can handle the command while other responders remain unchanged.

### Production Considerations

- Dismiss the keyboard in the appropriate lifecycle or interaction, not in a background task.
- Preserve focus when a validation error is presented.
- Keep action handlers idempotent.
- Avoid overriding low-level touch methods unless the control requires custom gesture behavior.
- Test the app with hardware keyboards and external input devices.
- Use `UITextFieldDelegate` or `UITextViewDelegate` to validate editing rather than implementing a separate data path.
- Be careful with custom responder overrides that consume events without calling `super`.

### Common Junior Developer Mistakes

- Trying to make every view a first responder.
- Confusing the view hierarchy with the responder chain.
- Sending touch events manually through `superview`.
- Keeping a strong reference to a text field closure.
- Implementing undo or keyboard behavior inside a view instead of separating responsibilities.
- Using `touchesBegan` for an ordinary button.
- Assuming `resignFirstResponder()` is guaranteed to succeed when a different responder currently owns input.

### Interview Questions

**Q1: What is a responder chain?**

A: It is the sequence of `UIResponder` objects UIKit searches through for an object that can handle an event or command.

**Q2: How is a view different from a view controller in the responder hierarchy?**

A: Both inherit from `UIResponder`. A view is a visual object that participates in hit testing and layout. A view controller manages a view and coordinates application behavior.

**Q3: What is a first responder?**

A: It is the responder receiving primary input. Text fields become first responders to receive keyboard input.

**Q4: Does `next` always return the parent view?**

A: No. `next` depends on the actual responder and UIKit containment relationships. A view returns the next logical responder, a view controller is linked through containment, and the chain continues to the window and application.

**Q5: Should button behavior use touch overrides?**

A: No. Use `UIButton` or `UIControl` target-action unless implementing a custom control with genuinely specialized behavior.

## 12. Independent Practice

Add a second text field to `ResponderHierarchyView` and make the following behavior work:

1. Tapping the first text field makes only that field active.
2. Tapping the second text field transfers first-responder status to the second field.
3. Returning from the second field dismisses the keyboard.
4. `updateResponderChain()` shows the currently active text field if either one is first responder.

Expected verification:

- Only one text field has a blinking keyboard cursor.
- The second field becomes active after tapping it.
- Pressing Return hides the keyboard.
- The responder chain text always names the currently active text field as the first responder.

Wait for my attempt before providing the solution.