// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-ballistics",
    platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v6)],
    products: [
        .library(
            name: "Ballistics",
            targets: ["Ballistics"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-numerics.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "Ballistics",
            dependencies: [],
            sources: [
                "Angle.swift",
                "Atmosphere.swift",
                "BPR.swift",
                "Ballistics.swift",
                "Constants.swift",
                "Drag.swift",
                "DragModels.swift",
                "Math.swift",
                "Point.swift",
                "Units/UnitAngle.swift",
                "Units/UnitEnergy.swift",
                "Units/UnitMass.swift",
                "Units/UnitSpeed.swift"
            ]
        ),
        .testTarget(
            name: "BallisticsTests",
            dependencies: [
                "Ballistics",
                .product(name: "Numerics", package: "swift-numerics")
            ]
        ),
    ]
)
