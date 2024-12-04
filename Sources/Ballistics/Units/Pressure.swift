//
//  Pressure.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 04/12/2024.
//

public struct Pressure {

    let inHg: Double
    var kPa: Double { inHg * 3.38639 }
    var mb: Double { inHg * 33.8639 }

    public init(inHg: Double) {
        self.inHg = inHg
    }

    public init(kPa: Double) {
        self.inHg = kPa / 3.38639
    }

    public init(mb: Double) {
        self.inHg = mb / 33.8639
    }
}
