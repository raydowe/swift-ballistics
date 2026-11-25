//
//  SamplingTests.swift
//  swift-ballistics
//

import Foundation
import Testing
import Ballistics
import Numerics

private func solve(
    _ model: DragModel,
    unit: UnitLength,
    step: Measurement<UnitLength>,
    windSpeed: Double = 10
) -> Ballistics {
    Ballistics.solve(
        preferredDistanceUnit: unit,
        dragCoefficient: model == .g1 ? 0.414 : 0.210,
        dragModel: model,
        initialVelocity: Measurement(value: 3000, unit: .feetPerSecond),
        sightHeight: Measurement(value: 1.8, unit: .inches),
        shootingAngle: Measurement(value: 0, unit: .degrees),
        zeroRange: Measurement(value: 100, unit: .meters),
        windSpeed: Measurement(value: windSpeed, unit: .milesPerHour),
        windAngle: 90,
        weight: Measurement(value: 120, unit: .grains),
        distanceStep: step
    )
}

@Test(arguments: DragModel.allCases)
func offGridDistanceReturnsNil(model: DragModel) {
    let yards = solve(model, unit: .yards, step: Measurement(value: 1, unit: .yards))
    // 100 m = 109.36 yd: not a sample on a 1 yd grid.
    #expect(yards.getPoint(at: Measurement(value: 100, unit: .meters)) == nil)
    #expect(yards.getPoint(at: Measurement(value: 250.5, unit: .yards)) == nil)

    let meters = solve(model, unit: .meters, step: Measurement(value: 25, unit: .meters))
    #expect(meters.getPoint(at: Measurement(value: 30, unit: .meters)) == nil)
    #expect(meters.getPoint(at: Measurement(value: 100, unit: .yards)) == nil)
}

@Test(arguments: DragModel.allCases)
func outOfRangeDistanceReturnsNil(model: DragModel) {
    let s = solve(model, unit: .meters, step: Measurement(value: 1, unit: .meters))
    #expect(s.getPoint(at: Measurement(value: -1, unit: .meters)) == nil)
    #expect(s.getPoint(at: Measurement(value: 1_000, unit: .kilometers)) == nil)
}

@Test(arguments: DragModel.allCases)
func onGridDistanceIsReturnedExactly(model: DragModel) throws {
    let meters = solve(model, unit: .meters, step: Measurement(value: 1, unit: .meters))
    for distance in [0.0, 1, 100, 437, 800] {
        let p = try #require(meters.getPoint(at: Measurement(value: distance, unit: .meters)))
        #expect(p.range.unit == .meters)
        #expect(p.range.value == distance)
    }

    // A distance expressed in another unit is still found when it falls exactly on the grid.
    let yards = solve(model, unit: .yards, step: Measurement(value: 1, unit: .yards))
    let p = try #require(yards.getPoint(at: Measurement(value: 914.4, unit: .meters)))
    #expect(p.range.value == 1000)
    #expect(p.range.unit == .yards)
}

@Test(arguments: DragModel.allCases)
func samplingUnitDoesNotChangeResults(model: DragModel) throws {
    // 914.4 m is exactly 1000 yd; both grids land on it, so results must agree to within the
    // RK4 integrator's (negligible) dependence on its step sequence.
    let yards = try #require(solve(model, unit: .yards, step: Measurement(value: 1, unit: .yards))
        .getPoint(at: Measurement(value: 1000, unit: .yards)))
    let meters = try #require(solve(model, unit: .meters, step: Measurement(value: 0.1, unit: .meters))
        .getPoint(at: Measurement(value: 914.4, unit: .meters)))
    #expect(meters.drop.converted(to: .inches).value.isApproximatelyEqual(to: yards.drop.converted(to: .inches).value, absoluteTolerance: 1e-4))
    #expect(meters.windage.converted(to: .inches).value.isApproximatelyEqual(to: yards.windage.converted(to: .inches).value, absoluteTolerance: 1e-4))
    #expect(meters.velocity.value.isApproximatelyEqual(to: yards.velocity.value, absoluteTolerance: 1e-4))
    #expect(meters.travelTime.value.isApproximatelyEqual(to: yards.travelTime.value, absoluteTolerance: 1e-7))
}

@Test(arguments: DragModel.allCases)
func samplingStepDoesNotChangeResults(model: DragModel) throws {
    // Each sample is landed on exactly, so coarse and fine grids report the same values.
    let fine = try #require(solve(model, unit: .meters, step: Measurement(value: 1, unit: .meters))
        .getPoint(at: Measurement(value: 600, unit: .meters)))
    let coarse = try #require(solve(model, unit: .meters, step: Measurement(value: 100, unit: .meters))
        .getPoint(at: Measurement(value: 600, unit: .meters)))
    #expect(coarse.drop.converted(to: .inches).value.isApproximatelyEqual(to: fine.drop.converted(to: .inches).value, absoluteTolerance: 1e-4))
    #expect(coarse.windage.converted(to: .inches).value.isApproximatelyEqual(to: fine.windage.converted(to: .inches).value, absoluteTolerance: 1e-4))
    #expect(coarse.velocity.value.isApproximatelyEqual(to: fine.velocity.value, absoluteTolerance: 1e-4))
}

@Test(arguments: DragModel.allCases)
func metricZeroRangeIsZeroedInMeters(model: DragModel) throws {
    let s = solve(model, unit: .meters, step: Measurement(value: 1, unit: .meters), windSpeed: 0)
    let p = try #require(s.getPoint(at: Measurement(value: 100, unit: .meters)))
    #expect(abs(p.drop.converted(to: .inches).value) < 0.05)
}

@Test func defaultStepIsOneOfPreferredUnit() throws {
    let s = Ballistics.solve(
        preferredDistanceUnit: .meters,
        dragCoefficient: 0.414,
        initialVelocity: Measurement(value: 3000, unit: .feetPerSecond),
        sightHeight: Measurement(value: 1.8, unit: .inches),
        shootingAngle: Measurement(value: 0, unit: .degrees),
        zeroRange: Measurement(value: 100, unit: .meters),
        windSpeed: Measurement(value: 0, unit: .milesPerHour),
        windAngle: 0
    )
    let p = try #require(s.getPoint(at: Measurement(value: 200, unit: .meters)))
    #expect(p.range == Measurement(value: 200, unit: .meters))
    #expect(s.getPoint(at: Measurement(value: 201, unit: .meters)) != nil)
}
