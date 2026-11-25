//
//  DragModelSolutionTests.swift
//  swift-ballistics
//

import Foundation
import Testing
import Ballistics
import Numerics

// MARK: - G7 regression solutions

private struct Expected {
    let yards: Double
    let drop: Double            // inches
    let windage: Double         // inches
    let velocity: Double        // ft/s
    let energy: Double          // ft·lbf
    let dropCorrection: Double  // MOA
    let windageCorrection: Double // MOA
    let travelTime: Double      // ms
}

private func check(_ solution: Ballistics, _ rows: [Expected]) throws {
    for e in rows {
        let p = try #require(solution.getPoint(at: Measurement(value: e.yards, unit: .yards)))
        #expect(p.range.converted(to: .yards).value.isApproximatelyEqual(to: e.yards, absoluteTolerance: 1))
        #expect(p.drop.converted(to: .inches).value.isApproximatelyEqual(to: e.drop, absoluteTolerance: 0.01), "drop @ \(e.yards) yd")
        #expect(p.windage.converted(to: .inches).value.isApproximatelyEqual(to: e.windage, absoluteTolerance: 0.01), "windage @ \(e.yards) yd")
        #expect(p.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: e.velocity, absoluteTolerance: 1), "velocity @ \(e.yards) yd")
        #expect(p.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: e.energy, absoluteTolerance: 1), "energy @ \(e.yards) yd")
        if e.yards > 0 {
            #expect(p.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: e.dropCorrection, absoluteTolerance: 0.01), "drop MOA @ \(e.yards) yd")
            #expect(p.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: e.windageCorrection, absoluteTolerance: 0.01), "windage MOA @ \(e.yards) yd")
        }
        #expect(p.travelTime.converted(to: .milliseconds).value.isApproximatelyEqual(to: e.travelTime, absoluteTolerance: 0.1), "time @ \(e.yards) yd")
    }
}

@Test func g7SimpleSolution() throws {
    let solution = Ballistics.solve(
        dragCoefficient: 0.210,
        dragModel: .g7,
        initialVelocity: Measurement(value: 3300, unit: .feetPerSecond),
        sightHeight: Measurement(value: 1.8, unit: .inches),
        shootingAngle: Measurement(value: 0, unit: .degrees),
        zeroRange: Measurement(value: 100, unit: .yards),
        windSpeed: Measurement(value: 0, unit: .milesPerHour),
        windAngle: 0,
        weight: Measurement(value: 120, unit: .grains)
    )

    // Runs to 1000 yd, by which point the bullet has slowed to about Mach 1.2.
    try check(solution, [
        Expected(yards: 0   , drop: -1.80  , windage: 0.00 , velocity: 3300, energy: 2901, dropCorrection: 0    , windageCorrection: 0   , travelTime: 0.0),
        Expected(yards: 100 , drop: 0.00   , windage: 0.00 , velocity: 3067, energy: 2506, dropCorrection: 0.00 , windageCorrection: 0.00, travelTime: 94.3),
        Expected(yards: 200 , drop: -1.90  , windage: 0.00 , velocity: 2841, energy: 2150, dropCorrection: 0.91 , windageCorrection: 0.00, travelTime: 195.9),
        Expected(yards: 300 , drop: -8.12  , windage: 0.00 , velocity: 2623, energy: 1833, dropCorrection: 2.59 , windageCorrection: 0.00, travelTime: 305.8),
        Expected(yards: 400 , drop: -19.41 , windage: 0.00 , velocity: 2414, energy: 1553, dropCorrection: 4.63 , windageCorrection: 0.00, travelTime: 425.1),
        Expected(yards: 500 , drop: -36.67 , windage: 0.00 , velocity: 2215, energy: 1308, dropCorrection: 7.00 , windageCorrection: 0.00, travelTime: 554.8),
        Expected(yards: 600 , drop: -61.04 , windage: 0.00 , velocity: 2027, energy: 1094, dropCorrection: 9.71 , windageCorrection: 0.00, travelTime: 696.4),
        Expected(yards: 700 , drop: -93.89 , windage: 0.00 , velocity: 1847, energy: 909 , dropCorrection: 12.81, windageCorrection: 0.00, travelTime: 851.4),
        Expected(yards: 800 , drop: -136.98, windage: 0.00 , velocity: 1675, energy: 747 , dropCorrection: 16.35, windageCorrection: 0.00, travelTime: 1022.0),
        Expected(yards: 900 , drop: -192.50, windage: 0.00 , velocity: 1510, energy: 607 , dropCorrection: 20.43, windageCorrection: 0.00, travelTime: 1210.7),
        Expected(yards: 1000, drop: -263.35, windage: 0.00 , velocity: 1353, energy: 487 , dropCorrection: 25.15, windageCorrection: 0.00, travelTime: 1420.6),
    ])
}

