//
//  ReferenceTests.swift
//  swift-ballistics
//
//  Cross-checks trajectories against an independent solver: py-ballisticcalc 2.2.2
//  (RK4 integration over the standard G1/G7 drag tables, ideal-gas atmosphere).
//
//  Reference setup: 120 gr, 3300 ft/s, 1.8 in sight height, zeroed at 100 yd in still air.
//  - "Standard" runs use Army Standard Metro air (59 °F, 29.53 inHg, 78% RH), which is what
//    this library assumes when no atmosphere is given.
//  - "Atmosphere" runs use 10,000 ft, 30.1 inHg (sea-level corrected → station pressure),
//    5 °F, 90% RH, with a 20 mph wind at 135° (py-ballisticcalc direction 45°).
//
//  Both solvers use the same standard drag tables, interpolation and wind model, so they
//  should agree closely. The small residual (≈ 0.05 in at 1000 yd) comes from py-ballisticcalc
//  varying air density with the bullet's height and a 0.05% difference in humidity modelling.
//

import Foundation
import Testing
import Ballistics

private struct Reference {
    let yards: Double
    let drop: Double        // inches
    let windage: Double     // inches
    let velocity: Double    // ft/s
    let travelTime: Double  // ms
}

private struct Tolerance {
    let moa: Double         // drop and windage, as an angle
    let percent: Double     // velocity and time of flight
}

private let g1Standard: [Reference] = [
    Reference(yards: 100, drop: -0.00, windage: 0.00, velocity: 3055, travelTime: 94.5),
    Reference(yards: 200, drop: -1.93, windage: 0.00, velocity: 2824, travelTime: 196.6),
    Reference(yards: 300, drop: -8.23, windage: 0.00, velocity: 2604, travelTime: 307.3),
    Reference(yards: 400, drop: -19.67, windage: 0.00, velocity: 2395, travelTime: 427.4),
    Reference(yards: 500, drop: -37.18, windage: 0.00, velocity: 2195, travelTime: 558.2),
    Reference(yards: 600, drop: -61.93, windage: 0.00, velocity: 2005, travelTime: 701.2),
    Reference(yards: 700, drop: -95.34, windage: 0.00, velocity: 1826, travelTime: 858.0),
    Reference(yards: 800, drop: -139.22, windage: 0.00, velocity: 1658, travelTime: 1030.5),
    Reference(yards: 900, drop: -195.79, windage: 0.00, velocity: 1503, travelTime: 1220.7),
    Reference(yards: 1000, drop: -267.81, windage: 0.00, velocity: 1363, travelTime: 1430.5),
]

private let g1Atmosphere: [Reference] = [
    Reference(yards: 100, drop: 0.00, windage: 0.68, velocity: 3111, travelTime: 93.6),
    Reference(yards: 200, drop: -1.79, windage: 2.80, velocity: 2930, travelTime: 193.0),
    Reference(yards: 300, drop: -7.64, windage: 6.47, velocity: 2758, travelTime: 298.6),
    Reference(yards: 400, drop: -18.06, windage: 11.81, velocity: 2592, travelTime: 410.8),
    Reference(yards: 500, drop: -33.65, windage: 18.96, velocity: 2433, travelTime: 530.2),
    Reference(yards: 600, drop: -55.11, windage: 28.09, velocity: 2280, travelTime: 657.6),
    Reference(yards: 700, drop: -83.25, windage: 39.40, velocity: 2132, travelTime: 793.7),
    Reference(yards: 800, drop: -119.03, windage: 53.11, velocity: 1991, travelTime: 939.3),
    Reference(yards: 900, drop: -163.56, windage: 69.45, velocity: 1854, travelTime: 1095.5),
    Reference(yards: 1000, drop: -218.18, windage: 88.71, velocity: 1724, travelTime: 1263.3),
]

private let g7Standard: [Reference] = [
    Reference(yards: 100, drop: -0.00, windage: 0.00, velocity: 3067, travelTime: 94.3),
    Reference(yards: 200, drop: -1.90, windage: 0.00, velocity: 2841, travelTime: 195.9),
    Reference(yards: 300, drop: -8.12, windage: 0.00, velocity: 2623, travelTime: 305.8),
    Reference(yards: 400, drop: -19.41, windage: 0.00, velocity: 2414, travelTime: 425.1),
    Reference(yards: 500, drop: -36.67, windage: 0.00, velocity: 2215, travelTime: 554.8),
    Reference(yards: 600, drop: -61.04, windage: 0.00, velocity: 2027, travelTime: 696.4),
    Reference(yards: 700, drop: -93.89, windage: 0.00, velocity: 1847, travelTime: 851.4),
    Reference(yards: 800, drop: -136.97, windage: 0.00, velocity: 1675, travelTime: 1022.0),
    Reference(yards: 900, drop: -192.50, windage: 0.00, velocity: 1510, travelTime: 1210.7),
    Reference(yards: 1000, drop: -263.35, windage: 0.00, velocity: 1353, travelTime: 1420.7),
]

