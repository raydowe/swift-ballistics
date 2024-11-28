import Testing
@testable import Ballistics
import Numerics

@Test func testLibrary() async throws {

    var bc: Double = 0.414 // The ballistic coefficient for the projectile
    let v: Double = 3300 // Initial velocity, in ft/s
    let sh: Double = 1.8 // Sight height over bore, in inches
    let angle: Double = 0 // The shooting angle (uphill/downhill), in degrees
    let zero: Double = 100 // The zero range of the rifle, in yards

    let temperature: Double = 59 // Atmospheric temperature in degrees Fahrenheit
    let humidity: Double = 0.5 // Relative humidity in percentage between 0 and 1
    let barometer: Double = 29.92 // Barometric pressure in inHg
    let altitude: Double = 0 // Altitude above sea level in feet
    let windspeed: Double = 10 // Wind speed in miles per hour
    let windangle: Double = 90 // Wind angle (0=headwind, 90=right to left, etc.)


    // Optional: Correct the ballistic coefficient for weather conditions
    bc = Atmosphere.adjustCoefficient(
        dragCoefficient: bc,
        altitude: altitude,
        barometer: barometer,
        temperature: temperature,
        relativeHumidity: humidity
    )

    // Find the "zero angle"
    let zeroAngle = Angle.zeroAngle(
        dragCoefficient: bc,
        initialVelocity: v,
        sightHeight: sh,
        zeroRange: zero,
        yIntercept: 0
    )

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: bc,
        initialVelocity: v,
        sightHeight: sh,
        shootingAngle: angle,
        zeroAngle: zeroAngle,
        windSpeed: windspeed,
        windAngle: windangle
    )

    #expect(solution.getRange(at: 0).isApproximatelyEqual(to: 0.0000, absoluteTolerance: 0.001))
    #expect(solution.getRange(at: 100).isApproximatelyEqual(to: 100.1537, absoluteTolerance: 0.001))
    #expect(solution.getRange(at: 200).isApproximatelyEqual(to: 200.1406, absoluteTolerance: 0.001))
    #expect(solution.getRange(at: 300).isApproximatelyEqual(to: 300.1269, absoluteTolerance: 0.001))

    #expect(solution.getPath(at: 0).isApproximatelyEqual(to: -1.8000, absoluteTolerance: 0.001))
    #expect(solution.getPath(at: 100).isApproximatelyEqual(to: -0.0013, absoluteTolerance: 0.001))
    #expect(solution.getPath(at: 200).isApproximatelyEqual(to: -1.9432, absoluteTolerance: 0.001))
    #expect(solution.getPath(at: 300).isApproximatelyEqual(to: -8.2580, absoluteTolerance: 0.001))

    #expect(solution.getWindage(at: 0).isApproximatelyEqual(to: 0.0266, absoluteTolerance: 0.001))
    #expect(solution.getWindage(at: 100).isApproximatelyEqual(to: 0.6632, absoluteTolerance: 0.001))
    #expect(solution.getWindage(at: 200).isApproximatelyEqual(to: 2.6476, absoluteTolerance: 0.001))
    #expect(solution.getWindage(at: 300).isApproximatelyEqual(to: 6.1267, absoluteTolerance: 0.001))

    #expect(solution.getVelocity(at: 0).isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 100).isApproximatelyEqual(to: 3054, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 200).isApproximatelyEqual(to: 2823, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 300).isApproximatelyEqual(to: 2603, absoluteTolerance: 1))

    #expect(solution.getTime(at: 0).isApproximatelyEqual(to: 0, absoluteTolerance: 0.001))
    #expect(solution.getTime(at: 100).isApproximatelyEqual(to: 0.094, absoluteTolerance: 0.001))
    #expect(solution.getTime(at: 200).isApproximatelyEqual(to: 0.196, absoluteTolerance: 0.001))
    #expect(solution.getTime(at: 300).isApproximatelyEqual(to: 0.307, absoluteTolerance: 0.001))

    #expect(solution.getMOA(at: 100).isApproximatelyEqual(to: 0.0012, absoluteTolerance: 0.001))
    #expect(solution.getMOA(at: 200).isApproximatelyEqual(to: 0.9271, absoluteTolerance: 0.001))
    #expect(solution.getMOA(at: 300).isApproximatelyEqual(to: 2.6275, absoluteTolerance: 0.001))

    #expect(solution.getWindageMOA(at: 100).isApproximatelyEqual(to: 0.6323, absoluteTolerance: 0.001))
    #expect(solution.getWindageMOA(at: 200).isApproximatelyEqual(to: 1.263, absoluteTolerance: 0.001))
    #expect(solution.getWindageMOA(at: 300).isApproximatelyEqual(to: 1.950, absoluteTolerance: 0.001))
}
