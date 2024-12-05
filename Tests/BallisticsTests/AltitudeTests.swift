//
//  AltitudeTests.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 05/12/2024.
//

import Testing
@testable import Ballistics
import Numerics

@Test func testAltitude() async throws {
    #expect(Altitude(meters: 300).feet.isApproximatelyEqual(to: 984.25, absoluteTolerance: 0.01))
    #expect(Altitude(feet: 7500).meters.isApproximatelyEqual(to: 2286, absoluteTolerance: 0.01))
}