@Test func g7SolutionWithAtmosphere() throws {
    let solution = Ballistics.solve(
        dragCoefficient: 0.210,
        dragModel: .g7,
        initialVelocity: Measurement(value: 3300, unit: .feetPerSecond),
        sightHeight: Measurement(value: 1.8, unit: .inches),
        shootingAngle: Measurement(value: 0, unit: .degrees),
        zeroRange: Measurement(value: 100, unit: .yards),
        atmosphere: Atmosphere(
            altitude: Measurement(value: 10_000, unit: .feet),
            pressure: Measurement(value: 30.1, unit: .inchesOfMercury),
            temperature: Measurement(value: 5, unit: .fahrenheit),
            relativeHumidity: 0.9
        ),
        windSpeed: Measurement(value: 20, unit: .milesPerHour),
        windAngle: 135,
        weight: Measurement(value: 120, unit: .grains)
    )

    try check(solution, [
        Expected(yards: 0   , drop: -1.80  , windage: 0.00 , velocity: 3300, energy: 2901, dropCorrection: 0    , windageCorrection: 0   , travelTime: 0.0),
        Expected(yards: 100 , drop: 0.00   , windage: 0.63 , velocity: 3124, energy: 2600, dropCorrection: 0.00 , windageCorrection: 0.60, travelTime: 93.4),
        Expected(yards: 200 , drop: -1.76  , windage: 2.60 , velocity: 2952, energy: 2321, dropCorrection: 0.84 , windageCorrection: 1.24, travelTime: 192.2),
        Expected(yards: 300 , drop: -7.52  , windage: 6.05 , velocity: 2784, energy: 2064, dropCorrection: 2.39 , windageCorrection: 1.92, travelTime: 296.9),
        Expected(yards: 400 , drop: -17.77 , windage: 11.10, velocity: 2620, energy: 1829, dropCorrection: 4.24 , windageCorrection: 2.65, travelTime: 408.0),
        Expected(yards: 500 , drop: -33.08 , windage: 17.92, velocity: 2461, energy: 1614, dropCorrection: 6.32 , windageCorrection: 3.42, travelTime: 526.1),
        Expected(yards: 600 , drop: -54.12 , windage: 26.68, velocity: 2308, energy: 1419, dropCorrection: 8.61 , windageCorrection: 4.25, travelTime: 652.0),
        Expected(yards: 700 , drop: -81.68 , windage: 37.56, velocity: 2161, energy: 1244, dropCorrection: 11.14, windageCorrection: 5.12, travelTime: 786.3),
        Expected(yards: 800 , drop: -116.68, windage: 50.76, velocity: 2019, energy: 1086, dropCorrection: 13.93, windageCorrection: 6.06, travelTime: 929.9),
        Expected(yards: 900 , drop: -160.19, windage: 66.52, velocity: 1884, energy: 945 , dropCorrection: 17.00, windageCorrection: 7.06, travelTime: 1083.8),
        Expected(yards: 1000, drop: -213.47, windage: 85.11, velocity: 1753, energy: 818 , dropCorrection: 20.38, windageCorrection: 8.13, travelTime: 1248.9),
    ])
}

// MARK: - Behaviour that must hold under both drag models

/// Roughly equivalent coefficients for the same projectile under each model.
private func coefficient(for model: DragModel) -> Double {
    switch model {
    case .g1: 0.414
    case .g7: 0.210
    }
}

private func solve(
    _ model: DragModel,
    coefficient bc: Double? = nil,
    velocity: Double = 3000,
    zeroYards: Double = 100,
    angle: Double = 0,
    atmosphere: Atmosphere? = nil,
    windSpeed: Double = 0,
    windAngle: Double = 0,
    unit: UnitLength = .yards,
    step: Measurement<UnitLength> = Measurement(value: 1, unit: .yards)
) -> Ballistics {
    Ballistics.solve(
        preferredDistanceUnit: unit,
        dragCoefficient: bc ?? coefficient(for: model),
        dragModel: model,
        initialVelocity: Measurement(value: velocity, unit: .feetPerSecond),
        sightHeight: Measurement(value: 1.8, unit: .inches),
        shootingAngle: Measurement(value: angle, unit: .degrees),
        zeroRange: Measurement(value: zeroYards, unit: .yards),
        atmosphere: atmosphere,
        windSpeed: Measurement(value: windSpeed, unit: .milesPerHour),
        windAngle: windAngle,
        weight: Measurement(value: 120, unit: .grains),
        distanceStep: step
    )
}

