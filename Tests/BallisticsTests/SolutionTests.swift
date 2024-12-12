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

@Test func testSolutionSimple() async throws {

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: 0.414,
        initialVelocity: Measurement<UnitSpeed>(value: 3300, unit: .feetPerSecond),
        sightHeight: Measurement<UnitLength>(value: 1.8, unit: .inches),
        shootingAngle: 0,
        zeroRange: Measurement<UnitLength>(value: 100, unit: .yards),
        windSpeed: Measurement<UnitSpeed>(value: 0, unit: .milesPerHour),
        windAngle: 0,
        weight: Measurement<UnitMass>(value: 120, unit: .grains)
    )

    guard let point0 = solution.getPoint(at: Measurement<UnitLength>(value: 0, unit: .yards)),
            let point1 = solution.getPoint(at: Measurement<UnitLength>(value: 100, unit: .yards)),
            let point2 = solution.getPoint(at: Measurement<UnitLength>(value: 200, unit: .yards)),
            let point3 = solution.getPoint(at: Measurement<UnitLength>(value: 300, unit: .yards)),
            let point4 = solution.getPoint(at: Measurement<UnitLength>(value: 400, unit: .yards)),
            let point5 = solution.getPoint(at: Measurement<UnitLength>(value: 500, unit: .yards)) else {
        Issue.record("Not all points were found")
        return
    }

    #expect(point0.range.converted(to: .yards).value.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(point1.range.converted(to: .yards).value.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(point2.range.converted(to: .yards).value.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(point3.range.converted(to: .yards).value.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(point4.range.converted(to: .yards).value.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(point5.range.converted(to: .yards).value.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(point0.drop.converted(to: .inches).value.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(point1.drop.converted(to: .inches).value.isApproximatelyEqual(to: -0.00, absoluteTolerance: 0.01))
    #expect(point2.drop.converted(to: .inches).value.isApproximatelyEqual(to: -1.94, absoluteTolerance: 0.01))
    #expect(point3.drop.converted(to: .inches).value.isApproximatelyEqual(to: -8.25, absoluteTolerance: 0.01))
    #expect(point4.drop.converted(to: .inches).value.isApproximatelyEqual(to: -19.70, absoluteTolerance: 0.01))
    #expect(point5.drop.converted(to: .inches).value.isApproximatelyEqual(to: -37.23, absoluteTolerance: 0.01))

    #expect(point0.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point1.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point2.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point3.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point4.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point5.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))

    #expect(point0.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(point1.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 3055, absoluteTolerance: 1))
    #expect(point2.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2824, absoluteTolerance: 1))
    #expect(point3.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2605, absoluteTolerance: 1))
    #expect(point4.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2395, absoluteTolerance: 1))
    #expect(point5.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2196, absoluteTolerance: 1))

    #expect(point0.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2902, absoluteTolerance: 1))
    #expect(point1.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2487, absoluteTolerance: 1))
    #expect(point2.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2125, absoluteTolerance: 1))
    #expect(point3.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 1808, absoluteTolerance: 1))
    #expect(point4.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 1529, absoluteTolerance: 1))
    #expect(point5.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 1285, absoluteTolerance: 1))

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

@Test func testSolutionWithAtmosphere() async throws {

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: 0.414,
        initialVelocity: Measurement<UnitSpeed>(value: 3300, unit: .feetPerSecond),
        sightHeight: Measurement<UnitLength>(value: 1.8, unit: .inches),
        shootingAngle: 0,
        zeroRange: Measurement<UnitLength>(value: 100, unit: .yards),
        atmosphere: Atmosphere(
            altitude: Measurement<UnitLength>(value: 10_000, unit: .feet),
            pressure: Measurement<UnitPressure>(value: 30.1, unit: .inchesOfMercury),
            temperature: Measurement<UnitTemperature>(value: 5, unit: .fahrenheit),
            relativeHumidity: 0.9
        ),
        windSpeed: Measurement<UnitSpeed>(value: 20, unit: .milesPerHour),
        windAngle: 135,
        weight: Measurement<UnitMass>(value: 120, unit: .grains)
    )

    guard let point0 = solution.getPoint(at: Measurement<UnitLength>(value: 0, unit: .yards)),
            let point1 = solution.getPoint(at: Measurement<UnitLength>(value: 100, unit: .yards)),
            let point2 = solution.getPoint(at: Measurement<UnitLength>(value: 200, unit: .yards)),
            let point3 = solution.getPoint(at: Measurement<UnitLength>(value: 300, unit: .yards)),
            let point4 = solution.getPoint(at: Measurement<UnitLength>(value: 400, unit: .yards)),
          let point5 = solution.getPoint(at: Measurement<UnitLength>(value: 500, unit: .yards)) else {
        Issue.record("Not all points were found")
        return
    }

    #expect(point0.range.converted(to: .yards).value.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(point1.range.converted(to: .yards).value.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(point2.range.converted(to: .yards).value.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(point3.range.converted(to: .yards).value.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(point4.range.converted(to: .yards).value.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(point5.range.converted(to: .yards).value.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(point0.drop.converted(to: .inches).value.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(point1.drop.converted(to: .inches).value.isApproximatelyEqual(to: -0.00, absoluteTolerance: 0.01))
    #expect(point2.drop.converted(to: .inches).value.isApproximatelyEqual(to: -1.81, absoluteTolerance: 0.01))
    #expect(point3.drop.converted(to: .inches).value.isApproximatelyEqual(to: -7.69, absoluteTolerance: 0.01))
    #expect(point4.drop.converted(to: .inches).value.isApproximatelyEqual(to: -18.14, absoluteTolerance: 0.01))
    #expect(point5.drop.converted(to: .inches).value.isApproximatelyEqual(to: -33.79, absoluteTolerance: 0.01))

    #expect(point0.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0.04, absoluteTolerance: 0.01))
    #expect(point1.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0.72, absoluteTolerance: 0.01))
    #expect(point2.windage.converted(to: .inches).value.isApproximatelyEqual(to: 2.84, absoluteTolerance: 0.01))
    #expect(point3.windage.converted(to: .inches).value.isApproximatelyEqual(to: 6.49, absoluteTolerance: 0.01))
    #expect(point4.windage.converted(to: .inches).value.isApproximatelyEqual(to: 11.82, absoluteTolerance: 0.01))
    #expect(point5.windage.converted(to: .inches).value.isApproximatelyEqual(to: 18.98, absoluteTolerance: 0.01))

    #expect(point0.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(point1.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 3110, absoluteTolerance: 1))
    #expect(point2.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2930, absoluteTolerance: 1))
    #expect(point3.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2756, absoluteTolerance: 1))
    #expect(point4.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2589, absoluteTolerance: 1))
    #expect(point5.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2428, absoluteTolerance: 1))

    #expect(point0.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2902, absoluteTolerance: 1))
    #expect(point1.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2578, absoluteTolerance: 1))
    #expect(point2.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2287, absoluteTolerance: 1))
    #expect(point3.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2024, absoluteTolerance: 1))
    #expect(point4.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 1787, absoluteTolerance: 1))
    #expect(point5.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 1571, absoluteTolerance: 1))

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
