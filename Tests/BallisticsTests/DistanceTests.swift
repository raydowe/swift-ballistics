//
//  DistanceTests.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 05/12/2024.
//

import Testing
@testable import Ballistics
import Numerics

@Test func testDistance() async throws {
    #expect(Distance(yards: 100).meters.isApproximatelyEqual(to: 91.44, absoluteTolerance: 0.01))
    #expect(Distance(meters: 100).yards.isApproximatelyEqual(to: 109.36, absoluteTolerance: 0.01))
}
