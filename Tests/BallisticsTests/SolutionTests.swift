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

    #expect(solution.getRange(at: Distance(yards: 0)).yards.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(solution.getRange(at: Distance(yards: 100)).yards.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(solution.getRange(at: Distance(yards: 200)).yards.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(solution.getRange(at: Distance(yards: 300)).yards.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(solution.getRange(at: Distance(yards: 400)).yards.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(solution.getRange(at: Distance(yards: 500)).yards.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(solution.getElevation(at: Distance(yards: 0)).inches.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: Distance(yards: 100)).inches.isApproximatelyEqual(to: -0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: Distance(yards: 200)).inches.isApproximatelyEqual(to: -1.94, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: Distance(yards: 300)).inches.isApproximatelyEqual(to: -8.25, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: Distance(yards: 400)).inches.isApproximatelyEqual(to: -19.70, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: Distance(yards: 500)).inches.isApproximatelyEqual(to: -37.23, absoluteTolerance: 0.01))

    #expect(solution.getWindage(at: Distance(yards: 0)).inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: Distance(yards: 100)).inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: Distance(yards: 200)).inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: Distance(yards: 300)).inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: Distance(yards: 400)).inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: Distance(yards: 500)).inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))

    #expect(solution.getVelocity(at: Distance(yards: 0)).fps.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: Distance(yards: 100)).fps.isApproximatelyEqual(to: 3055, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: Distance(yards: 200)).fps.isApproximatelyEqual(to: 2824, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: Distance(yards: 300)).fps.isApproximatelyEqual(to: 2605, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: Distance(yards: 400)).fps.isApproximatelyEqual(to: 2395, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: Distance(yards: 500)).fps.isApproximatelyEqual(to: 2196, absoluteTolerance: 1))

    #expect(solution.getTime(at: Distance(yards: 0)).isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: Distance(yards: 100)).isApproximatelyEqual(to: 0.09, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: Distance(yards: 200)).isApproximatelyEqual(to: 0.20, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: Distance(yards: 300)).isApproximatelyEqual(to: 0.31, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: Distance(yards: 400)).isApproximatelyEqual(to: 0.43, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: Distance(yards: 500)).isApproximatelyEqual(to: 0.56, absoluteTolerance: 0.01))

    #expect(solution.getElevationCorrection(at: Distance(yards: 100)).moa.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: Distance(yards: 200)).moa.isApproximatelyEqual(to: 0.92, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: Distance(yards: 300)).moa.isApproximatelyEqual(to: 2.62, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: Distance(yards: 400)).moa.isApproximatelyEqual(to: 4.70, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: Distance(yards: 500)).moa.isApproximatelyEqual(to: 7.11, absoluteTolerance: 0.01))

    #expect(solution.getWindageCorrection(at: Distance(yards: 100)).moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: Distance(yards: 200)).moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: Distance(yards: 300)).moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: Distance(yards: 400)).moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: Distance(yards: 500)).moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
}

@Test func testEnvironment() async throws {

    // Optional: Correct the ballistic coefficient for weather conditions
    let bc = Atmosphere.adjustCoefficient(
        dragCoefficient: 0.414,
        altitude: Altitude(feet: 10000),
        barometer: Pressure(inHg: 30.10),
        temperature: Temperature(fahrenheit: 5),
        relativeHumidity: 0.9
    )

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: bc,
        initialVelocity: ProjectileSpeed(fps: 3300),
        sightHeight: Measurement(inches: 1.8),
        shootingAngle: 0,
        zeroRange: Distance(yards: 100),
        windSpeed: WindSpeed(mph: 20),
        windAngle: 135
    )

    #expect(solution.getRange(at: Distance(yards: 0)).yards.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(solution.getRange(at: Distance(yards: 100)).yards.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(solution.getRange(at: Distance(yards: 200)).yards.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(solution.getRange(at: Distance(yards: 300)).yards.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(solution.getRange(at: Distance(yards: 400)).yards.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(solution.getRange(at: Distance(yards: 500)).yards.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(solution.getElevation(at: Distance(yards: 0)).inches.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: Distance(yards: 100)).inches.isApproximatelyEqual(to: -0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: Distance(yards: 200)).inches.isApproximatelyEqual(to: -1.81, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: Distance(yards: 300)).inches.isApproximatelyEqual(to: -7.69, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: Distance(yards: 400)).inches.isApproximatelyEqual(to: -18.14, absoluteTolerance: 0.01))
    #expect(solution.getElevation(at: Distance(yards: 500)).inches.isApproximatelyEqual(to: -33.79, absoluteTolerance: 0.01))

    #expect(solution.getWindage(at: Distance(yards: 0)).inches.isApproximatelyEqual(to: 0.04, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: Distance(yards: 100)).inches.isApproximatelyEqual(to: 0.72, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: Distance(yards: 200)).inches.isApproximatelyEqual(to: 2.84, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: Distance(yards: 300)).inches.isApproximatelyEqual(to: 6.49, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: Distance(yards: 400)).inches.isApproximatelyEqual(to: 11.82, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: Distance(yards: 500)).inches.isApproximatelyEqual(to: 18.98, absoluteTolerance: 0.01))

    #expect(solution.getVelocity(at: Distance(yards: 0)).fps.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: Distance(yards: 100)).fps.isApproximatelyEqual(to: 3110, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: Distance(yards: 200)).fps.isApproximatelyEqual(to: 2930, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: Distance(yards: 300)).fps.isApproximatelyEqual(to: 2756, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: Distance(yards: 400)).fps.isApproximatelyEqual(to: 2589, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: Distance(yards: 500)).fps.isApproximatelyEqual(to: 2428, absoluteTolerance: 1))

    #expect(solution.getTime(at: Distance(yards: 0)).isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: Distance(yards: 100)).isApproximatelyEqual(to: 0.09, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: Distance(yards: 200)).isApproximatelyEqual(to: 0.20, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: Distance(yards: 300)).isApproximatelyEqual(to: 0.30, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: Distance(yards: 400)).isApproximatelyEqual(to: 0.41, absoluteTolerance: 0.01))
    #expect(solution.getTime(at: Distance(yards: 500)).isApproximatelyEqual(to: 0.53, absoluteTolerance: 0.01))

    #expect(solution.getElevationCorrection(at: Distance(yards: 100)).moa.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: Distance(yards: 200)).moa.isApproximatelyEqual(to: 0.87, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: Distance(yards: 300)).moa.isApproximatelyEqual(to: 2.45, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: Distance(yards: 400)).moa.isApproximatelyEqual(to: 4.33, absoluteTolerance: 0.01))
    #expect(solution.getElevationCorrection(at: Distance(yards: 500)).moa.isApproximatelyEqual(to: 6.45, absoluteTolerance: 0.01))

    #expect(solution.getWindageCorrection(at: Distance(yards: 100)).moa.isApproximatelyEqual(to: 0.68, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: Distance(yards: 200)).moa.isApproximatelyEqual(to: 1.35, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: Distance(yards: 300)).moa.isApproximatelyEqual(to: 2.07, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: Distance(yards: 400)).moa.isApproximatelyEqual(to: 2.82, absoluteTolerance: 0.01))
    #expect(solution.getWindageCorrection(at: Distance(yards: 500)).moa.isApproximatelyEqual(to: 3.62, absoluteTolerance: 0.01))
}
