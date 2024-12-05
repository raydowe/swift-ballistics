//
//  Distance.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 04/12/2024.
//

public struct Distance {
    
    let yards: Double
    var meters: Double { yards * 0.9144 }

    public init(yards: Double) {
        self.yards = yards
    }

    public init(meters: Double) {
        self.yards = meters * 1.0936
    }
}