import Testing
@testable import Ballistics
import Numerics

@Test func testSimple() async throws {

    let bc: Double = 0.414 // The ballistic coefficient for the projectile
    let v: Double = 3300 // Initial velocity, in ft/s
    let sh: Double = 1.8 // Sight height over bore, in inches
    let angle: Double = 0 // The shooting angle (uphill/downhill), in degrees
    let zero: Double = 100 // The zero range of the rifle, in yards

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: bc,
        initialVelocity: ProjectileSpeed(fps: v),
        sightHeight: Measurement(inches: sh),
        shootingAngle: angle,
        zeroRange: Distance(yards: zero),
        windSpeed: WindSpeed(mph: 0),
        windAngle: 0
    )

    #expect(solution.getRange(at: 0).yards.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(solution.getRange(at: 100).yards.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(solution.getRange(at: 200).yards.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(solution.getRange(at: 300).yards.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(solution.getRange(at: 400).yards.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(solution.getRange(at: 500).yards.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(solution.getElevation(at: 0).inches.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 100).inches.isApproximatelyEqual(to: -0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 200).inches.isApproximatelyEqual(to: -1.94, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 300).inches.isApproximatelyEqual(to: -8.25, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 400).inches.isApproximatelyEqual(to: -19.70, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 500).inches.isApproximatelyEqual(to: -37.23, absoluteTolerance: 0.01))

    #expect(solution.getWindage(at: 0).inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 100).inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 200).inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 300).inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 400).inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 500).inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))

    #expect(solution.getVelocity(at: 0).fps.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 100).fps.isApproximatelyEqual(to: 3055, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 200).fps.isApproximatelyEqual(to: 2824, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 300).fps.isApproximatelyEqual(to: 2605, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 400).fps.isApproximatelyEqual(to: 2395, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 500).fps.isApproximatelyEqual(to: 2196, absoluteTolerance: 1))

    #expect(solution.getTime(at: 0).isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 100).isApproximatelyEqual(to: 0.09, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 200).isApproximatelyEqual(to: 0.20, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 300).isApproximatelyEqual(to: 0.31, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 400).isApproximatelyEqual(to: 0.43, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 500).isApproximatelyEqual(to: 0.56, absoluteTolerance: 0.01))

    #expect(solution.getElevationCorrection(at: 100).moa.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 200).moa.isApproximatelyEqual(to: 0.92, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 300).moa.isApproximatelyEqual(to: 2.62, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 400).moa.isApproximatelyEqual(to: 4.70, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 500).moa.isApproximatelyEqual(to: 7.11, absoluteTolerance: 0.01))

    #expect(solution.getWindageCorrection(at: 100).moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 200).moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 300).moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 400).moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 500).moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
}

@Test func testWindage() async throws {

    let bc: Double = 0.414 // The ballistic coefficient for the projectile
    let v: Double = 3300 // Initial velocity, in ft/s
    let sh: Double = 1.8 // Sight height over bore, in inches
    let angle: Double = 0 // The shooting angle (uphill/downhill), in degrees
    let zero: Double = 100 // The zero range of the rifle, in yards
    let windspeed: Double = 20 // Wind speed in miles per hour
    let windangle: Double = 135 // Wind angle (0=headwind, 90=right to left, etc.)

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: bc,
        initialVelocity: ProjectileSpeed(fps: v),
        sightHeight: Measurement(inches: sh),
        shootingAngle: angle,
        zeroRange: Distance(yards: zero),
        windSpeed: WindSpeed(mph: windspeed),
        windAngle: windangle
    )

    #expect(solution.getRange(at: 0).yards.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(solution.getRange(at: 100).yards.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(solution.getRange(at: 200).yards.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(solution.getRange(at: 300).yards.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(solution.getRange(at: 400).yards.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(solution.getRange(at: 500).yards.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(solution.getElevation(at: 0).inches.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 100).inches.isApproximatelyEqual(to: -0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 200).inches.isApproximatelyEqual(to: -1.93, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 300).inches.isApproximatelyEqual(to: -8.23, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 400).inches.isApproximatelyEqual(to: -19.64, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 500).inches.isApproximatelyEqual(to: -37.10, absoluteTolerance: 0.01))

    #expect(solution.getWindage(at: 0).inches.isApproximatelyEqual(to: 0.04, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 100).inches.isApproximatelyEqual(to: 0.93, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 200).inches.isApproximatelyEqual(to: 3.70, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 300).inches.isApproximatelyEqual(to: 8.57, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 400).inches.isApproximatelyEqual(to: 15.77, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 500).inches.isApproximatelyEqual(to: 25.60, absoluteTolerance: 0.01))

    #expect(solution.getVelocity(at: 0).fps.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 100).fps.isApproximatelyEqual(to: 3057, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 200).fps.isApproximatelyEqual(to: 2828, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 300).fps.isApproximatelyEqual(to: 2610, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 400).fps.isApproximatelyEqual(to: 2402, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 500).fps.isApproximatelyEqual(to: 2204, absoluteTolerance: 1))

    #expect(solution.getTime(at: 0).isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 100).isApproximatelyEqual(to: 0.09, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 200).isApproximatelyEqual(to: 0.20, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 300).isApproximatelyEqual(to: 0.31, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 400).isApproximatelyEqual(to: 0.43, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 500).isApproximatelyEqual(to: 0.56, absoluteTolerance: 0.01))

    #expect(solution.getElevationCorrection(at: 100).moa.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 200).moa.isApproximatelyEqual(to: 0.92, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 300).moa.isApproximatelyEqual(to: 2.62, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 400).moa.isApproximatelyEqual(to: 4.68, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 500).moa.isApproximatelyEqual(to: 7.08, absoluteTolerance: 0.01))

    #expect(solution.getWindageCorrection(at: 100).moa.isApproximatelyEqual(to: 0.88, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 200).moa.isApproximatelyEqual(to: 1.77, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 300).moa.isApproximatelyEqual(to: 2.73, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 400).moa.isApproximatelyEqual(to: 3.76, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 500).moa.isApproximatelyEqual(to: 4.89, absoluteTolerance: 0.01))
}

