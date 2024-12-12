//
//  UnitAngleTests.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 05/12/2024.
//

import Foundation
import Testing
import Ballistics
import Numerics

@Test func testUnitAngle() async throws {
    #expect(Measurement<UnitAngle>(value: 4.7, unit: .milliradians).converted(to: .degrees).value.isApproximatelyEqual(to: 16.1, absoluteTolerance: 0.1))
    #expect(Measurement<UnitAngle>(value: 2, unit: .degrees).converted(to: .milliradians).value.isApproximatelyEqual(to: 0.58, absoluteTolerance: 0.01))

    #expect(Measurement<UnitAngle>(value: 1, unit: .minutesOfAngle).converted(to: .degrees).value.isApproximatelyEqual(to: 0.0166667, absoluteTolerance: 0.0000001))
    #expect(Measurement<UnitAngle>(value: 1, unit: .degrees).converted(to: .minutesOfAngle).value.isApproximatelyEqual(to: 60, absoluteTolerance: 0.01))
    #expect(Measurement<UnitAngle>(value: 1, unit: .minutesOfAngle).converted(to: .arcMinutes).value.isApproximatelyEqual(to: 1, absoluteTolerance: 0.0001))
}
