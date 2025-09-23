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

@Test func simpleSolution() async throws {

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: 0.414,
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

    #expect(point0.energy.converted(to: .joules).value.isApproximatelyEqual(to: 3934.6, absoluteTolerance: 10)) // 2902 ft-lbf
    #expect(point1.energy.converted(to: .joules).value.isApproximatelyEqual(to: 3371.9, absoluteTolerance: 10)) // 2487 ft-lbf
    #expect(point2.energy.converted(to: .joules).value.isApproximatelyEqual(to: 2881.0, absoluteTolerance: 10)) // 2125 ft-lbf
    #expect(point3.energy.converted(to: .joules).value.isApproximatelyEqual(to: 2451.3, absoluteTolerance: 10)) // 1808 ft-lbf
    #expect(point4.energy.converted(to: .joules).value.isApproximatelyEqual(to: 2073.0, absoluteTolerance: 10)) // 1529 ft-lbf
    #expect(point5.energy.converted(to: .joules).value.isApproximatelyEqual(to: 1742.2, absoluteTolerance: 10)) // 1285 ft-lbf

    #expect(point0.seconds.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point1.seconds.isApproximatelyEqual(to: 0.09, absoluteTolerance: 0.01))
    #expect(point2.seconds.isApproximatelyEqual(to: 0.20, absoluteTolerance: 0.01))
    #expect(point3.seconds.isApproximatelyEqual(to: 0.31, absoluteTolerance: 0.01))
    #expect(point4.seconds.isApproximatelyEqual(to: 0.43, absoluteTolerance: 0.01))
    #expect(point5.seconds.isApproximatelyEqual(to: 0.56, absoluteTolerance: 0.01))

    #expect(point1.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point2.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.92, absoluteTolerance: 0.01))
    #expect(point3.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 2.62, absoluteTolerance: 0.01))
    #expect(point4.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 4.70, absoluteTolerance: 0.01))
    #expect(point5.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 7.11, absoluteTolerance: 0.01))

    #expect(point1.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point2.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point3.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point4.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point5.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
}

@Test func solutionWithAtmosphere() async throws {

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: 0.414,
        initialVelocity: Measurement(value: 1005.84, unit: .metersPerSecond), // 3300 ft/s
        sightHeight: Measurement(value: 0.04572, unit: .meters), // 1.8 in
        shootingAngle: Measurement(value: 0, unit: .degrees),
        zeroRange: Measurement(value: 91.44, unit: .meters), // 100 yd
        atmosphere: Atmosphere(
            altitude: Measurement(value: 3048, unit: .meters), // 10,000 ft
            pressure: Measurement(value: 101925, unit: .pascal), // 30.1 inHg
            temperature: Measurement(value: -15, unit: .celsius), // 5 F
            relativeHumidity: 0.9
        ),
        windSpeed: Measurement(value: 8.9408, unit: .metersPerSecond), // 20 mph
        windAngle: 135,
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
    #expect(point2.drop.converted(to: .meters).value.isApproximatelyEqual(to: -0.046, absoluteTolerance: 0.001)) // -1.81 in
    #expect(point3.drop.converted(to: .meters).value.isApproximatelyEqual(to: -0.1953, absoluteTolerance: 0.001)) // -7.69 in
    #expect(point4.drop.converted(to: .meters).value.isApproximatelyEqual(to: -0.4608, absoluteTolerance: 0.001)) // -18.14 in
    #expect(point5.drop.converted(to: .meters).value.isApproximatelyEqual(to: -0.8583, absoluteTolerance: 0.001)) // -33.79 in

    #expect(point0.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0.001, absoluteTolerance: 0.001)) // 0.04 in
    #expect(point1.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0.0183, absoluteTolerance: 0.001)) // 0.72 in
    #expect(point2.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0.0721, absoluteTolerance: 0.001)) // 2.84 in
    #expect(point3.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0.1648, absoluteTolerance: 0.001)) // 6.49 in
    #expect(point4.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0.3002, absoluteTolerance: 0.001)) // 11.82 in
    #expect(point5.windage.converted(to: .meters).value.isApproximatelyEqual(to: 0.4821, absoluteTolerance: 0.001)) // 18.98 in

    #expect(point0.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 1005.84, absoluteTolerance: 1)) // 3300 ft/s
    #expect(point1.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 947.9, absoluteTolerance: 1)) // 3110 ft/s
    #expect(point2.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 893.0, absoluteTolerance: 1)) // 2930 ft/s
    #expect(point3.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 840.0, absoluteTolerance: 1)) // 2756 ft/s
    #expect(point4.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 789.1, absoluteTolerance: 1)) // 2589 ft/s
    #expect(point5.velocity.converted(to: .metersPerSecond).value.isApproximatelyEqual(to: 739.1, absoluteTolerance: 1)) // 2428 ft/s

    #expect(point0.energy.converted(to: .joules).value.isApproximatelyEqual(to: 3934.6, absoluteTolerance: 10)) // 2902 ft-lbf
    #expect(point1.energy.converted(to: .joules).value.isApproximatelyEqual(to: 3495.2, absoluteTolerance: 10)) // 2578 ft-lbf
    #expect(point2.energy.converted(to: .joules).value.isApproximatelyEqual(to: 3100.5, absoluteTolerance: 10)) // 2287 ft-lbf
    #expect(point3.energy.converted(to: .joules).value.isApproximatelyEqual(to: 2744.1, absoluteTolerance: 10)) // 2024 ft-lbf
    #expect(point4.energy.converted(to: .joules).value.isApproximatelyEqual(to: 2422.8, absoluteTolerance: 10)) // 1787 ft-lbf
    #expect(point5.energy.converted(to: .joules).value.isApproximatelyEqual(to: 2132.8, absoluteTolerance: 10)) // 1571 ft-lbf

    #expect(point0.seconds.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point1.seconds.isApproximatelyEqual(to: 0.09, absoluteTolerance: 0.01))
    #expect(point2.seconds.isApproximatelyEqual(to: 0.20, absoluteTolerance: 0.01))
    #expect(point3.seconds.isApproximatelyEqual(to: 0.30, absoluteTolerance: 0.01))
    #expect(point4.seconds.isApproximatelyEqual(to: 0.41, absoluteTolerance: 0.01))
    #expect(point5.seconds.isApproximatelyEqual(to: 0.53, absoluteTolerance: 0.01))

    #expect(point1.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point2.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.87, absoluteTolerance: 0.01))
    #expect(point3.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 2.45, absoluteTolerance: 0.01))
    #expect(point4.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 4.33, absoluteTolerance: 0.01))
    #expect(point5.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 6.45, absoluteTolerance: 0.01))

    #expect(point1.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.68, absoluteTolerance: 0.01))
    #expect(point2.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 1.35, absoluteTolerance: 0.01))
    #expect(point3.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 2.07, absoluteTolerance: 0.01))
    #expect(point4.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 2.82, absoluteTolerance: 0.01))
    #expect(point5.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 3.62, absoluteTolerance: 0.01))
}