private let g7Atmosphere: [Reference] = [
    Reference(yards: 100, drop: 0.00, windage: 0.63, velocity: 3124, travelTime: 93.4),
    Reference(yards: 200, drop: -1.76, windage: 2.60, velocity: 2952, travelTime: 192.2),
    Reference(yards: 300, drop: -7.52, windage: 6.05, velocity: 2783, travelTime: 296.9),
    Reference(yards: 400, drop: -17.77, windage: 11.10, velocity: 2620, travelTime: 408.0),
    Reference(yards: 500, drop: -33.08, windage: 17.93, velocity: 2461, travelTime: 526.1),
    Reference(yards: 600, drop: -54.12, windage: 26.68, velocity: 2308, travelTime: 652.0),
    Reference(yards: 700, drop: -81.69, windage: 37.56, velocity: 2161, travelTime: 786.3),
    Reference(yards: 800, drop: -116.69, windage: 50.77, velocity: 2019, travelTime: 930.0),
    Reference(yards: 900, drop: -160.20, windage: 66.54, velocity: 1883, travelTime: 1083.8),
    Reference(yards: 1000, drop: -213.50, windage: 85.14, velocity: 1752, travelTime: 1249.0),
]

private func solve(_ model: DragModel, atmosphere: Bool) -> Ballistics {
    Ballistics.solve(
        dragCoefficient: model == .g1 ? 0.414 : 0.210,
        dragModel: model,
        initialVelocity: Measurement(value: 3300, unit: .feetPerSecond),
        sightHeight: Measurement(value: 1.8, unit: .inches),
        shootingAngle: Measurement(value: 0, unit: .degrees),
        zeroRange: Measurement(value: 100, unit: .yards),
        atmosphere: atmosphere ? Atmosphere(
            altitude: Measurement(value: 10_000, unit: .feet),
            pressure: Measurement(value: 30.1, unit: .inchesOfMercury),
            temperature: Measurement(value: 5, unit: .fahrenheit),
            relativeHumidity: 0.9
        ) : nil,
        windSpeed: Measurement(value: atmosphere ? 20 : 0, unit: .milesPerHour),
        windAngle: atmosphere ? 135 : 0,
        weight: Measurement(value: 120, unit: .grains)
    )
}

private func compare(_ solution: Ballistics, _ references: [Reference], _ tolerance: Tolerance) throws {
    for r in references {
        let p = try #require(solution.getPoint(at: Measurement(value: r.yards, unit: .yards)))
        let inchesPerMOA = r.yards / 100 * 1.04720
        let dropError = (p.drop.converted(to: .inches).value - r.drop) / inchesPerMOA
        let windageError = (p.windage.converted(to: .inches).value - r.windage) / inchesPerMOA
        let velocityError = 100 * (p.velocity.converted(to: .feetPerSecond).value - r.velocity) / r.velocity
        let timeError = 100 * (p.travelTime.converted(to: .milliseconds).value - r.travelTime) / r.travelTime
        #expect(abs(dropError) <= tolerance.moa, "drop off by \(dropError) MOA at \(r.yards) yd")
        #expect(abs(windageError) <= tolerance.moa, "windage off by \(windageError) MOA at \(r.yards) yd")
        #expect(abs(velocityError) <= tolerance.percent, "velocity off by \(velocityError)% at \(r.yards) yd")
        #expect(abs(timeError) <= tolerance.percent, "time off by \(timeError)% at \(r.yards) yd")
    }
}

@Test func g1MatchesReferenceInStandardAir() throws {
    try compare(solve(.g1, atmosphere: false), g1Standard, Tolerance(moa: 0.01, percent: 0.15))
}

@Test func g1MatchesReferenceWithAtmosphereAndWind() throws {
    try compare(solve(.g1, atmosphere: true), g1Atmosphere, Tolerance(moa: 0.01, percent: 0.15))
}

@Test func g7MatchesReferenceInStandardAir() throws {
    try compare(solve(.g7, atmosphere: false), g7Standard, Tolerance(moa: 0.01, percent: 0.15))
}

@Test func g7MatchesReferenceWithAtmosphereAndWind() throws {
    try compare(solve(.g7, atmosphere: true), g7Atmosphere, Tolerance(moa: 0.01, percent: 0.15))
}
