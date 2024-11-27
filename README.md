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
```

To calculate ballistic data:
```swift
var bc: Double = 0.414 // The G1 ballistic coefficient for the projectile
let v: Double = 3300 // Initial velocity, in ft/s
let sh: Double = 1.8 // Sight height over bore, in inches
let angle: Double = 0 // The shooting angle (uphill/downhill), in degrees
let zero: Double = 100 // The zero range of the rifle, in yards
let windspeed: Double = 0 // Wind speed in miles per hour
let windangle: Double = 0 // Wind angle (0=headwind, 90=right to left, etc.)

// Optional: Correct the ballistic coefficient for weather conditions
bc = Atmosphere.adjustCoefficient(dragCoefficient: bc, altitude: 0, barometer: 29.92, temperature: 138, relativeHumidity: 0.0)

// Find the "zero angle"
let zeroAngle = Angle.zeroAngle(
    dragCoefficient: bc,
    initialVelocity: v,
    sightHeight: sh,
    zeroRange: zero,
    yIntercept: 0
)

// Generate a full ballistic solution
let solution = Ballistics.solve(
    dragCoefficient: bc,
    initialVelocity: v,
    sightHeight: sh,
    shootingAngle: angle,
    zeroAngle: zeroAngle,
    windSpeed: windspeed,
    windAngle: windangle
)

// Print out values at given ranges
for range in stride(from: 0, through: 600, by: 25) {
    print("Exact range: \(solution.getRange(at: range))")
    print("Drop: \(solution.getPath(at: range))")
    print("Travel time: \(solution.getTime(at: range))")
    print("Velocity: \(solution.getVelocity(at: range))")
    print("Windage: \(solution.getWindage(at: range))")
    print("----")
}
```
