//
//  AdjustmentTests.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 05/12/2024.
//

import Testing
@testable import Ballistics
import Numerics

@Test func testAdjustments() async throws {
    #expect(Adjustment(moa: 2).mils.isApproximatelyEqual(to: 0.58, absoluteTolerance: 0.01))
    #expect(Adjustment(mils: 4.7).moa.isApproximatelyEqual(to: 16.1, absoluteTolerance: 0.1))
}
