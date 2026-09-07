# CapsuleToast

A small SwiftUI toast that appears at the top of your screen.

CapsuleToast displays a capsule with an SF Symbol, a title, and a message. It drops in from above the screen while fading in and returns above the screen while fading out, using the same spring timing. Tap or swipe upward to dismiss it. It stays visible until dismissed, replaced, or cleared by your app; there is no timer or queue.

## Requirements

- iOS 17 or later
- Xcode 26 or later (the source uses the iOS 26 Liquid Glass API)
- Swift 6 language mode
- No external dependencies

On iOS 26 and later the capsule uses Liquid Glass. On iOS 17–18 it uses a system material background. Reduce Motion uses fades without entrance or exit movement.

## Usage

```swift
import CapsuleToast
import SwiftUI

struct ContentView: View {
    @State private var toast: CapsuleToast?

    var body: some View {
        NavigationStack {
            Button("Show notification") {
                toast = CapsuleToast(
                    systemImage: "checkmark.circle.fill",
                    title: "Saved",
                    message: "Your changes are ready."
                )
            }
            .navigationTitle("Example")
        }
        .capsuleToast($toast)
    }
}
```

Attach `.capsuleToast($toast)` to the screen container, outside its scrollable content. CapsuleToast reserves space in the top safe area so the toast does not cover navigation controls. Underlying content remains interactive.

- Assign a `CapsuleToast` to show it or replace the current toast.
- CapsuleToast animates presentation automatically; the assignment does not need `withAnimation`.
- Create a fresh value to present the same text again. Each value has its own presentation identity.
- Assign `nil` to dismiss it from your app. Tapping or swiping up also sets the binding to `nil`.
- Use `.tint(...)` on the containing view to choose the icon color.

### Localized text

Pass display-ready strings. For localized apps, resolve them in your app's bundle, including the dismissal hint:

```swift
toast = CapsuleToast(
    systemImage: "checkmark.circle.fill",
    title: String(localized: "保存完了"),
    message: String(localized: "変更を保存しました。"),
    accessibilityHint: String(localized: "タップまたは上にスワイプで通知を閉じます。")
)
```

The default accessibility hint is English. VoiceOver reads the title and message as a single button and can activate it to dismiss.

## Demo and UI tests

[`Examples/CapsuleToastDemo.xcodeproj`](Examples/CapsuleToastDemo.xcodeproj) contains the demo and UI tests under the `CapsuleToastDemo` scheme. The tests cover tap dismissal, upward swipe dismissal, downward drag retention, replacement, repeated presentation, and app-driven dismissal.

[`Examples/project.yml`](Examples/project.yml) is the XcodeGen source for the demo project. XcodeGen is only needed when regenerating that project.

## License

CapsuleToast is available under the [MIT License](LICENSE).
