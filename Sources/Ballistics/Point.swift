//
//  Point.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

struct Point {
    var rangeYards: Distance
    var pathInches: Measurement
    var correction: Adjustment
    var seconds: Double
    var windageInches: Measurement
    var windageMoa: Adjustment
    var velocityFPS: ProjectileSpeed  // Total velocity -> vector product of vx and vy
    var velocityXFPS: ProjectileSpeed // Velocity in the bore direction
    var velocityYFPS: ProjectileSpeed // Velocity perpendicular to the bore direction
}
