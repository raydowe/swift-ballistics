//
//  Point.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

public struct Point {
    public let range: Distance
    public let drop: Measurement
    public let dropCorrection: Adjustment
    public let windage: Measurement
    public let windageCorrection: Adjustment
    public let seconds: Double
    public let velocity: ProjectileSpeed  // Total velocity -> vector product of vx and vy
    public let velocityX: ProjectileSpeed // Velocity in the bore direction
    public let velocityY: ProjectileSpeed // Velocity perpendicular to the bore direction
}
