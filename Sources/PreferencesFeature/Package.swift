// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PreferencesFeature",
    platforms: [.macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PreferencesFeature",
            targets: ["PreferencesFeature"]),
    ],
    dependencies: [
        .package(path: "../Core"),
        .package(path: "../Services"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PreferencesFeature",
            dependencies: ["Core","Services"]
        ),
        .testTarget(
            name: "PreferencesFeatureTests",
            dependencies: ["PreferencesFeature"]
        ),
    ]
)
