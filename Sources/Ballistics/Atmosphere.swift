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

     Returns the coefficient that gives the same drag in Army Standard Metro air (59 °F,
     29.53 inHg, 78% relative humidity, the conditions assumed when no atmosphere is given)
     as `dragCoefficient` gives in these conditions, using air density from the ideal gas law
     including water vapour. The solver uses density directly; this is provided for callers
     that want the equivalent coefficient.

     `pressure` is treated as barometric pressure corrected to sea level (as given in weather
     reports); it is converted to station pressure using `altitude`.

     - Parameter dragCoefficient: The base drag coefficient (G1 or G7) of the projectile.
     - Returns: The drag coefficient adjusted for the air density of these conditions.
     */
    public func adjustCoefficient(
        dragCoefficient: Double
    ) -> Double {
        dragCoefficient * Atmosphere.referenceDensity / density
    }

    /// Air density for these conditions, lb/ft³.
    var density: Double {
        Atmosphere.density(
            stationPressureInHg: stationPressureInHg,
            temperatureFahrenheit: temperature.converted(to: .fahrenheit).value,
            relativeHumidity: relativeHumidity
        )
    }

    /// Local speed of sound, ft/s (49.0223 · √°R).
    var speedOfSound: Double {
        49.0223 * sqrt(temperature.converted(to: .fahrenheit).value + 459.67)
    }

    /// Station (unadjusted) pressure at `altitude`, from the sea-level-corrected `pressure`.
    private var stationPressureInHg: Double {
        let altitudeFeet = altitude.converted(to: .feet).value
        return pressure.converted(to: .inchesOfMercury).value * pow(1 - 6.8753e-6 * altitudeFeet, 5.2559)
    }

    /// Air density in lb/ft³, from station pressure, temperature and humidity.
    static func density(stationPressureInHg: Double, temperatureFahrenheit: Double, relativeHumidity: Double) -> Double {
        let celsius = (temperatureFahrenheit - 32) * 5 / 9
        // Saturation vapour pressure (Arden Buck equation), hPa → inHg.
        let saturation = 6.1121 * exp((18.678 - celsius / 234.5) * (celsius / (257.14 + celsius))) / 33.8639
        let vapour = relativeHumidity * saturation
        // Ideal gas: ρ = P / (R·T); water vapour displaces denser dry air (1 − 0.622 ≈ 0.378).
        return 1.32562 * (stationPressureInHg - 0.3783 * vapour) / (temperatureFahrenheit + 459.67)
    }

    /// Army Standard Metro air density (≈ 0.0751 lb/ft³), assumed when no atmosphere is given.
    static let referenceDensity = density(stationPressureInHg: 29.53, temperatureFahrenheit: 59, relativeHumidity: 0.78)
}
