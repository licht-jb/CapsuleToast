import Foundation

/// One presentation of a capsule notification. Create a fresh value to present it again.
public struct CapsuleToast: Identifiable, Equatable, Sendable {
    public let id: UUID
    public let systemImage: String
    public let title: String
    public let message: String
    public let accessibilityHint: String

    /// Pass display-ready strings, localized by the app when appropriate.
    public init(
        systemImage: String,
        title: String,
        message: String,
        accessibilityHint: String = "Tap or swipe up to dismiss."
    ) {
        id = UUID()
        self.systemImage = systemImage
        self.title = title
        self.message = message
        self.accessibilityHint = accessibilityHint
    }
}
