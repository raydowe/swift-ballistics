//
//  Pressure.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 04/12/2024.
//

public struct Pressure: Equatable, Hashable {

    let inHg: Double
    var kPa: Double { inHg * 3.38639 }
    var mb: Double { inHg * 33.8639 }

    public init(inHg: Double = 29.92) {
        self.inHg = inHg
    }

    public init(kPa: Double) {
        self.inHg = kPa / 3.38639
    }

    public init(millibars: Double) {
        self.inHg = millibars / 33.8639
    }
}