@Test func testPressure() async throws {

    var bc: Double = 0.414 // The ballistic coefficient for the projectile
    let v: Double = 3300 // Initial velocity, in ft/s
    let sh: Double = 1.8 // Sight height over bore, in inches
    let angle: Double = 0 // The shooting angle (uphill/downhill), in degrees
    let zero: Double = 100 // The zero range of the rifle, in yards

    let temperature: Double = 59 // Atmospheric temperature in degrees Fahrenheit
    let humidity: Double = 0.5 // Relative humidity in percentage between 0 and 1
    let barometer: Double = 31.01 // Barometric pressure in inHg
    let altitude: Double = 0 // Altitude above sea level in feet
    let windspeed: Double = 20 // Wind speed in miles per hour
    let windangle: Double = 135 // Wind angle (0=headwind, 90=right to left, etc.)

    // Optional: Correct the ballistic coefficient for weather conditions
    bc = Atmosphere.adjustCoefficient(
        dragCoefficient: bc,
        altitude: Altitude(feet: altitude),
        barometer: Pressure(inHg: barometer),
        temperature: Temperature(fahrenheit: temperature),
        relativeHumidity: humidity
    )

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: bc,
        initialVelocity: ProjectileSpeed(fps: v),
        sightHeight: Measurement(inches: sh),
        shootingAngle: angle,
        zeroRange: Distance(yards: zero),
        windSpeed: WindSpeed(mph: windspeed),
        windAngle: windangle
    )

    #expect(solution.getRange(at: 0).yards.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(solution.getRange(at: 100).yards.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(solution.getRange(at: 200).yards.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(solution.getRange(at: 300).yards.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(solution.getRange(at: 400).yards.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(solution.getRange(at: 500).yards.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(solution.getElevation(at: 0).inches.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 100).inches.isApproximatelyEqual(to: -0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 200).inches.isApproximatelyEqual(to: -1.96, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 300).inches.isApproximatelyEqual(to: -8.34, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 400).inches.isApproximatelyEqual(to: -19.94, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 500).inches.isApproximatelyEqual(to: -37.74, absoluteTolerance: 0.01))

    #expect(solution.getWindage(at: 0).inches.isApproximatelyEqual(to: 0.04, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 100).inches.isApproximatelyEqual(to: 0.96, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 200).inches.isApproximatelyEqual(to: 3.86, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 300).inches.isApproximatelyEqual(to: 8.94, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 400).inches.isApproximatelyEqual(to: 16.49, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 500).inches.isApproximatelyEqual(to: 26.82, absoluteTolerance: 0.01))

    #expect(solution.getVelocity(at: 0).fps.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 100).fps.isApproximatelyEqual(to: 3048, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 200).fps.isApproximatelyEqual(to: 2810, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 300).fps.isApproximatelyEqual(to: 2585, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 400).fps.isApproximatelyEqual(to: 2370, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 500).fps.isApproximatelyEqual(to: 2166, absoluteTolerance: 1))

    #expect(solution.getTime(at: 0).isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 100).isApproximatelyEqual(to: 0.09, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 200).isApproximatelyEqual(to: 0.20, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 300).isApproximatelyEqual(to: 0.31, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 400).isApproximatelyEqual(to: 0.43, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 500).isApproximatelyEqual(to: 0.56, absoluteTolerance: 0.01))

    #expect(solution.getElevationCorrection(at: 100).moa.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 200).moa.isApproximatelyEqual(to: 0.94, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 300).moa.isApproximatelyEqual(to: 2.65, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 400).moa.isApproximatelyEqual(to: 4.76, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 500).moa.isApproximatelyEqual(to: 7.20, absoluteTolerance: 0.01))

    #expect(solution.getWindageCorrection(at: 100).moa.isApproximatelyEqual(to: 0.92, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 200).moa.isApproximatelyEqual(to: 1.84, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 300).moa.isApproximatelyEqual(to: 2.85, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 400).moa.isApproximatelyEqual(to: 3.94, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 500).moa.isApproximatelyEqual(to: 5.12, absoluteTolerance: 0.01))
}

