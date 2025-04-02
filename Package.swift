// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "ReactiveSwiftUI",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "ReactiveSwiftUI",
            targets: ["ReactiveSwiftUI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveCocoa/ReactiveSwift.git", from: "7.1.1"),
    ],
    targets: [
        .target(
            name: "ReactiveSwiftUI",
            dependencies: ["ReactiveSwift"]
        )
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .enableExperimentalFeature("StrictConcurrency"),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault")
    ]
}

