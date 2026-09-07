import SwiftUI

struct CapsuleToastView: View {
    @Environment(\.accessibilityReduceMotion) private var accessibilityReduceMotion

    let toast: CapsuleToast
    let dismissNotification: () -> Void

    @State private var dragOffset: CGFloat = 0

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: toast.systemImage)
                .font(.title3)
                .foregroundStyle(.tint)

            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: toast.title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(verbatim: toast.message)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
        .fixedSize(horizontal: true, vertical: false)
        .padding(.horizontal, 16)
        .padding(.vertical, 9)
        .modifier(CapsuleToastChrome())
        .contentShape(Capsule(style: .continuous))
        .shadow(color: .black.opacity(0.12), radius: 16, y: 8)
        .offset(y: min(dragOffset, 0))
        // Once a drag begins, its release must not also count as a dismissing tap.
        .gesture(dismissGesture.exclusively(before: TapGesture().onEnded { dismissNotification() }))
        .accessibilityAddTraits(.isButton)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(toast.title), \(toast.message)")
        .accessibilityAction(.default, dismissNotification)
        .accessibilityHint(toast.accessibilityHint)
    }

    private var dismissGesture: some Gesture {
        DragGesture(minimumDistance: 8)
            .onChanged { value in
                dragOffset = min(value.translation.height, 0)
            }
            .onEnded { value in
                // Ignore downward drags so scrolling toward the top does not dismiss the toast.
                if value.translation.height < -36 || value.predictedEndTranslation.height < -72 {
                    dismissNotification()
                } else {
                    resetDragOffset()
                }
            }
    }

    private func resetDragOffset() {
        withAnimation(animation) {
            dragOffset = 0
        }
    }

    private var animation: Animation {
        accessibilityReduceMotion ? .easeOut(duration: 0.225) : .easeOut(duration: 0.33)
    }
}

private struct CapsuleToastChrome: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .glassEffect(.regular.interactive(), in: Capsule(style: .continuous))
        } else {
            content
                .background {
                    Capsule(style: .continuous)
                        .fill(.regularMaterial)
                }
                .overlay {
                    Capsule(style: .continuous)
                        .strokeBorder(.white.opacity(0.18))
                }
        }
    }
}
