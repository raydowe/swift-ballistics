//
//  Point.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

public struct Point {
    var range: Distance
    var drop: Measurement
    var dropCorrection: Adjustment
    var windage: Measurement
    var windageCorrection: Adjustment
    var seconds: Double
    var velocity: ProjectileSpeed  // Total velocity -> vector product of vx and vy
    var velocityX: ProjectileSpeed // Velocity in the bore direction
    var velocityY: ProjectileSpeed // Velocity perpendicular to the bore direction
}
