// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-ballistics",
    products: [
        .library(
            name: "Ballistics",
            targets: ["Ballistics"]),
    ],
    targets: [
        .target(
            name: "Ballistics",
            dependencies: []
        ),
        .testTarget(
            name: "BallisticsTests",
            dependencies: ["Ballistics"]
        ),
    ]
)
