# swift-ballistics

A Swift ballistics solver, originally ported from the [libballistics](https://github.com/grimwm/libballistics) library, designed for accurate and efficient ballistics simulation. This library provides tools to simulate projectile trajectories, accounting for various physical forces and environmental factors.

## Features

- Point-mass trajectory solved with 4th-order Runge–Kutta integration
- G1 and G7 drag models using the standard drag tables (drag coefficient by Mach number)
- Air density and speed of sound from altitude, pressure, temperature and humidity
- Wind modelled as moving air, giving head/tail wind effects and wind drift directly
- Results verified against [py-ballisticcalc](https://github.com/o-murphy/py-ballisticcalc) to within 0.01 MOA out to 1000 yd
- When no atmosphere is given, Army Standard Metro conditions are assumed (59 °F, 29.53 inHg, 78% humidity)
- Flexible configuration for projectile properties
- Easy-to-use Swift API for iOS, macOS, and other Swift-based platforms

## Installation

### Swift Package Manager (SPM)

To include `swift-ballistics` in your project, add it as a dependency in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/raydowe/swift-ballistics.git", .upToNextMajor(from: "4.0.0"))
]
```

To calculate ballistic data:
```swift
// Generate a full ballistic solution
let solution = Ballistics.solve(
  preferredDistanceUnit: .meters, // The preferred distance units used for sampling
  dragCoefficient: 0.414, // The ballistic coefficient of the projectile
  dragModel: .g1, // The drag model the coefficient is for: .g1 (default) or .g7
  initialVelocity: Measurement(value: 3300, unit: .feetPerSecond), // The initial velocity of the projectile
  sightHeight: Measurement(value: 1.8, unit: .inches), // The distance the sight is offset from the bore
  shootingAngle: Measurement(value: 0, unit: .degrees), // The angle up (+) or down (-) of the shot
  zeroRange: Measurement(value: 100, unit: .yards), // The distance the projectile is zeroed at
  atmosphere: Atmosphere(
    altitude: Measurement(value: 10_000, unit: .feet), // The altitude above sea level
    pressure: Measurement(value: 30.1, unit: .inchesOfMercury), // Barometric pressure corrected to sea level, as in weather reports
    temperature: Measurement(value: 5, unit: .fahrenheit), // The current temperature
    relativeHumidity: 0.5 // The relative humidity percent between 0 and 1
  ),
  windSpeed: Measurement(value: 20, unit: .milesPerHour), // The wind speed
  windAngle: 135, // The wind angle (0=headwind, 90=left to right, 180=tailwind, 270/-90=right to left)
  weight: Measurement(value: 120, unit: .grains) // The weight of the projectile
)

// Look up values at a given range. Points are calculated exactly at every `distanceStep`
// (default 1) in `preferredDistanceUnit`; a distance off that grid returns nil.
if let point = solution.getPoint(at: Measurement(value: 200, unit: .meters)) {
  print("Range: \(point.range)")
  print("Drop: \(point.drop)")
  print("Drop Correction: \(point.dropCorrection)")
  print("Windage: \(point.windage)")
  print("Windage Correction: \(point.windageCorrection)")
  print("Velocity: \(point.velocity)")
  print("Energy: \(point.energy)")
  print("Travel Time: \(point.travelTime)")
}

```

## Upgrading from 3.x

Version 4 replaces the ballistic model, so results change and some behaviour is stricter:

- **New drag model option.** `solve` takes `dragModel: .g1` (default) or `.g7`.
- **Results change.** Drag now uses the standard G1/G7 drag tables (drag coefficient by Mach number) instead of libballistics' curve fits, the trajectory is integrated with 4th-order Runge–Kutta, and wind is modelled as moving air. Several libballistics bugs were fixed along the way (head/tailwind speed was applied in mph as if it were ft/s; gravity was tilted by the zero angle; non-standard gravity). G1 results in still, standard air move only slightly; G7, wind and non-standard atmosphere results move more.
- **Atmosphere.** Air density and the speed of sound are calculated from altitude, pressure, temperature and humidity. `pressure` is the barometric pressure corrected to sea level, as given in weather reports. With no atmosphere, Army Standard Metro air is assumed (59 °F, 29.53 inHg, 78% humidity).
- **`getPoint(at:)` is exact.** Points are calculated exactly at every `distanceStep` in `preferredDistanceUnit`. A distance off that grid now returns `nil` instead of the nearest sample (for example, 100 m from a solution sampled in yards). Solve in the unit you want to query.
- **Default `distanceStep`** is now 1 of `preferredDistanceUnit` (previously always 1 yard, so metric solutions sampled every 0.9144 m).
- **Muzzle corrections.** `dropCorrection` and `windageCorrection` at 0 distance are now 0 instead of a meaningless large angle.
