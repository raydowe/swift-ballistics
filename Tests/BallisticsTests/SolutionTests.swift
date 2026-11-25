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
        initialVelocity: Measurement(value: 3300, unit: .feetPerSecond),
        sightHeight: Measurement(value: 1.8, unit: .inches),
        shootingAngle: Measurement(value: 0, unit: .degrees),
        zeroRange: Measurement(value: 100, unit: .yards),
        windSpeed: Measurement(value: 0, unit: .milesPerHour),
        windAngle: 0,
        weight: Measurement(value: 120, unit: .grains)
    )

    let point0 = try #require(solution.getPoint(at: Measurement(value: 0, unit: .yards)))
    let point1 = try #require(solution.getPoint(at: Measurement(value: 100, unit: .yards)))
    let point2 = try #require(solution.getPoint(at: Measurement(value: 200, unit: .yards)))
    let point3 = try #require(solution.getPoint(at: Measurement(value: 300, unit: .yards)))
    let point4 = try #require(solution.getPoint(at: Measurement(value: 400, unit: .yards)))
    let point5 = try #require(solution.getPoint(at: Measurement(value: 500, unit: .yards)))

    #expect(point0.range.converted(to: .yards).value.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(point1.range.converted(to: .yards).value.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(point2.range.converted(to: .yards).value.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(point3.range.converted(to: .yards).value.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(point4.range.converted(to: .yards).value.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(point5.range.converted(to: .yards).value.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(point0.drop.converted(to: .inches).value.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(point1.drop.converted(to: .inches).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point2.drop.converted(to: .inches).value.isApproximatelyEqual(to: -1.93, absoluteTolerance: 0.01))
    #expect(point3.drop.converted(to: .inches).value.isApproximatelyEqual(to: -8.23, absoluteTolerance: 0.01))
    #expect(point4.drop.converted(to: .inches).value.isApproximatelyEqual(to: -19.67, absoluteTolerance: 0.01))
    #expect(point5.drop.converted(to: .inches).value.isApproximatelyEqual(to: -37.18, absoluteTolerance: 0.01))

    #expect(point0.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point1.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point2.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point3.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point4.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point5.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))

    #expect(point0.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(point1.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 3055, absoluteTolerance: 1))
    #expect(point2.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2824, absoluteTolerance: 1))
    #expect(point3.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2604, absoluteTolerance: 1))
    #expect(point4.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2395, absoluteTolerance: 1))
    #expect(point5.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2196, absoluteTolerance: 1))

    #expect(point0.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2901, absoluteTolerance: 1))
    #expect(point1.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2487, absoluteTolerance: 1))
    #expect(point2.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2124, absoluteTolerance: 1))
    #expect(point3.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 1807, absoluteTolerance: 1))
    #expect(point4.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 1528, absoluteTolerance: 1))
    #expect(point5.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 1284, absoluteTolerance: 1))

    #expect(point1.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point2.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.92, absoluteTolerance: 0.01))
    #expect(point3.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 2.62, absoluteTolerance: 0.01))
    #expect(point4.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 4.70, absoluteTolerance: 0.01))
    #expect(point5.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 7.10, absoluteTolerance: 0.01))

    #expect(point1.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point2.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point3.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point4.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point5.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    
    #expect(point0.travelTime.converted(to: .milliseconds).value.isApproximatelyEqual(to: 0.0, absoluteTolerance: 0.1))
    #expect(point1.travelTime.converted(to: .milliseconds).value.isApproximatelyEqual(to: 94.5, absoluteTolerance: 0.1))
    #expect(point2.travelTime.converted(to: .milliseconds).value.isApproximatelyEqual(to: 196.6, absoluteTolerance: 0.1))
    #expect(point3.travelTime.converted(to: .milliseconds).value.isApproximatelyEqual(to: 307.3, absoluteTolerance: 0.1))
    #expect(point4.travelTime.converted(to: .milliseconds).value.isApproximatelyEqual(to: 427.4, absoluteTolerance: 0.1))
    #expect(point5.travelTime.converted(to: .milliseconds).value.isApproximatelyEqual(to: 558.2, absoluteTolerance: 0.1))
}

