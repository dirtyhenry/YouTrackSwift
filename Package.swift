// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "YouTrackSwift",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "YouTrackSwift",
            targets: ["YouTrackSwift"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.40.14"),
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.36.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "YouTrackSwift",
            dependencies: []
        ),
        .testTarget(
            name: "YouTrackSwiftTests",
            dependencies: ["YouTrackSwift"]
        )
    ]
)
