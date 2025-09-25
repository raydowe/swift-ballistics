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
        pressure: Measurement<UnitPressure> = Measurement<UnitPressure>(value: 1000, unit: .newtonsPerMetersSquared),
        temperature: Measurement<UnitTemperature> = Measurement<UnitTemperature>(value: 10, unit: .celsius),
        relativeHumidity: Double = 0
    ) {
        self.altitude = altitude
        self.pressure = pressure
        self.temperature = temperature
        self.relativeHumidity = relativeHumidity
    }

    public init(
        altitude: Measurement<UnitLength>,
        temperature: Measurement<UnitTemperature> = Measurement<UnitTemperature>(value: 15, unit: .celsius),
        relativeHumidity: Double = 0
    ) {
        // Calculate pressure from altitude using the barometric formula.
        // P = P0 * (1 - L*h / T0)^(g*M / (R*L))
        // This is a simplified model and assumes a standard atmosphere.
        let p0 = 101325.0 // Sea level standard atmospheric pressure in Pascals
        let t0 = 288.15 // Sea level standard temperature in Kelvin
        let g = 9.80665 // Earth-surface gravitational acceleration
        let m = 0.0289644 // Molar mass of dry air
        let r = 8.3144598 // Universal gas constant
        let l = 0.0065 // Temperature lapse rate in K/m

        let h = altitude.converted(to: .meters).value
        let exponent = (g * m) / (r * l)
        let base = 1 - (l * h) / t0

        let pressureValue = p0 * pow(base, exponent)
        let pressure = Measurement(value: pressureValue, unit: UnitPressure.pascals)

        self.init(pressure: pressure, temperature: temperature, relativeHumidity: relativeHumidity)
    }

    /**
     Calculates the speed of sound for the given atmospheric conditions.
     - Returns: The speed of sound in meters per second.
    */
    public func speedOfSound() -> Double {
        let tempCelsius = temperature.converted(to: .celsius).value
        // Formula for speed of sound in air is sqrt(gamma * R * T)
        // For dry air, gamma = 1.4, R = 287.058 J/(kg·K)
        // This simplifies to approx 20.05 * sqrt(T_kelvin)
        let tempKelvin = temperature.converted(to: .kelvin).value
        return 20.05 * sqrt(tempKelvin)
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
}
