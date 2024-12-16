// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MQTTClient",
    platforms: [
        .iOS(.v15),
        .macOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "MQTTClient",
            targets: ["MQTTClient"]),
    ],
    dependencies: [
        .package(url: "https://github.com/emqx/CocoaMQTT.git", from: "2.1.8"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "MQTTClient",
            dependencies: [
                "CocoaMQTT"
            ]
        ),
        .testTarget(
            name: "MQTTClientTests",
            dependencies: ["MQTTClient"]),
    ]
)
