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
    #expect(Measurement<UnitAngle>(value: 2, unit: .degrees).converted(to: .milliradians).value.isApproximatelyEqual(to: 0.58, absoluteTolerance: 0.01))
    #expect(Measurement<UnitAngle>(value: 4.7, unit: .milliradians).converted(to: .degrees).value.isApproximatelyEqual(to: 16.1, absoluteTolerance: 0.1))
}
