import CapsuleToast
import SwiftUI

@main
struct CapsuleToastDemoApp: App {
    var body: some Scene {
        WindowGroup {
            DemoView()
        }
    }
}

private struct DemoView: View {
    @State private var toast: CapsuleToast?

    var body: some View {
        NavigationStack {
            Form {
                Section("Notifications") {
                    Button("Show saved toast") {
                        toast = CapsuleToast(
                            systemImage: "checkmark.circle.fill",
                            title: "Saved",
                            message: "Your changes are ready."
                        )
                    }
                    Button("Show another toast") {
                        toast = CapsuleToast(
                            systemImage: "arrow.down.circle.fill",
                            title: "Download complete",
                            message: "The file is available offline."
                        )
                    }
                    Button("Dismiss from app") { toast = nil }
                }
                Section {
                    Text("Tap the capsule or swipe it upward to dismiss. Downward drags keep it open.")
                    Text("CapsuleToast follows Reduce Motion in Settings → Accessibility → Motion.")
                    Text("Current toast: \(toast?.title ?? "none")")
                        .accessibilityIdentifier("toast-state")
                }
            }
            .navigationTitle("CapsuleToast")
        }
        .capsuleToast($toast)
    }
}

#Preview {
    DemoView()
}
