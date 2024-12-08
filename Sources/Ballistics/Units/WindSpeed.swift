//
//  WindSpeed.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 04/12/2024.
//

public struct WindSpeed {

    let mph: Double
    var kph: Double { mph * 1.6 }

    public init(mph: Double) {
        self.mph = mph
    }

    public init(kmh: Double) {
        self.mph = kmh / 1.6
    }
}
