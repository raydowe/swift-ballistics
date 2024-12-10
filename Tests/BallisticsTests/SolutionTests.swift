import Testing
@testable import Ballistics
import Numerics

@Test func testSolutionSimple() async throws {

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: 0.414,
        initialVelocity: ProjectileSpeed(fps: 3300),
        sightHeight: Measurement(inches: 1.8),
        shootingAngle: 0,
        zeroRange: Distance(yards: 100),
        windSpeed: WindSpeed(mph: 0),
        windAngle: 0,
        weight: Weight(grains: 120)
    )

    guard let point0 = solution.getPoint(at: Distance(yards: 0)),
            let point1 = solution.getPoint(at: Distance(yards: 100)),
            let point2 = solution.getPoint(at: Distance(yards: 200)),
            let point3 = solution.getPoint(at: Distance(yards: 300)),
            let point4 = solution.getPoint(at: Distance(yards: 400)),
            let point5 = solution.getPoint(at: Distance(yards: 500)) else {
        Issue.record("Not all points were found")
        return
    }

    #expect(point0.range.yards.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(point1.range.yards.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(point2.range.yards.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(point3.range.yards.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(point4.range.yards.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(point5.range.yards.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(point0.drop.inches.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(point1.drop.inches.isApproximatelyEqual(to: -0.00, absoluteTolerance: 0.01))
    #expect(point2.drop.inches.isApproximatelyEqual(to: -1.94, absoluteTolerance: 0.01))
    #expect(point3.drop.inches.isApproximatelyEqual(to: -8.25, absoluteTolerance: 0.01))
    #expect(point4.drop.inches.isApproximatelyEqual(to: -19.70, absoluteTolerance: 0.01))
    #expect(point5.drop.inches.isApproximatelyEqual(to: -37.23, absoluteTolerance: 0.01))

    #expect(point0.windage.inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point1.windage.inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point2.windage.inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point3.windage.inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point4.windage.inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point5.windage.inches.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))

    #expect(point0.velocity.fps.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(point1.velocity.fps.isApproximatelyEqual(to: 3055, absoluteTolerance: 1))
    #expect(point2.velocity.fps.isApproximatelyEqual(to: 2824, absoluteTolerance: 1))
    #expect(point3.velocity.fps.isApproximatelyEqual(to: 2605, absoluteTolerance: 1))
    #expect(point4.velocity.fps.isApproximatelyEqual(to: 2395, absoluteTolerance: 1))
    #expect(point5.velocity.fps.isApproximatelyEqual(to: 2196, absoluteTolerance: 1))

    #expect(point0.energy.ftlbs.isApproximatelyEqual(to: 2902, absoluteTolerance: 1))
    #expect(point1.energy.ftlbs.isApproximatelyEqual(to: 2487, absoluteTolerance: 1))
    #expect(point2.energy.ftlbs.isApproximatelyEqual(to: 2125, absoluteTolerance: 1))
    #expect(point3.energy.ftlbs.isApproximatelyEqual(to: 1808, absoluteTolerance: 1))
    #expect(point4.energy.ftlbs.isApproximatelyEqual(to: 1529, absoluteTolerance: 1))
    #expect(point5.energy.ftlbs.isApproximatelyEqual(to: 1285, absoluteTolerance: 1))

    #expect(point0.seconds.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point1.seconds.isApproximatelyEqual(to: 0.09, absoluteTolerance: 0.01))
    #expect(point2.seconds.isApproximatelyEqual(to: 0.20, absoluteTolerance: 0.01))
    #expect(point3.seconds.isApproximatelyEqual(to: 0.31, absoluteTolerance: 0.01))
    #expect(point4.seconds.isApproximatelyEqual(to: 0.43, absoluteTolerance: 0.01))
    #expect(point5.seconds.isApproximatelyEqual(to: 0.56, absoluteTolerance: 0.01))

    #expect(point1.dropCorrection.moa.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point2.dropCorrection.moa.isApproximatelyEqual(to: 0.92, absoluteTolerance: 0.01))
    #expect(point3.dropCorrection.moa.isApproximatelyEqual(to: 2.62, absoluteTolerance: 0.01))
    #expect(point4.dropCorrection.moa.isApproximatelyEqual(to: 4.70, absoluteTolerance: 0.01))
    #expect(point5.dropCorrection.moa.isApproximatelyEqual(to: 7.11, absoluteTolerance: 0.01))

    #expect(point1.windageCorrection.moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point2.windageCorrection.moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point3.windageCorrection.moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point4.windageCorrection.moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point5.windageCorrection.moa.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
}

