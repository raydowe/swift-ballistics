//
//  ProjectileSpeedTests.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 05/12/2024.
//

import Testing
@testable import Ballistics
import Numerics

@Test func testProjectile() async throws {
    #expect(ProjectileSpeed(fps: 3300).ms.isApproximatelyEqual(to: 1005.84, absoluteTolerance: 0.01))
    #expect(ProjectileSpeed(ms: 900).fps.isApproximatelyEqual(to: 2952.76, absoluteTolerance: 0.01))
}
