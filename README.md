# swift-ballistics

A Swift port of the [libballistics](https://github.com/grimwm/libballistics) library, designed for accurate and efficient ballistics simulation. This library provides tools to simulate projectile trajectories, accounting for various physical forces and environmental factors.

## Features

- Accurate trajectory calculations
- Support for environmental conditions (wind, air density, etc.)
- Flexible configuration for projectile properties
- Easy-to-use Swift API for iOS, macOS, and other Swift-based platforms

## Installation

### Swift Package Manager (SPM)

To include `swift-ballistics` in your project, add it as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/raydowe/swift-ballistics.git", from: "0.1.0")
]