@Test func testTemperature() async throws {

    var bc: Double = 0.414 // The ballistic coefficient for the projectile
    let v: Double = 3300 // Initial velocity, in ft/s
    let sh: Double = 1.8 // Sight height over bore, in inches
    let angle: Double = 0 // The shooting angle (uphill/downhill), in degrees
    let zero: Double = 100 // The zero range of the rifle, in yards

    let temperature: Double = -20 // Atmospheric temperature in degrees Fahrenheit
    let humidity: Double = 0.5 // Relative humidity in percentage between 0 and 1
    let barometer: Double = 29.92 // Barometric pressure in inHg
    let altitude: Double = 0 // Altitude above sea level in feet
    let windspeed: Double = 20 // Wind speed in miles per hour
    let windangle: Double = 135 // Wind angle (0=headwind, 90=right to left, etc.)

    // Optional: Correct the ballistic coefficient for weather conditions
    bc = Atmosphere.adjustCoefficient(
        dragCoefficient: bc,
        altitude: Altitude(feet: altitude),
        barometer: Pressure(inHg: barometer),
        temperature: Temperature(fahrenheit: temperature),
        relativeHumidity: humidity
    )

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: bc,
        initialVelocity: ProjectileSpeed(fps: v),
        sightHeight: Measurement(inches: sh),
        shootingAngle: angle,
        zeroRange: Distance(yards: zero),
        windSpeed: WindSpeed(mph: windspeed),
        windAngle: windangle
    )

    #expect(solution.getRange(at: 0).yards.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(solution.getRange(at: 100).yards.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(solution.getRange(at: 200).yards.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(solution.getRange(at: 300).yards.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(solution.getRange(at: 400).yards.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(solution.getRange(at: 500).yards.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(solution.getElevation(at: 0).inches.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 100).inches.isApproximatelyEqual(to: -0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 200).inches.isApproximatelyEqual(to: -2.06, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 300).inches.isApproximatelyEqual(to: -8.75, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 400).inches.isApproximatelyEqual(to: -21.08, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 500).inches.isApproximatelyEqual(to: -40.32, absoluteTolerance: 0.01))

    #expect(solution.getWindage(at: 0).inches.isApproximatelyEqual(to: 0.04, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 100).inches.isApproximatelyEqual(to: 1.11, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 200).inches.isApproximatelyEqual(to: 4.47, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 300).inches.isApproximatelyEqual(to: 10.43, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 400).inches.isApproximatelyEqual(to: 19.37, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 500).inches.isApproximatelyEqual(to: 31.77, absoluteTolerance: 0.01))

    #expect(solution.getVelocity(at: 0).fps.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 100).fps.isApproximatelyEqual(to: 3012, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 200).fps.isApproximatelyEqual(to: 2742, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 300).fps.isApproximatelyEqual(to: 2489, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 400).fps.isApproximatelyEqual(to: 2249, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 500).fps.isApproximatelyEqual(to: 2023, absoluteTolerance: 1))

    #expect(solution.getTime(at: 0).isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 100).isApproximatelyEqual(to: 0.10, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 200).isApproximatelyEqual(to: 0.20, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 300).isApproximatelyEqual(to: 0.31, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 400).isApproximatelyEqual(to: 0.44, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 500).isApproximatelyEqual(to: 0.58, absoluteTolerance: 0.01))

    #expect(solution.getElevationCorrection(at: 100).moa.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 200).moa.isApproximatelyEqual(to: 0.98, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 300).moa.isApproximatelyEqual(to: 2.78, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 400).moa.isApproximatelyEqual(to: 5.03, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 500).moa.isApproximatelyEqual(to: 7.70, absoluteTolerance: 0.01))

    #expect(solution.getWindageCorrection(at: 100).moa.isApproximatelyEqual(to: 1.05, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 200).moa.isApproximatelyEqual(to: 2.13, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 300).moa.isApproximatelyEqual(to: 3.32, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 400).moa.isApproximatelyEqual(to: 4.62, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 500).moa.isApproximatelyEqual(to: 6.07, absoluteTolerance: 0.01))
}

