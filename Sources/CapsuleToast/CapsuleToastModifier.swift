import SwiftUI

extension View {
    /// Presents a toast in the top safe area until dismissed or replaced by the app.
    /// Attach this to the screen container, outside its scrolling content.
    public func capsuleToast(_ toast: Binding<CapsuleToast?>) -> some View {
        modifier(CapsuleToastModifier(toast: toast))
    }
}

private struct CapsuleToastModifier: ViewModifier {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Binding var toast: CapsuleToast?

    func body(content: Content) -> some View {
        content.safeAreaInset(edge: .top, spacing: 0) {
            VStack(spacing: 0) {
                if let presentedToast = toast {
                    HStack {
                        Spacer(minLength: 0)
                        CapsuleToastView(toast: presentedToast) {
                            // An outgoing view must not dismiss its replacement during a transition.
                            if toast?.id == presentedToast.id {
                                toast = nil
                            }
                        }
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 16)
                    .id(presentedToast.id)
                    .transition(CapsuleToastTransition(reduceMotion: reduceMotion))
                }
            }
            // This container survives an empty binding, so assigning a toast animates
            // its insertion without requiring withAnimation at each app call site.
            .animation(animation, value: toast?.id)
        }
    }

    private var animation: Animation {
        if reduceMotion { return .easeOut(duration: 0.15) }
        return toast == nil
            ? .easeOut(duration: 0.22)
            : .spring(response: 0.30, dampingFraction: 0.82)
    }
}

private struct CapsuleToastTransition: Transition {
    let reduceMotion: Bool

    func body(content: Content, phase: TransitionPhase) -> some View {
        content.visualEffect { effect, geometry in
            // Moving by the global bottom edge starts the entire capsule above the
            // screen, including the gap occupied by the top safe area.
            let offset = phase == .willAppear
                ? -geometry.frame(in: .global).maxY
                : 0
            return effect
                .offset(y: reduceMotion || phase.isIdentity ? 0 : offset)
                .opacity(phase == .didDisappear || (reduceMotion && !phase.isIdentity) ? 0 : 1)
        }
    }
}