@Test func testSolutionWithAtmosphere() async throws {

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: 0.414,
        initialVelocity: ProjectileSpeed(fps: 3300),
        sightHeight: Measurement(inches: 1.8),
        shootingAngle: 0,
        zeroRange: Distance(yards: 100),
        atmosphere: Atmosphere(
            altitude: Altitude(feet: 10_000),
            pressure: Pressure(inHg: 30.1),
            temperature: Temperature(fahrenheit: 5),
            relativeHumidity: 0.9
        ),
        windSpeed: WindSpeed(mph: 20),
        windAngle: 135,
        weight: Weight(grains: 120)
    )

    guard let point0 = solution.getPoint(at: Distance(yards: 0)),
            let point1 = solution.getPoint(at: Distance(yards: 100)),
            let point2 = solution.getPoint(at: Distance(yards: 200)),
            let point3 = solution.getPoint(at: Distance(yards: 300)),
            let point4 = solution.getPoint(at: Distance(yards: 400)),
            let point5 = solution.getPoint(at: Distance(yards: 500)) else {
        Issue.record("Not all points were found")
        return
    }

    #expect(point0.range.yards.isApproximatelyEqual(to: 0, absoluteTolerance: 1))
    #expect(point1.range.yards.isApproximatelyEqual(to: 100, absoluteTolerance: 1))
    #expect(point2.range.yards.isApproximatelyEqual(to: 200, absoluteTolerance: 1))
    #expect(point3.range.yards.isApproximatelyEqual(to: 300, absoluteTolerance: 1))
    #expect(point4.range.yards.isApproximatelyEqual(to: 400, absoluteTolerance: 1))
    #expect(point5.range.yards.isApproximatelyEqual(to: 500, absoluteTolerance: 1))

    #expect(point0.drop.inches.isApproximatelyEqual(to: -1.80, absoluteTolerance: 0.01))
    #expect(point1.drop.inches.isApproximatelyEqual(to: -0.00, absoluteTolerance: 0.01))
    #expect(point2.drop.inches.isApproximatelyEqual(to: -1.81, absoluteTolerance: 0.01))
    #expect(point3.drop.inches.isApproximatelyEqual(to: -7.69, absoluteTolerance: 0.01))
    #expect(point4.drop.inches.isApproximatelyEqual(to: -18.14, absoluteTolerance: 0.01))
    #expect(point5.drop.inches.isApproximatelyEqual(to: -33.79, absoluteTolerance: 0.01))

    #expect(point0.windage.inches.isApproximatelyEqual(to: 0.04, absoluteTolerance: 0.01))
    #expect(point1.windage.inches.isApproximatelyEqual(to: 0.72, absoluteTolerance: 0.01))
    #expect(point2.windage.inches.isApproximatelyEqual(to: 2.84, absoluteTolerance: 0.01))
    #expect(point3.windage.inches.isApproximatelyEqual(to: 6.49, absoluteTolerance: 0.01))
    #expect(point4.windage.inches.isApproximatelyEqual(to: 11.82, absoluteTolerance: 0.01))
    #expect(point5.windage.inches.isApproximatelyEqual(to: 18.98, absoluteTolerance: 0.01))

    #expect(point0.velocity.fps.isApproximatelyEqual(to: 3300, absoluteTolerance: 1))
    #expect(point1.velocity.fps.isApproximatelyEqual(to: 3110, absoluteTolerance: 1))
    #expect(point2.velocity.fps.isApproximatelyEqual(to: 2930, absoluteTolerance: 1))
    #expect(point3.velocity.fps.isApproximatelyEqual(to: 2756, absoluteTolerance: 1))
    #expect(point4.velocity.fps.isApproximatelyEqual(to: 2589, absoluteTolerance: 1))
    #expect(point5.velocity.fps.isApproximatelyEqual(to: 2428, absoluteTolerance: 1))

    #expect(point0.energy.ftlbs.isApproximatelyEqual(to: 2902, absoluteTolerance: 1))
    #expect(point1.energy.ftlbs.isApproximatelyEqual(to: 2578, absoluteTolerance: 1))
    #expect(point2.energy.ftlbs.isApproximatelyEqual(to: 2287, absoluteTolerance: 1))
    #expect(point3.energy.ftlbs.isApproximatelyEqual(to: 2024, absoluteTolerance: 1))
    #expect(point4.energy.ftlbs.isApproximatelyEqual(to: 1787, absoluteTolerance: 1))
    #expect(point5.energy.ftlbs.isApproximatelyEqual(to: 1571, absoluteTolerance: 1))

    #expect(point0.seconds.isApproximatelyEqual(to: 0, absoluteTolerance: 0.01))
    #expect(point1.seconds.isApproximatelyEqual(to: 0.09, absoluteTolerance: 0.01))
    #expect(point2.seconds.isApproximatelyEqual(to: 0.20, absoluteTolerance: 0.01))
    #expect(point3.seconds.isApproximatelyEqual(to: 0.30, absoluteTolerance: 0.01))
    #expect(point4.seconds.isApproximatelyEqual(to: 0.41, absoluteTolerance: 0.01))
    #expect(point5.seconds.isApproximatelyEqual(to: 0.53, absoluteTolerance: 0.01))

    #expect(point1.dropCorrection.moa.isApproximatelyEqual(to: 0.00, absoluteTolerance: 0.01))
    #expect(point2.dropCorrection.moa.isApproximatelyEqual(to: 0.87, absoluteTolerance: 0.01))
    #expect(point3.dropCorrection.moa.isApproximatelyEqual(to: 2.45, absoluteTolerance: 0.01))
    #expect(point4.dropCorrection.moa.isApproximatelyEqual(to: 4.33, absoluteTolerance: 0.01))
    #expect(point5.dropCorrection.moa.isApproximatelyEqual(to: 6.45, absoluteTolerance: 0.01))

    #expect(point1.windageCorrection.moa.isApproximatelyEqual(to: 0.68, absoluteTolerance: 0.01))
    #expect(point2.windageCorrection.moa.isApproximatelyEqual(to: 1.35, absoluteTolerance: 0.01))
    #expect(point3.windageCorrection.moa.isApproximatelyEqual(to: 2.07, absoluteTolerance: 0.01))
    #expect(point4.windageCorrection.moa.isApproximatelyEqual(to: 2.82, absoluteTolerance: 0.01))
    #expect(point5.windageCorrection.moa.isApproximatelyEqual(to: 3.62, absoluteTolerance: 0.01))
}
