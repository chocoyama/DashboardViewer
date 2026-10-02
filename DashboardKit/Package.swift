// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "DashboardKit",
    platforms: [.macOS(.v26)],
    products: [
        .library(name: "DashboardKit", targets: ["DashboardKit"]),
    ],
    targets: [
        .target(name: "DashboardKit"),
        .testTarget(name: "DashboardKitTests", dependencies: ["DashboardKit"]),
    ]
)
