//
//  PBRTests.swift
//  swift-ballistics
//

import Foundation
import Testing
@testable import Ballistics
import Numerics

private func pbr(_ model: DragModel, vital: Double = 8) throws -> PBR {
    try PBR.solve(
        dragModel: model,
        dragCoefficient: model == .g1 ? 0.414 : 0.210,
        initialVelocity: 3000,
        sightHeight: 1.5,
        vitalSize: vital
    ).get()
}

@Test(arguments: DragModel.allCases)
func pointBlankRangesAreOrdered(model: DragModel) throws {
    let p = try pbr(model)
    // Sight height (1.5 in) is inside the 4 in half-zone, so the zone starts at the muzzle.
    #expect(p.minPBRYards == 0)
    #expect(p.nearZeroYards > 0)
    #expect(p.nearZeroYards < p.farZeroYards)
    #expect(p.farZeroYards < p.maxPBRYards)
}

@Test(arguments: DragModel.allCases)
func pointBlankZeroKeepsTrajectoryInsideVitalZone(model: DragModel) throws {
    let p = try pbr(model)
    // Zero a full solution at the reported far zero and check it against the vital zone.
    let solution = Ballistics.solve(
        dragCoefficient: model == .g1 ? 0.414 : 0.210,
        dragModel: model,
        initialVelocity: Measurement(value: 3000, unit: .feetPerSecond),
        sightHeight: Measurement(value: 1.5, unit: .inches),
        shootingAngle: Measurement(value: 0, unit: .degrees),
        zeroRange: Measurement(value: Double(p.farZeroYards), unit: .yards),
        windSpeed: Measurement(value: 0, unit: .milesPerHour),
        windAngle: 0
    )
    var highest = -Double.infinity
    for yards in 0...p.maxPBRYards {
        let drop = try #require(solution.getPoint(at: Measurement(value: Double(yards), unit: .yards))).drop.converted(to: .inches).value
        highest = max(highest, drop)
        #expect(drop >= -4.05, "below the vital zone at \(yards) yd")
    }
    // Peaks at the top of the zone (yard truncation of the zero allows a small error).
    #expect(highest.isApproximatelyEqual(to: 4, absoluteTolerance: 0.05))
    // Leaves the zone at the reported maximum range.
    let beyond = try #require(solution.getPoint(at: Measurement(value: Double(p.maxPBRYards + 2), unit: .yards)))
    #expect(beyond.drop.converted(to: .inches).value < -4)

    // Height at 100 yd matches the full solution (hundredths of an inch).
    let at100 = try #require(solution.getPoint(at: Measurement(value: 100, unit: .yards))).drop.converted(to: .inches).value
    #expect(abs(Double(p.sightInAt100Yards) - at100 * 100) < 3)
}

@Test func largerVitalZoneExtendsPointBlankRange() throws {
    let small = try pbr(.g1, vital: 6)
    let large = try pbr(.g1, vital: 10)
    #expect(large.maxPBRYards > small.maxPBRYards)
    #expect(large.farZeroYards > small.farZeroYards)
}

@Test func unreachableVitalZoneFails() {
    let result = PBR.solve(dragCoefficient: 0.414, initialVelocity: 3000, sightHeight: 1.5, vitalSize: 1_000_000)
    #expect(throws: PBR.SolveError.unreachable) { try result.get() }
}
