//
//  Measurement.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 04/12/2024.
//

public struct Measurement: Equatable, Hashable {

    public let inches: Double
    public var centimeters: Double { inches * 2.54 }

    public init(inches: Double) {
        self.inches = inches
    }

    public init(centimeters: Double) {
        self.inches = centimeters / 2.54
    }

}
