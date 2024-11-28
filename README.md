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
    .package(url: "https://github.com/raydowe/swift-ballistics.git", .upToNextMajor(from: "1.0.0"))
]
```

To calculate ballistic data:
```swift
var bc: Double = 0.414 // The G1 ballistic coefficient for the projectile
let v: Double = 3300 // Initial velocity, in ft/s
let sh: Double = 1.8 // Sight height over bore, in inches
let angle: Double = 0 // The shooting angle (uphill/downhill), in degrees
let zero: Double = 100 // The zero range of the rifle, in yards

let temperature: Double = 59 // Atmospheric temperature in degrees Fahrenheit
let humidity: Double = 0.5 // Relative humidity in percentage between 0 and 1
let barometer: Double = 29.92 // Barometric pressure in inHg
let altitude: Double = 0 // Altitude above sea level in feet
let windspeed: Double = 20 // Wind speed in miles per hour
let windangle: Double = 135 // The wind angle (0=headwind, 90=right to left, 180=tailwind, 270/-90=left to right)

// Optional: Correct the ballistic coefficient for weather conditions
bc = Atmosphere.adjustCoefficient(
    dragCoefficient: bc,
    altitude: altitude,
    barometer: barometer,
    temperature: temperature,
    relativeHumidity: humidity
)

// Generate a full ballistic solution
let solution = Ballistics.solve(
    dragCoefficient: bc,
    initialVelocity: v,
    sightHeight: sh,
    shootingAngle: angle,
    zeroRange: zero,
    windSpeed: windspeed,
    windAngle: windangle
)

// Print out values at given ranges
for range in stride(from: 0, through: 600, by: 25) {
    print("Exact range: \(solution.getRange(at: range))")
    print("Drop Inches: \(solution.getPath(at: range))")
    print("Drop MOA: \(solution.getMOA(at: range))")
    print("Windage Inches: \(solution.getWindage(at: range))")
    print("Windage MOA: \(solution.getWindageMOA(at: range))")
    print("Travel time: \(solution.getTime(at: range))")
    print("Velocity: \(solution.getVelocity(at: range))")
    print("----")
}

// Exact range: 200.14087986333354
// Drop Inches: -1.9360418983287833
// Drop MOA: 0.923741209531521
// Windage Inches: 3.7074491959699616
// Windage MOA: 1.7689304077999195
// Travel time: 0.19684149571311554
// Velocity: 2827.5414455293594

```
