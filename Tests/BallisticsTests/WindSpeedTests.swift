//
//  WindSpeedTests.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 05/12/2024.
//

import Testing
@testable import Ballistics
import Numerics

@Test func testWindSpeed() async throws {
    #expect(WindSpeed(mph: 50).kph == 80)
    #expect(WindSpeed(kmh: 161).mph == 100.625)
}
