//
//  UnitAngle.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 04/12/2024.
//

import Foundation

extension UnitAngle {
    public static var minutesOfAngle: UnitAngle { .arcMinutes }
    public static let milliradians: UnitAngle = UnitAngle(symbol: "mil", converter: UnitConverterLinear(coefficient: 3.43775))
}
