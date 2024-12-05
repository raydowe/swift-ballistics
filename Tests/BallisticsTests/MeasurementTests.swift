//
//  MeasurementTests.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 05/12/2024.
//

import Testing
@testable import Ballistics
import Numerics

@Test func testMeasurement() async throws {
    #expect(Measurement(inches: 2).centimeters.isApproximatelyEqual(to: 5.08, absoluteTolerance: 0.01))
    #expect(Measurement(centimeters: 4.6).inches.isApproximatelyEqual(to: 1.81, absoluteTolerance: 0.01))
}
