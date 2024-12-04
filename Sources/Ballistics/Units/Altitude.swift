//
//  Altitude.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 04/12/2024.
//

public struct Altitude {

    let feet: Double
    var meters: Double { feet * 0.3048 }

    public init(feet: Double) {
        self.feet = feet
    }

    public init(meters: Double) {
        self.feet = meters / 0.3048
    }
}
