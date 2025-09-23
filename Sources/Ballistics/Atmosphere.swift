//
//  Atmosphere.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

public struct Atmosphere {

    let altitude: Measurement<UnitLength>
    let pressure: Measurement<UnitPressure>
    let temperature: Measurement<UnitTemperature>
    let relativeHumidity: Double

    public init(
        altitude: Measurement<UnitLength> = Measurement<UnitLength>(value: 0, unit: .meters),
        pressure: Measurement<UnitPressure> = Measurement<UnitPressure>(value: 29.92, unit: .inchesOfMercury),
        temperature: Measurement<UnitTemperature> = Measurement<UnitTemperature>(value: 10, unit: .celsius),
        relativeHumidity: Double = 0
    ) {
        self.altitude = altitude
        self.pressure = pressure
        self.temperature = temperature
        self.relativeHumidity = relativeHumidity
    }

    /**
     Adjusts the ballistic drag coefficient based on atmospheric conditions.

     This method calculates a corrected drag coefficient by accounting for changes in altitude, barometric pressure, temperature, and relative humidity. These factors influence air density and, consequently, the drag force acting on a projectile.

     - Parameters:
       - dragCoefficient: The G1 base drag coefficient of the projectile, typically measured under standard atmospheric conditions.
       - altitude: The altitude above sea level in feet (ft).
       - barometer: The barometric pressure in inches of mercury (in Hg)
       - temperature: The ambient temperature in degrees Farenheit (°F).
       - relativeHumidity: The relative humidity as a percentage (0 to 1).

     - Returns:
       A `Double` representing the adjusted drag coefficient for the given atmospheric conditions.
     */

    public func adjustCoefficient(
        dragCoefficient: Double
    ) -> Double {
        let altitudeFeet = altitude.converted(to: .feet).value
        let temperatureFahrenheit = temperature.converted(to: .fahrenheit).value
        let pressureInHg = pressure.converted(to: .inchesOfMercury).value
        let fa = calcFA(altitude: altitudeFeet)
        let ft = calcFT(temperature: temperatureFahrenheit, altitude: altitudeFeet)
        let fr = calcFR(temperature: temperatureFahrenheit, pressure: pressureInHg, relativeHumidity: relativeHumidity)
        let fp = calcFP(pressure: pressureInHg)
        let cd = fa * (1 + ft - fp) * fr
        return dragCoefficient * cd
    }

    /**
     Calculates the speed of sound for the given atmospheric conditions.
     - Returns: The speed of sound in meters per second.
    */
    public func speedOfSound() -> Double {
        let tempCelsius = temperature.converted(to: .celsius).value
        // This formula is derived from the libballistics C code, which works in ft/s.
        // The constant 49.0223 is likely related to properties of air (gamma, R).
        // The result is converted from ft/s to m/s.
        let speedOfSoundFPS = sqrt(tempCelsius + 273.15) * 49.0223
        return speedOfSoundFPS * 0.3048
    }

    /**
     Calculates the air density for the given atmospheric conditions.
     - Returns: The air density in kg/m^3.
    */
    public func airDensity() -> Double {
        let p = self.pressure.converted(to: .newtonsPerMetersSquared).value
        let t = self.temperature.converted(to: .kelvin).value
        // Ignoring humidity for now for simplicity.
        // Formula for dry air: rho = P / (R_specific * T)
        // R_specific for dry air is approx. 287.058 J/(kg·K)
        return p / (287.058 * t)
    }

    // Drag coefficient atmospheric corrections
    private func calcFR(temperature: Double, pressure: Double, relativeHumidity: Double) -> Double {
        let VPw = 4e-6 * pow(temperature, 3) - 0.0004 * pow(temperature, 2) + 0.0234 * temperature - 0.2517
        let frh = 0.995 * (pressure / (pressure - (0.3783 * relativeHumidity * VPw)))
        return frh
    }

    private func calcFP(pressure: Double) -> Double {
        let pStd = 29.921 // Standard pressure at sea level in inHg
        let fp = (pressure - pStd) / pStd
        return fp
    }

    private func calcFT(temperature: Double, altitude: Double) -> Double {
        let tStd = -0.0036 * altitude + 59
        let ft = (temperature - tStd) / (459.6 + tStd)
        return ft
    }

    private func calcFA(altitude: Double) -> Double {
        let fa = -4e-15 * pow(altitude, 3) + 4e-10 * pow(altitude, 2) - 3e-5 * altitude + 1
        return 1 / fa
    }
}