@Test func testAltitude() async throws {

    var bc: Double = 0.414 // The ballistic coefficient for the projectile
    let v: Double = 3300 // Initial velocity, in ft/s
    let sh: Double = 1.8 // Sight height over bore, in inches
    let angle: Double = 0 // The shooting angle (uphill/downhill), in degrees
    let zero: Double = 100 // The zero range of the rifle, in yards

    let temperature: Double = 59 // Atmospheric temperature in degrees Fahrenheit
    let humidity: Double = 0.5 // Relative humidity in percentage between 0 and 1
    let barometer: Double = 29.92 // Barometric pressure in inHg
    let altitude: Double = 10000 // Altitude above sea level in feet
    let windspeed: Double = 20 // Wind speed in miles per hour
    let windangle: Double = 135 // Wind angle (0=headwind, 90=right to left, etc.)

    // Optional: Correct the ballistic coefficient for weather conditions
    bc = Atmosphere.adjustCoefficient(
        dragCoefficient: bc,
        altitude: Altitude(feet: altitude),
        barometer: Pressure(inHg: barometer),
        temperature: Temperature(fahrenheit: temperature),
        relativeHumidity: humidity
    )

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: bc,
        initialVelocity: ProjectileSpeed(fps: v),
        sightHeight: Measurement(inches: sh),
        shootingAngle: angle,
        zeroRange: Distance(yards: zero),
        windSpeed: WindSpeed(mph: windspeed),
        windAngle: windangle
    )

    #expect(solution.getRange(at: 0).yards.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(solution.getRange(at: 100).yards.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(solution.getRange(at: 200).yards.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(solution.getRange(at: 300).yards.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(solution.getRange(at: 400).yards.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(solution.getRange(at: 500).yards.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(solution.getElevation(at: 0).inches.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 100).inches.isApproximatelyEqual(to: -0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 200).inches.isApproximatelyEqual(to: -1.75, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 300).inches.isApproximatelyEqual(to: -7.45, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 400).inches.isApproximatelyEqual(to: -17.54, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 500).inches.isApproximatelyEqual(to: -32.54, absoluteTolerance: 0.01))

    #expect(solution.getWindage(at: 0).inches.isApproximatelyEqual(to: 0.04, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 100).inches.isApproximatelyEqual(to: 0.64, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 200).inches.isApproximatelyEqual(to: 2.50, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 300).inches.isApproximatelyEqual(to: 5.70, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 400).inches.isApproximatelyEqual(to: 10.34, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 500).inches.isApproximatelyEqual(to: 16.54, absoluteTolerance: 0.01))

    #expect(solution.getVelocity(at: 0).fps.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 100).fps.isApproximatelyEqual(to: 3132, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 200).fps.isApproximatelyEqual(to: 2970, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 300).fps.isApproximatelyEqual(to: 2815, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 400).fps.isApproximatelyEqual(to: 2665, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 500).fps.isApproximatelyEqual(to: 2520, absoluteTolerance: 1))

    #expect(solution.getTime(at: 0).isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 100).isApproximatelyEqual(to: 0.09, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 200).isApproximatelyEqual(to: 0.19, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 300).isApproximatelyEqual(to: 0.30, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 400).isApproximatelyEqual(to: 0.41, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 500).isApproximatelyEqual(to: 0.52, absoluteTolerance: 0.01))

    #expect(solution.getElevationCorrection(at: 100).moa.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 200).moa.isApproximatelyEqual(to: 0.83, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 300).moa.isApproximatelyEqual(to: 2.37, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 400).moa.isApproximatelyEqual(to: 4.18, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 500).moa.isApproximatelyEqual(to: 6.21, absoluteTolerance: 0.01))

    #expect(solution.getWindageCorrection(at: 100).moa.isApproximatelyEqual(to: 0.61, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 200).moa.isApproximatelyEqual(to: 1.19, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 300).moa.isApproximatelyEqual(to: 1.81, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 400).moa.isApproximatelyEqual(to: 2.47, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 500).moa.isApproximatelyEqual(to: 3.16, absoluteTolerance: 0.01))
}

