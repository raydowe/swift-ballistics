//
//  UnitAngle.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 04/12/2024.
//

import Foundation

extension UnitAngle {
    public static let minutesOfAngle: UnitAngle = UnitAngle(symbol: "moa", converter: UnitConverterLinear(coefficient: 1/60))
    public static let milliradians: UnitAngle = UnitAngle(symbol: "mil", converter: UnitConverterLinear(coefficient: 0.0572958))
}
