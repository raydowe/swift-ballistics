//
//  TemperatureTests.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 05/12/2024.
//

import Testing
@testable import Ballistics
import Numerics

@Test func testTemperature() async throws {
    #expect(Temperature(celsius: 33).fahrenheit == 91.4)
    #expect(Temperature(fahrenheit: 5).celsius == -15)
}