@Test func testHumidity() async throws {

    var bc: Double = 0.414 // The ballistic coefficient for the projectile
    let v: Double = 3300 // Initial velocity, in ft/s
    let sh: Double = 1.8 // Sight height over bore, in inches
    let angle: Double = 0 // The shooting angle (uphill/downhill), in degrees
    let zero: Double = 100 // The zero range of the rifle, in yards

    let temperature: Double = 59 // Atmospheric temperature in degrees Fahrenheit
    let humidity: Double = 0.9 // Relative humidity in percentage between 0 and 1
    let barometer: Double = 29.92 // Barometric pressure in inHg
    let altitude: Double = 0 // Altitude above sea level in feet
    let windspeed: Double = 20 // Wind speed in miles per hour
    let windangle: Double = 135 // Wind angle (0=headwind, 90=right to left, etc.)

    // Optional: Correct the ballistic coefficient for weather conditions
    bc = Atmosphere.adjustCoefficient(
        dragCoefficient: bc,
        altitude: Altitude(feet: altitude),
        barometer: Pressure(inHg: barometer),
        temperature: Temperature(fahrenheit: temperature),
        relativeHumidity: humidity
    )

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: bc,
        initialVelocity: ProjectileSpeed(fps: v),
        sightHeight: Measurement(inches: sh),
        shootingAngle: angle,
        zeroRange: Distance(yards: zero),
        windSpeed: WindSpeed(mph: windspeed),
        windAngle: windangle
    )

    #expect(solution.getRange(at: 0).yards.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(solution.getRange(at: 100).yards.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(solution.getRange(at: 200).yards.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(solution.getRange(at: 300).yards.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(solution.getRange(at: 400).yards.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(solution.getRange(at: 500).yards.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(solution.getElevation(at: 0).inches.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 100).inches.isApproximatelyEqual(to: -0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 200).inches.isApproximatelyEqual(to: -1.93, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 300).inches.isApproximatelyEqual(to: -8.22, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 400).inches.isApproximatelyEqual(to: -19.63, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: 500).inches.isApproximatelyEqual(to: -37.07, absoluteTolerance: 0.01))

    #expect(solution.getWindage(at: 0).inches.isApproximatelyEqual(to: 0.04, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 100).inches.isApproximatelyEqual(to: 0.93, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 200).inches.isApproximatelyEqual(to: 3.70, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 300).inches.isApproximatelyEqual(to: 8.56, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 400).inches.isApproximatelyEqual(to: 15.75, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 500).inches.isApproximatelyEqual(to: 25.56, absoluteTolerance: 0.01))

    #expect(solution.getVelocity(at: 0).fps.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 100).fps.isApproximatelyEqual(to: 3057, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 200).fps.isApproximatelyEqual(to: 2828, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 300).fps.isApproximatelyEqual(to: 2611, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 400).fps.isApproximatelyEqual(to: 2403, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 500).fps.isApproximatelyEqual(to: 2205, absoluteTolerance: 1))

    #expect(solution.getTime(at: 0).isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 100).isApproximatelyEqual(to: 0.09, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 200).isApproximatelyEqual(to: 0.20, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 300).isApproximatelyEqual(to: 0.31, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 400).isApproximatelyEqual(to: 0.43, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: 500).isApproximatelyEqual(to: 0.56, absoluteTolerance: 0.01))

    #expect(solution.getElevationCorrection(at: 100).moa.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 200).moa.isApproximatelyEqual(to: 0.92, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 300).moa.isApproximatelyEqual(to: 2.61, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 400).moa.isApproximatelyEqual(to: 4.68, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: 500).moa.isApproximatelyEqual(to: 7.08, absoluteTolerance: 0.01))

    #expect(solution.getWindageCorrection(at: 100).moa.isApproximatelyEqual(to: 0.88, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 200).moa.isApproximatelyEqual(to: 1.76, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 300).moa.isApproximatelyEqual(to: 2.72, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 400).moa.isApproximatelyEqual(to: 3.76, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: 500).moa.isApproximatelyEqual(to: 4.88, absoluteTolerance: 0.01))
}
