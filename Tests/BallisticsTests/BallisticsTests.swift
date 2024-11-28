import Testing
@testable import Ballistics
import Numerics

@Test func testLibrary() async throws {

    var bc: Double = 0.414 // The ballistic coefficient for the projectile
    let v: Double = 3300 // Initial velocity, in ft/s
    let sh: Double = 1.8 // Sight height over bore, in inches
    let angle: Double = 0 // The shooting angle (uphill/downhill), in degrees
    let zero: Double = 100 // The zero range of the rifle, in yards
    let windspeed: Double = 10 // Wind speed in miles per hour
    let windangle: Double = 90 // Wind angle (0=headwind, 90=right to left, etc.)

    // Optional: Correct the ballistic coefficient for weather conditions
    bc = Atmosphere.adjustCoefficient(
        dragCoefficient: bc,
        altitude: 0,
        barometer: 29.92,
        temperature: 59,
        relativeHumidity: 0.5
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

    #expect(solution.getRange(at: 0).isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(solution.getRange(at: 100).isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(solution.getRange(at: 200).isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(solution.getRange(at: 300).isApproximatelyEqual(to: 300, absoluteTolerance: 1))

    #expect(solution.getPath(at: 0).isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(solution.getPath(at: 100).isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getPath(at: 200).isApproximatelyEqual(to: -1.94, absoluteTolerance: 0.01))
    #expect(solution.getPath(at: 300).isApproximatelyEqual(to: -8.25, absoluteTolerance: 0.01))

    #expect(solution.getWindage(at: 0).isApproximatelyEqual(to: 0.02, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 100).isApproximatelyEqual(to: 0.66, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 200).isApproximatelyEqual(to: 2.64, absoluteTolerance: 0.01))
    #expect(solution.getWindage(at: 300).isApproximatelyEqual(to: 6.12, absoluteTolerance: 0.01))

    #expect(solution.getVelocity(at: 0).isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 100).isApproximatelyEqual(to: 3054, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 200).isApproximatelyEqual(to: 2823, absoluteTolerance: 1))
    #expect(solution.getVelocity(at: 300).isApproximatelyEqual(to: 2603, absoluteTolerance: 1))

    #expect(solution.getTime(at: 0).isApproximatelyEqual(to: 0, absoluteTolerance: 0.001))
    #expect(solution.getTime(at: 100).isApproximatelyEqual(to: 0.094, absoluteTolerance: 0.001))
    #expect(solution.getTime(at: 200).isApproximatelyEqual(to: 0.196, absoluteTolerance: 0.001))
    #expect(solution.getTime(at: 300).isApproximatelyEqual(to: 0.307, absoluteTolerance: 0.001))

    #expect(solution.getMOA(at: 100).isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(solution.getMOA(at: 200).isApproximatelyEqual(to: 0.93, absoluteTolerance: 0.01))
    #expect(solution.getMOA(at: 300).isApproximatelyEqual(to: 2.62, absoluteTolerance: 0.01))

    #expect(solution.getWindageMOA(at: 100).isApproximatelyEqual(to: 0.63, absoluteTolerance: 0.01))
    #expect(solution.getWindageMOA(at: 200).isApproximatelyEqual(to: 1.26, absoluteTolerance: 0.01))
    #expect(solution.getWindageMOA(at: 300).isApproximatelyEqual(to: 1.95, absoluteTolerance: 0.01))
}
