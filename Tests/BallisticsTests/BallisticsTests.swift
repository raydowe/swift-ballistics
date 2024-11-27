import Testing
@testable import Ballistics

@Test func testLibrary() async throws {

    var bc: Double = 0.414 // The ballistic coefficient for the projectile
    let dragFunction = Drag.DragFunction.G1
    let v: Double = 3300 // Initial velocity, in ft/s
    let sh: Double = 1.8 // Sight height over bore, in inches
    let angle: Double = 0 // The shooting angle (uphill/downhill), in degrees
    let zero: Double = 100 // The zero range of the rifle, in yards
    let windspeed: Double = 0 // Wind speed in miles per hour
    let windangle: Double = 0 // Wind angle (0=headwind, 90=right to left, etc.)

    // Optional: Correct the ballistic coefficient for weather conditions
    bc = Atmosphere.atmosphereCorrection(dragCoefficient: bc, altitude: 0, barometer: 29.92, temperature: 138, relativeHumidity: 0.0)

    // Find the "zero angle"
    let zeroAngle = Angle.zeroAngle(
        dragFunction: dragFunction,
        dragCoefficient: bc,
        initialVelocity: v,
        sightHeight: sh,
        zeroRange: zero,
        yIntercept: 0
    )

    // Generate a full ballistic solution
    let ballistics = Ballistics.solveBallistics(
        dragFunction: dragFunction,
        dragCoefficient: bc,
        initialVelocity: v,
        sightHeight: sh,
        shootingAngle: angle,
        zeroAngle: zeroAngle,
        windSpeed: windspeed,
        windAngle: windangle
    )

    // Print the trajectory chart
    for index in stride(from: 0, through: 600, by: 25) {
        let x = ballistics.getRange(at: index)
        let y = ballistics.getPath(at: index)
        let v = ballistics.getVelocity(at: index)
        print("RANGE: \(x.rounded())     DROP: \(String(format: "%.1f", y))     SPEED: \(String(format: "%.0f", v.rounded()))")
    }

    #expect(true)
}
