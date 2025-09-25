//
//  Constants.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

struct Constants {
    // Maximum simulation range in meters
    static let maxRange: Double = 5000

    // The simulation will stop if the projectile's angle of descent is too steep
    static let simulationStopSlope: Double = 3.0

    // A factor used to determine the time step in the simulation.
    // A smaller value increases accuracy but decreases performance.
    static let timeStepFactor: Double = 0.5

    // Standard gravity in meters per second squared
    static let gravity: Double = -9.80665
}
