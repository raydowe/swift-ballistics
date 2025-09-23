//
//  SolutionTests.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 05/12/2024.
//

import Foundation
import Testing
import Ballistics
import Numerics

@Test func simpleG1Solution() async throws {

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragModel: .g1,
        ballisticCoefficient: 0.414,
        initialVelocity: Measurement(value: 1005.84, unit: .metersPerSecond), // 3300 ft/s
        sightHeight: Measurement(value: 0.04572, unit: .meters), // 1.8 in
        shootingAngle: Measurement(value: 0, unit: .degrees),
        zeroRange: Measurement(value: 91.44, unit: .meters), // 100 yd
        windSpeed: Measurement(value: 0, unit: .metersPerSecond),
        windAngle: 0,
        weight: Measurement(value: 0.007776, unit: .kilograms) // 120 gr
    )

    let point0 = try #require(solution.getPoint(at: Measurement(value: 0, unit: .meters)))
    let point1 = try #require(solution.getPoint(at: Measurement(value: 91.44, unit: .meters))) // 100 yd
    let point2 = try #require(solution.getPoint(at: Measurement(value: 182.88, unit: .meters))) // 200 yd
    let point3 = try #require(solution.getPoint(at: Measurement(value: 274.32, unit: .meters))) // 300 yd
    let point4 = try #require(solution.getPoint(at: Measurement(value: 365.76, unit: .meters))) // 400 yd
    let point5 = try #require(solution.getPoint(at: Measurement(value: 457.2, unit: .meters))) // 500 yd

    #expect(point0.range.converted(to: .meters).value.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(point1.range.converted(to: .meters).value.isApproximatelyEqual(to: 91.44, absoluteTolerance: 1))
    #expect(point2.range.converted(to: .meters).value.isApproximatelyEqual(to: 182.88, absoluteTolerance: 1))
    #expect(point3.range.converted(to: .meters).value.isApproximatelyEqual(to: 274.32, absoluteTolerance: 1))
    #expect(point4.range.converted(to: .meters).value.isApproximatelyEqual(to: 365.76, absoluteTolerance: 1))
    #expect(point5.range.converted(to: .meters).value.isApproximatelyEqual(to: 457.2, absoluteTolerance: 1))

    #expect(point0.drop.converted(to: .meters).value.isApproximatelyEqual(to: -0.0457, absoluteTolerance: 0.001)) // -1.80 in
    #expect(point1.drop.converted(to: .meters).value.isApproximatelyEqual(to: 0.0, absoluteTolerance: 0.001)) // -0.00 in
    #expect(point2.drop.converted(to: .meters).value.isApproximatelyEqual(to: -0.0493, absoluteTolerance: 0.001)) // -1.94 in
    #expect(point3.drop.converted(to: .meters).value.isApproximatelyEqual(to: -0.2096, absoluteTolerance: 0.001)) // -8.25 in
    #expect(point4.drop.converted(to: .meters).value.isApproximatelyEqual(to: -0.5004, absoluteTolerance: 0.001)) // -19.70 in
    #expect(point5.drop.converted(to: .meters).value.isApproximatelyEqual(to: -0.9456, absoluteTolerance: 0.001)) // -37.23 in

    #expect(point0.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point1.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point2.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point3.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point4.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point5.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))

    #expect(point0.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 1005.84, absoluteTolerance: 1)) // 3300 ft/s
    #expect(point1.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 931.16, absoluteTolerance: 1)) // 3055 ft/s
    #expect(point2.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 860.75, absoluteTolerance: 1)) // 2824 ft/s
    #expect(point3.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 794.0, absoluteTolerance: 1)) // 2605 ft/s
    #expect(point4.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 729.9, absoluteTolerance: 1)) // 2395 ft/s
    #expect(point5.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 669.3, absoluteTolerance: 1)) // 2196 ft/s
}

@Test func g7SolutionWithAtmosphereAndWind() async throws {
    // Data generated from JBM Ballistics online calculator
    // Bullet: Berger 180gr Hybrid Target
    // G7 BC: 0.316
    // Muzzle Velocity: 2850 ft/s (868.68 m/s)
    // Sight Height: 1.5 in (0.0381 m)
    // Zero Range: 100 yd (91.44 m)
    // Atmosphere: 15°C, 1013.25 hPa, 0% humidity
    // Wind: 10 mph @ 90 deg (4.4704 m/s)

    let solution = Ballistics.solve(
        dragModel: .g7,
        ballisticCoefficient: 0.316,
        initialVelocity: Measurement(value: 868.68, unit: .metersPerSecond),
        sightHeight: Measurement(value: 0.0381, unit: .meters),
        shootingAngle: Measurement(value: 0, unit: .degrees),
        zeroRange: Measurement(value: 91.44, unit: .meters),
        atmosphere: Atmosphere(
            pressure: Measurement(value: 1013.25, unit: .hectopascals),
            temperature: Measurement(value: 15, unit: .celsius),
            relativeHumidity: 0
        ),
        windSpeed: Measurement(value: 4.4704, unit: .metersPerSecond),
        windAngle: 90,
        weight: Measurement(value: 180, unit: .grains)
    )

    let point1 = try #require(solution.getPoint(at: Measurement(value: 91.44, unit: .meters))) // 100 yd
    let point2 = try #require(solution.getPoint(at: Measurement(value: 182.88, unit: .meters))) // 200 yd
    let point3 = try #require(solution.getPoint(at: Measurement(value: 274.32, unit: .meters))) // 300 yd
    let point4 = try #require(solution.getPoint(at: Measurement(value: 365.76, unit: .meters))) // 400 yd
    let point5 = try #require(solution.getPoint(at: Measurement(value: 457.2, unit: .meters))) // 500 yd

    // Drop values (meters) - From JBM: 0.0, -3.2, -12.5, -28.9, -53.4 inches
    #expect(point1.drop.converted(to: .meters).value.isApproximatelyEqual(to: 0.0, absoluteTolerance: 0.01))
    #expect(point2.drop.converted(to: .meters).value.isApproximatelyEqual(to: -0.0813, absoluteTolerance: 0.01))
    #expect(point3.drop.converted(to: .meters).value.isApproximatelyEqual(to: -0.3175, absoluteTolerance: 0.01))
    #expect(point4.drop.converted(to: .meters).value.isApproximatelyEqual(to: -0.7341, absoluteTolerance: 0.01))
    #expect(point5.drop.converted(to: .meters).value.isApproximatelyEqual(to: -1.3564, absoluteTolerance: 0.02)) // Looser tolerance for longer range

    // Windage values (meters) - From JBM: 0.7, 2.8, 6.5, 11.8, 18.9 inches
    #expect(point1.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0.0178, absoluteTolerance: 0.01))
    #expect(point2.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0.0711, absoluteTolerance: 0.01))
    #expect(point3.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0.1651, absoluteTolerance: 0.01))
    #expect(point4.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0.2997, absoluteTolerance: 0.02))
    #expect(point5.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0.4801, absoluteTolerance: 0.03))

    // Velocity values (m/s) - From JBM: 2725.7, 2605.5, 2489.1, 2376.4, 2267.1 ft/s
    #expect(point1.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 830.8, absoluteTolerance: 2))
    #expect(point2.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 794.2, absoluteTolerance: 2))
    #expect(point3.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 758.7, absoluteTolerance: 2))
    #expect(point4.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 724.3, absoluteTolerance: 3))
    #expect(point5.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 691.0, absoluteTolerance: 3))
}
