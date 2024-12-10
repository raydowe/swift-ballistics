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
    public let velocity: ProjectileSpeed
    public let velocityX: ProjectileSpeed
    public let velocityY: ProjectileSpeed
    public let energy: Energy
}
