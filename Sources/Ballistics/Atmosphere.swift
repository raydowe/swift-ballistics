//
//  Atmosphere.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

public struct Atmosphere {

    // Drag coefficient atmospheric corrections
    static func calcFR(temperature: Double, pressure: Double, relativeHumidity: Double) -> Double {
        let VPw = 4e-6 * pow(temperature, 3) - 0.0004 * pow(temperature, 2) + 0.0234 * temperature - 0.2517
        let frh = 0.995 * (pressure / (pressure - (0.3783 * relativeHumidity * VPw)))
        return frh
    }

    static func calcFP(pressure: Double) -> Double {
        let pStd = 29.53 // Standard pressure at sea level in inHg
        let fp = (pressure - pStd) / pStd
        return fp
    }

    static func calcFT(temperature: Double, altitude: Double) -> Double {
        let tStd = -0.0036 * altitude + 59
        let ft = (temperature - tStd) / (459.6 + tStd)
        return ft
    }

    static func calcFA(altitude: Double) -> Double {
        let fa = -4e-15 * pow(altitude, 3) + 4e-10 * pow(altitude, 2) - 3e-5 * altitude + 1
        return 1 / fa
    }

    static func atmosphereCorrection(
        dragCoefficient: Double,
        altitude: Double,
        barometer: Double,
        temperature: Double,
        relativeHumidity: Double
    ) -> Double {
        let fa = calcFA(altitude: altitude)
        let ft = calcFT(temperature: temperature, altitude: altitude)
        let fr = calcFR(temperature: temperature, pressure: barometer, relativeHumidity: relativeHumidity)
        let fp = calcFP(pressure: barometer)

        // Calculate the atmospheric correction factor
        let cd = fa * (1 + ft - fp) * fr
        return dragCoefficient * cd
    }
}
