//
//  Constants.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

struct Constants {

    static let BALLISTICS_COMPUTATION_MAX_YARDS = 50000
    static let GRAVITY = -32.194

    // Unit Conversions
    static let FEET_PER_YARD: Double = 3
    static let INCHES_PER_FOOT: Double = 12
    static let GRAINS_PER_POUND: Double = 7000

    // Wind
    static let MPH_TO_INCHES_PER_SECOND: Double = 17.6 // 1 mile/hr * 5280 ft/mile * 12 in/ft / 3600 s/hr
}
