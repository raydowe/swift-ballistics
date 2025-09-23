//
//  Atmosphere.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

public struct Atmosphere {

    let pressure: Measurement<UnitPressure>
    let temperature: Measurement<UnitTemperature>
    let relativeHumidity: Double

    public init(
        pressure: Measurement<UnitPressure> = Measurement<UnitPressure>(value: 101325, unit: .newtonsPerMetersSquared),
        temperature: Measurement<UnitTemperature> = Measurement<UnitTemperature>(value: 15, unit: .celsius),
        relativeHumidity: Double = 0
    ) {
        self.pressure = pressure
        self.temperature = temperature
        self.relativeHumidity = relativeHumidity
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