@Test func solutionWithAtmosphere() async throws {

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: 0.414,
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

    let point0 = try #require(solution.getPoint(at: Measurement(value: 0, unit: .yards)))
    let point1 = try #require(solution.getPoint(at: Measurement(value: 100, unit: .yards)))
    let point2 = try #require(solution.getPoint(at: Measurement(value: 200, unit: .yards)))
    let point3 = try #require(solution.getPoint(at: Measurement(value: 300, unit: .yards)))
    let point4 = try #require(solution.getPoint(at: Measurement(value: 400, unit: .yards)))
    let point5 = try #require(solution.getPoint(at: Measurement(value: 500, unit: .yards)))

    #expect(point0.range.converted(to: .yards).value.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(point1.range.converted(to: .yards).value.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(point2.range.converted(to: .yards).value.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(point3.range.converted(to: .yards).value.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(point4.range.converted(to: .yards).value.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(point5.range.converted(to: .yards).value.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(point0.drop.converted(to: .inches).value.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(point1.drop.converted(to: .inches).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point2.drop.converted(to: .inches).value.isApproximatelyEqual(to: -1.79, absoluteTolerance: 0.01))
    #expect(point3.drop.converted(to: .inches).value.isApproximatelyEqual(to: -7.64, absoluteTolerance: 0.01))
    #expect(point4.drop.converted(to: .inches).value.isApproximatelyEqual(to: -18.06, absoluteTolerance: 0.01))
    #expect(point5.drop.converted(to: .inches).value.isApproximatelyEqual(to: -33.65, absoluteTolerance: 0.01))

    #expect(point0.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point1.windage.converted(to: .inches).value.isApproximatelyEqual(to: 0.68, absoluteTolerance: 0.01))
    #expect(point2.windage.converted(to: .inches).value.isApproximatelyEqual(to: 2.80, absoluteTolerance: 0.01))
    #expect(point3.windage.converted(to: .inches).value.isApproximatelyEqual(to: 6.47, absoluteTolerance: 0.01))
    #expect(point4.windage.converted(to: .inches).value.isApproximatelyEqual(to: 11.80, absoluteTolerance: 0.01))
    #expect(point5.windage.converted(to: .inches).value.isApproximatelyEqual(to: 18.95, absoluteTolerance: 0.01))

    #expect(point0.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(point1.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 3111, absoluteTolerance: 1))
    #expect(point2.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2930, absoluteTolerance: 1))
    #expect(point3.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2758, absoluteTolerance: 1))
    #expect(point4.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2592, absoluteTolerance: 1))
    #expect(point5.velocity.converted(to: .feetPerSecond).value.isApproximatelyEqual(to: 2433, absoluteTolerance: 1))

    #expect(point0.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2901, absoluteTolerance: 1))
    #expect(point1.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2578, absoluteTolerance: 1))
    #expect(point2.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2288, absoluteTolerance: 1))
    #expect(point3.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 2026, absoluteTolerance: 1))
    #expect(point4.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 1790, absoluteTolerance: 1))
    #expect(point5.energy.converted(to: .footPounds).value.isApproximatelyEqual(to: 1578, absoluteTolerance: 1))

    #expect(point1.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point2.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.86, absoluteTolerance: 0.01))
    #expect(point3.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 2.43, absoluteTolerance: 0.01))
    #expect(point4.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 4.31, absoluteTolerance: 0.01))
    #expect(point5.dropCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 6.43, absoluteTolerance: 0.01))

    #expect(point1.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 0.65, absoluteTolerance: 0.01))
    #expect(point2.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 1.34, absoluteTolerance: 0.01))
    #expect(point3.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 2.06, absoluteTolerance: 0.01))
    #expect(point4.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 2.82, absoluteTolerance: 0.01))
    #expect(point5.windageCorrection.converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 3.62, absoluteTolerance: 0.01))
    
    #expect(point0.travelTime.converted(to: .milliseconds).value.isApproximatelyEqual(to: 0.0, absoluteTolerance: 0.1))
    #expect(point1.travelTime.converted(to: .milliseconds).value.isApproximatelyEqual(to: 93.6, absoluteTolerance: 0.1))
    #expect(point2.travelTime.converted(to: .milliseconds).value.isApproximatelyEqual(to: 193.0, absoluteTolerance: 0.1))
    #expect(point3.travelTime.converted(to: .milliseconds).value.isApproximatelyEqual(to: 298.5, absoluteTolerance: 0.1))
    #expect(point4.travelTime.converted(to: .milliseconds).value.isApproximatelyEqual(to: 410.7, absoluteTolerance: 0.1))
    #expect(point5.travelTime.converted(to: .milliseconds).value.isApproximatelyEqual(to: 530.2, absoluteTolerance: 0.1))
}