private func point(_ s: Ballistics, _ yards: Double) throws -> Point {
    try #require(s.getPoint(at: Measurement(value: yards, unit: .yards)))
}

@Test(arguments: DragModel.allCases, [50.0, 100, 200, 300, 500])
func bulletCrossesLineOfSightAtZeroRange(model: DragModel, zeroYards: Double) throws {
    let s = solve(model, zeroYards: zeroYards)
    let drop = try point(s, zeroYards).drop.converted(to: .inches).value
    // Zeroing iterates to 0.01 MOA; allow 0.02 MOA of error at the zero range.
    let tolerance = max(0.05, 0.02 * 1.047 * zeroYards / 100)
    #expect(abs(drop) < tolerance, "\(model) zeroed at \(zeroYards) yd has drop \(drop) in")
}

@Test(arguments: DragModel.allCases)
func higherCoefficientFlattensTrajectory(model: DragModel) throws {
    let bc = coefficient(for: model)
    let low = try point(solve(model, coefficient: bc * 0.8), 600)
    let high = try point(solve(model, coefficient: bc * 1.2), 600)
    #expect(high.drop.value > low.drop.value)
    #expect(high.velocity.value > low.velocity.value)
    #expect(high.travelTime.value < low.travelTime.value)
}

@Test(arguments: DragModel.allCases)
func crosswindIsSymmetric(model: DragModel) throws {
    let right = try point(solve(model, windSpeed: 10, windAngle: 90), 500)
    let left = try point(solve(model, windSpeed: 10, windAngle: -90), 500)
    #expect(right.windage.value > 1)
    #expect(right.windage.value.isApproximatelyEqual(to: -left.windage.value, absoluteTolerance: 1e-9))
    #expect(right.drop.value.isApproximatelyEqual(to: left.drop.value, absoluteTolerance: 1e-9))
}

@Test(arguments: DragModel.allCases)
func headwindSlowsBulletMoreThanTailwind(model: DragModel) throws {
    let head = try point(solve(model, windSpeed: 20, windAngle: 0), 800)
    let tail = try point(solve(model, windSpeed: 20, windAngle: 180), 800)
    #expect(head.velocity.value < tail.velocity.value)
    #expect(head.drop.value < tail.drop.value)
}

@Test(arguments: DragModel.allCases)
func thinAirReducesDrop(model: DragModel) throws {
    let thin = Atmosphere(
        altitude: Measurement(value: 8_000, unit: .feet),
        pressure: Measurement(value: 29.92, unit: .inchesOfMercury),
        temperature: Measurement(value: 59, unit: .fahrenheit),
        relativeHumidity: 0
    )
    let sea = try point(solve(model), 700)
    let high = try point(solve(model, atmosphere: thin), 700)
    #expect(high.drop.value > sea.drop.value)
    #expect(high.velocity.value > sea.velocity.value)
}

@Test(arguments: DragModel.allCases)
func inclinedShotDropsLessThanLevel(model: DragModel) throws {
    let level = try point(solve(model), 500)
    let uphill = try point(solve(model, angle: 30), 500)
    let downhill = try point(solve(model, angle: -30), 500)
    #expect(uphill.drop.value > level.drop.value)
    #expect(downhill.drop.value > level.drop.value)
}

@Test(arguments: DragModel.allCases)
func trajectoryStaysWellBehavedThroughTransonic(model: DragModel) throws {
    // 2000 yd from 2600 ft/s takes both models through supersonic, transonic and subsonic flight,
    // including the steep drag rise around Mach 1.
    let s = solve(model, velocity: 2600)
    var previous = try point(s, 200)
    for yards in stride(from: 250.0, through: 2000, by: 50) {
        let p = try point(s, yards)
        #expect(p.velocity.value < previous.velocity.value, "\(model) velocity rose at \(yards) yd")
        #expect(p.drop.value < previous.drop.value, "\(model) drop not increasing at \(yards) yd")
        #expect(p.travelTime.value > previous.travelTime.value)
        previous = p
    }
    #expect(previous.velocity.converted(to: .feetPerSecond).value < 1000, "\(model) should be subsonic by 2000 yd")
}
