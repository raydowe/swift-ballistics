//
//  Point.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

struct Point {
    var rangeYards: Double
    var pathInches: Double
    var moaCorrection: Double
    var seconds: Double
    var windageInches: Double
    var windageMoa: Double
    var velocityFPS: Double  // Total velocity -> vector product of vx and vy
    var velocityXFPS: Double // Velocity in the bore direction
    var velocityYFPS: Double // Velocity perpendicular to the bore direction
}
