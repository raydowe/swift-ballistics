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
    .package(url: "https://github.com/raydowe/swift-ballistics.git", .upToNextMajor(from: "3.0.0"))
]
```

To calculate ballistic data:
```swift
// Generate a full ballistic solution
let solution = Ballistics.solve(
  dragCoefficient: 0.414,
  initialVelocity: Measurement(value: 3300, unit: .feetPerSecond),
  sightHeight: Measurement(value: 1.8, unit: .inches),
  shootingAngle: 0,
  zeroRange: Measurement(value: 100, unit: .yards),
  atmosphere: Atmosphere(
    altitude: Measurement(value: 10_000, unit: .feet),
    pressure: Measurement(value: 30.1, unit: .inchesOfMercury),
    temperature: Measurement(value: 5, unit: .fahrenheit),
    relativeHumidity: 0.5
  ),
  windSpeed: Measurement(value: 20, unit: .milesPerHour),
  windAngle: 135,
  weight: Measurement(value: 120, unit: .grains)
)

// Print out values at given ranges
let point = solution.getPoint(at: Measurement(value: 200, unit: .yards))
print("Exact range: \(point.range)")
print("Drop Inches: \(point.drop)")
print("Drop MOA: \(point.dropCorrection)")
print("Windage Inches: \(point.windage)")
print("Windage MOA: \(point.windageCorrection)")
print("Travel time: \(point.seconds)")
print("Velocity: \(point.velocity)")
print("Energy: \(point.energy)")

// Exact range: 200.14678896533894 yd
// Drop: -1.8193914534841453 in
// Drop Correction: 0.8680583043589494 moa
// Windage: 2.837364004112233 in
// Windage Correction: 1.3537478735413964 moa
// Travel time: 0.19335116796850343
// Velocity: 2929.55627989206 f/s
// Energy: 2287.180033060617 ft⋅lbf

```
