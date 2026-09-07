// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "CapsuleToast",
    platforms: [.iOS(.v17)],
    products: [.library(name: "CapsuleToast", targets: ["CapsuleToast"])],
    targets: [.target(name: "CapsuleToast")]
)
