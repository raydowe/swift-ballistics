//
//  Point.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

public struct Point: Equatable, Hashable {
    public let range: Measurement<UnitLength>
    public let drop: Measurement<UnitLength>
    public let dropCorrection: Measurement<UnitAngle>
    public let windage: Measurement<UnitLength>
    public let windageCorrection: Measurement<UnitAngle>
    public let seconds: Double
    public let travelTime: Measurement<UnitDuration>
    public let velocity: Measurement<UnitSpeed>
    public let velocityX: Measurement<UnitSpeed>
    public let velocityY: Measurement<UnitSpeed>
    public let energy: Measurement<UnitEnergy>
}