@Test func g7DragModel() async throws {

    // 6.5 Creedmoor 140gr ELD-M: published G1 BC 0.646, G7 BC 0.326.
    // Solving with each model's coefficient should yield closely matching trajectories.
    func solve(_ model: DragModel, _ bc: Double) -> Ballistics {
        Ballistics.solve(
            dragCoefficient: bc,
            dragModel: model,
            initialVelocity: Measurement(value: 2710, unit: .feetPerSecond),
            sightHeight: Measurement(value: 1.5, unit: .inches),
            shootingAngle: Measurement(value: 0, unit: .degrees),
            zeroRange: Measurement(value: 100, unit: .yards),
            windSpeed: Measurement(value: 10, unit: .milesPerHour),
            windAngle: 90,
            weight: Measurement(value: 140, unit: .grains)
        )
    }

    let g1 = solve(.g1, 0.646)
    let g7 = solve(.g7, 0.326)

    for yards in [300.0, 500.0, 800.0] {
        let p1 = try #require(g1.getPoint(at: Measurement(value: yards, unit: .yards)))
        let p7 = try #require(g7.getPoint(at: Measurement(value: yards, unit: .yards)))
        let dropDiffMOA = abs(p1.dropCorrection.value - p7.dropCorrection.value)
        #expect(dropDiffMOA < 0.5, "Drop correction at \(yards) yd differs by \(dropDiffMOA) MOA")
        #expect(abs(p1.velocity.value - p7.velocity.value) < 60, "Velocity at \(yards) yd differs")
    }
}

@Test func g1IsDefaultDragModel() async throws {
    let implicit = Ballistics.solve(
        dragCoefficient: 0.414,
        initialVelocity: Measurement(value: 3300, unit: .feetPerSecond),
        sightHeight: Measurement(value: 1.8, unit: .inches),
        shootingAngle: Measurement(value: 0, unit: .degrees),
        zeroRange: Measurement(value: 100, unit: .yards),
        windSpeed: Measurement(value: 0, unit: .milesPerHour),
        windAngle: 0
    )
    let explicit = Ballistics.solve(
        dragCoefficient: 0.414,
        dragModel: .g1,
        initialVelocity: Measurement(value: 3300, unit: .feetPerSecond),
        sightHeight: Measurement(value: 1.8, unit: .inches),
        shootingAngle: Measurement(value: 0, unit: .degrees),
        zeroRange: Measurement(value: 100, unit: .yards),
        windSpeed: Measurement(value: 0, unit: .milesPerHour),
        windAngle: 0
    )
    let a = try #require(implicit.getPoint(at: Measurement(value: 500, unit: .yards)))
    let b = try #require(explicit.getPoint(at: Measurement(value: 500, unit: .yards)))
    #expect(a.drop == b.drop)
    #expect(a.velocity == b.velocity)
}
