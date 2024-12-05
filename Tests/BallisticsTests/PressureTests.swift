//
//  PressureTests.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 05/12/2024.
//

import Testing
@testable import Ballistics
import Numerics

@Test func testPressure() async throws {
    #expect(Pressure(inHg: 29.92).kPa.isApproximatelyEqual(to: 101.32, absoluteTolerance: 0.01))
    #expect(Pressure(inHg: 29.92).mb.isApproximatelyEqual(to: 1013.20, absoluteTolerance: 0.01))
    #expect(Pressure(kPa: 101.32).inHg.isApproximatelyEqual(to: 29.92, absoluteTolerance: 0.01))
    #expect(Pressure(kPa: 101.32).mb.isApproximatelyEqual(to: 1013.20, absoluteTolerance: 0.01))
    #expect(Pressure(millibars: 1013.20).inHg.isApproximatelyEqual(to: 29.92, absoluteTolerance: 0.01))
    #expect(Pressure(millibars: 1013.20).kPa.isApproximatelyEqual(to: 101.32, absoluteTolerance: 0.01))
}
