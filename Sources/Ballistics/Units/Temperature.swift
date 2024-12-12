//
//  Temperature.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 04/12/2024.
//

public struct Temperature: Equatable, Hashable {

    public let fahrenheit: Double
    public var celsius: Double { (fahrenheit - 32) * 5 / 9 }

    public init(fahrenheit: Double) {
        self.fahrenheit = fahrenheit
    }

    public init(celsius: Double = 20) {
        self.fahrenheit = (celsius * 9 / 5) + 32
    }
}
