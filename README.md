# swift-ballistics

A Swift port of the [libballistics](https://github.com/grimwm/libballistics) library, designed for accurate and efficient ballistics simulation. This library provides tools to simulate projectile trajectories, accounting for various physical forces and environmental factors.

## Features

- Accurate trajectory calculations using SI units internally.
- Support for environmental conditions (wind, air density, etc.).
- Flexible configuration for projectile properties using the `Measurement` type.
- Easy-to-use Swift API for iOS, macOS, and other Swift-based platforms.

## Installation

### Swift Package Manager (SPM)

To include `swift-ballistics` in your project, add it as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/raydowe/swift-ballistics.git", .upToNextMajor(from: "4.0.0")) // Version updated to reflect breaking changes
]
```

To calculate ballistic data:
```swift
// Generate a full ballistic solution
let solution = Ballistics.solve(
  dragCoefficient: 0.414, // The G1 drag coefficient of the projectile
  initialVelocity: Measurement(value: 1005.84, unit: .metersPerSecond), // The initial velocity of the projectile
  sightHeight: Measurement(value: 3.81, unit: .centimeters), // The distance the sight is offset from the bore
  shootingAngle: Measurement(value: 0, unit: .degrees), // The angle up (+) or down (-) of the shot
  zeroRange: Measurement(value: 91.44, unit: .meters), // The distance the projectile is zeroed at
  atmosphere: Atmosphere(
    altitude: Measurement(value: 3048, unit: .meters), // The altitude above sea level
    pressure: Measurement(value: 101925, unit: .newtonsPerMetersSquared), // The current air pressure
    temperature: Measurement(value: -15, unit: .celsius), // The current temperature
    relativeHumidity: 0.9 // The relative humidity percent between 0 and 1
  ),
  windSpeed: Measurement(value: 16, unit: .kilometersPerHour), // The wind speed
  windAngle: 135, // The wind angle (0=headwind, 90=left to right, 180=tailwind, 270/-90=right to left)
  weight: Measurement(value: 180, unit: .grains) // The weight of the projectile
)

// Print out values at a given range
if let point = solution.getPoint(at: Measurement(value: 182.88, unit: .meters)) { // 200 yards
    print("Exact range: \(point.range.converted(to: .meters))")
    print("Drop: \(point.drop.converted(to: .centimeters))")
    print("Drop Correction (MOA): \(point.dropCorrection)")
    print("Windage: \(point.windage.converted(to: .centimeters))")
    print("Windage Correction (MOA): \(point.windageCorrection)")
    print("Travel time: \(point.seconds) s")
    print("Velocity: \(point.velocity.converted(to: .metersPerSecond))")
    print("Energy: \(point.energy.converted(to: .joules))")
}

// Expected output for 200 yards (182.88 meters):
// Exact range: 182.88 m
// Drop: -4.60 cm
// Drop Correction (MOA): 0.87 MOA
// Windage: 7.21 cm
// Windage Correction (MOA): 1.35 MOA
// Travel time: 0.2 s
// Velocity: 893.0 m/s
// Energy: 3100.5 J
```
