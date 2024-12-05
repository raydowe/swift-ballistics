//
//  Measurement.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 04/12/2024.
//

public struct Measurement {

    public let inches: Double
    public var centimeters: Double { inches * 2.54 }

    init(inches: Double) {
        self.inches = inches
    }

    init(centimeters: Double) {
        self.inches = centimeters / 2.54
    }

}
