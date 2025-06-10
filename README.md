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
  dragCoefficient: 0.414, // The G1 drag coefficient of the projectile
  initialVelocity: Measurement(value: 3300, unit: .feetPerSecond), // The initial velocity of the projectile
  sightHeight: Measurement(value: 1.8, unit: .inches), // The distance the sight is offset from the bore
  shootingAngle: Measurement(value: 0, unit: .degrees), // The angle up (+) or down (-) of the shot
  zeroRange: Measurement(value: 100, unit: .yards), // The distance the projectile is zeroed at
  atmosphere: Atmosphere(
    altitude: Measurement(value: 10_000, unit: .feet), // The altitude above sea level
    pressure: Measurement(value: 30.1, unit: .inchesOfMercury), // The current air pressure
    temperature: Measurement(value: 5, unit: .fahrenheit), // The current temperature
    relativeHumidity: 0.5 // The relative humidity percent between 0 and 1
  ),
  windSpeed: Measurement(value: 20, unit: .milesPerHour), // The wind speed
  windAngle: 135, // The wind angle (0=headwind, 90=left to right, 180=tailwind, 270/-90=right to left)
  weight: Measurement(value: 120, unit: .grains) // The weight of the projectile
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
// Drop Correction: 0.8680583043589494 MOA
// Windage: 2.837364004112233 in
// Windage Correction: 1.3537478735413964 MOA
// Travel time: 0.19335116796850343
// Velocity: 2929.55627989206 f/s
// Energy: 2287.180033060617 ft⋅lbf

```
