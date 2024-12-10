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
    .package(url: "https://github.com/raydowe/swift-ballistics.git", .upToNextMajor(from: "2.1.0"))
]
```

To calculate ballistic data:
```swift
// Generate a full ballistic solution
let solution = Ballistics.solve(
  dragCoefficient: 0.414, // The G1 ballistic coefficient for the projectile
  initialVelocity: ProjectileSpeed(fps: 3300),  // Initial velocity, in ft/s
  sightHeight: Measurement(inches: 1.8), // Sight height over bore
  shootingAngle: 0, // The shooting angle (uphill/downhill), in degrees
  zeroRange: Distance(yards: 100), // The zero range
  atmosphere: Atmosphere( // Optional, if atmospheric conditions should be considered
    altitude: Altitude(feet: 0), // Altitude above sea level
    pressure: Pressure(inHg: 29.92), // Barometric pressure in inHg
    temperature: Temperature(fahrenheit: 59), // Atmospheric temperature
    relativeHumidity: 0.5 // Relative humidity in percentage between 0 and 1
  ),
  windSpeed: WindSpeed(mph: 20), // Wind speed
  windAngle: 135, // The wind angle (0=headwind, 90=right to left, 180=tailwind, 270/-90=left to right)
  weight: Weight(grains: 120) // The weight of the projectile
)

// Print out values at given ranges
let point = solution.getPoint(at: 200)
print("Exact range: \(point.range.yards)")
print("Drop Inches: \(point.drop.inches)")
print("Drop MOA: \(point.dropCorrection.moa)")
print("Windage Inches: \(point.windage.inches)")
print("Windage MOA: \(point.windageCorrection.moa)")
print("Travel time: \(point.seconds)")
print("Velocity: \(point.velocity.fps)")
print("Energy: \(point.energy.ftlbs)")

// Exact range: 200.14087986333354
// Drop Inches: -1.9360418983287833
// Drop MOA: 0.923741209531521
// Windage Inches: 3.7074491959699616
// Windage MOA: 1.7689304077999195
// Travel time: 0.19684149571311554
// Velocity: 2827.5414455293594
// Energy: 2125.247364066855

```
