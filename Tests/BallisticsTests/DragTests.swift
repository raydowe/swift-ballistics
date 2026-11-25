//
//  DragTests.swift
//  swift-ballistics
//

import Foundation
import Testing
@testable import Ballistics
import Numerics

// Drag coefficients between table points, computed independently with py-ballisticcalc 2.2.2's
// monotone cubic (PCHIP) interpolation of the same standard tables.
private let g1Interpolated: [(mach: Double, cd: Double)] = [
    (0.33, 0.2177751865), (0.68, 0.2128877718), (0.88, 0.3188145751), (0.97, 0.4375423957),
    (1.01, 0.4941244728), (1.12, 0.6021781630), (1.37, 0.6623432000), (1.83, 0.6168552345),
    (2.45, 0.5438000000), (3.3, 0.5067000000), (4.1, 0.5001545455),
]

private let g7Interpolated: [(mach: Double, cd: Double)] = [
    (0.33, 0.1194000000), (0.68, 0.1199603077), (0.88, 0.1383503692), (0.97, 0.2801779742),
    (1.01, 0.3921265963), (1.12, 0.3992821562), (1.37, 0.3626031342), (1.83, 0.3093192726),
    (2.45, 0.2725000000), (3.3, 0.2258000000), (4.1, 0.1897206981),
]

private func table(_ model: DragModel) -> [(mach: Double, cd: Double)] {
    model == .g1 ? Drag.Tables.g1 : Drag.Tables.g7
}

// MARK: - Drag coefficient curve

@Test(arguments: DragModel.allCases)
func curvePassesThroughEveryTablePoint(model: DragModel) {
    for point in table(model) {
        #expect(Drag.coefficient(model, mach: point.mach).isApproximatelyEqual(to: point.cd, absoluteTolerance: 1e-12), "Mach \(point.mach)")
    }
}

@Test(arguments: g1Interpolated)
func g1InterpolationMatchesReference(mach: Double, cd: Double) {
    #expect(Drag.coefficient(.g1, mach: mach).isApproximatelyEqual(to: cd, absoluteTolerance: 1e-9))
}

@Test(arguments: g7Interpolated)
func g7InterpolationMatchesReference(mach: Double, cd: Double) {
    #expect(Drag.coefficient(.g7, mach: mach).isApproximatelyEqual(to: cd, absoluteTolerance: 1e-9))
}

@Test(arguments: DragModel.allCases)
func curveNeverOvershootsBetweenTablePoints(model: DragModel) {
    // Monotone interpolation stays within the range of each pair of neighbouring points.
    let points = table(model)
    for (a, b) in zip(points, points.dropFirst()) {
        for i in 1..<10 {
            let mach = a.mach + (b.mach - a.mach) * Double(i) / 10
            let cd = Drag.coefficient(model, mach: mach)
            #expect(cd >= min(a.cd, b.cd) - 1e-12 && cd <= max(a.cd, b.cd) + 1e-12, "Mach \(mach)")
        }
    }
}

@Test(arguments: DragModel.allCases)
func curveIsContinuous(model: DragModel) {
    // No jumps anywhere: a tiny change in Mach gives a tiny change in drag.
    for mach in stride(from: 0.0, through: 5.0, by: 0.001) {
        let jump = abs(Drag.coefficient(model, mach: mach + 1e-7) - Drag.coefficient(model, mach: mach))
        #expect(jump < 1e-5, "Mach \(mach)")
    }
}

@Test(arguments: DragModel.allCases)
func curveIsHeldBeyondTable(model: DragModel) {
    let last = table(model).last!
    #expect(Drag.coefficient(model, mach: 6) == last.cd)
    #expect(Drag.coefficient(model, mach: -1) == table(model).first!.cd)
}

@Test func g7HasLessDragThanG1AtEveryMach() {
    for mach in stride(from: 0.0, through: 5.0, by: 0.01) {
        #expect(Drag.coefficient(.g7, mach: mach) < Drag.coefficient(.g1, mach: mach), "Mach \(mach)")
    }
}

// MARK: - Deceleration

@Test(arguments: DragModel.allCases)
func retardationMatchesStandardFormula(model: DragModel) {
    // py-ballisticcalc's form: v² · (ρ / 0.076474) · Cd · 2.08551e-4 / BC.
    let density = 0.0712, speedOfSound = 1090.0, bc = 0.35
    for v in [400.0, 1000, 1100, 1500, 2800, 4000] {
        let cd = Drag.coefficient(model, mach: v / speedOfSound)
        let expected = v * v * (density / 0.076474) * cd * 2.08551e-4 / bc
        let value = Drag.retard(dragModel: model, dragCoefficient: bc, projectileVelocity: v, airDensity: density, speedOfSound: speedOfSound)
        #expect(value.isApproximatelyEqual(to: expected, relativeTolerance: 1e-5))
    }
}

@Test(arguments: DragModel.allCases)
func retardationScalesWithDensityAndCoefficient(model: DragModel) {
    for v in [500.0, 1100, 1500, 2800, 4000] {
        let base = Drag.retard(dragModel: model, dragCoefficient: 0.4, projectileVelocity: v)
        let thinAir = Drag.retard(dragModel: model, dragCoefficient: 0.4, projectileVelocity: v, airDensity: Atmosphere.referenceDensity / 2)
        let doubleBC = Drag.retard(dragModel: model, dragCoefficient: 0.8, projectileVelocity: v)
        #expect(thinAir.isApproximatelyEqual(to: base / 2, relativeTolerance: 1e-12))
        #expect(doubleBC.isApproximatelyEqual(to: base / 2, relativeTolerance: 1e-12))
    }
}

@Test(arguments: DragModel.allCases)
func retardationDependsOnMachNotSpeed(model: DragModel) {
    // In colder air (slower sound) the same Mach number is reached at a lower speed.
    let cold = 1050.0
    for mach in [0.8, 1.0, 1.2, 2.5] {
        let standard = Drag.retard(dragModel: model, dragCoefficient: 0.4, projectileVelocity: mach * Drag.standardSpeedOfSound)
        let chilled = Drag.retard(dragModel: model, dragCoefficient: 0.4, projectileVelocity: mach * cold, speedOfSound: cold)
        let ratio = pow(cold / Drag.standardSpeedOfSound, 2)
        #expect(chilled.isApproximatelyEqual(to: standard * ratio, relativeTolerance: 1e-12))
    }
}

@Test(arguments: DragModel.allCases)
func retardationIsZeroWithoutAirspeed(model: DragModel) {
    #expect(Drag.retard(dragModel: model, dragCoefficient: 0.4, projectileVelocity: 0) == 0)
    #expect(Drag.retard(dragModel: model, dragCoefficient: 0.4, projectileVelocity: -10) == 0)
}

@Test func defaultDragModelIsG1() {
    for v in stride(from: 50.0, through: 4500, by: 50) {
        #expect(Drag.retard(dragCoefficient: 0.5, projectileVelocity: v) == Drag.retard(dragModel: .g1, dragCoefficient: 0.5, projectileVelocity: v))
    }
}

// MARK: - Atmosphere

@Test func atmosphereDensityMatchesIdealGas() {
    // Reference densities from py-ballisticcalc (same conditions, station pressure).
    let cases: [(Atmosphere, Double)] = [
        (Atmosphere(altitude: Measurement(value: 0, unit: .feet), pressure: Measurement(value: 29.92, unit: .inchesOfMercury),
                    temperature: Measurement(value: 59, unit: .fahrenheit), relativeHumidity: 0), 0.076503),
        (Atmosphere(altitude: Measurement(value: 10_000, unit: .feet), pressure: Measurement(value: 30.1, unit: .inchesOfMercury),
                    temperature: Measurement(value: 5, unit: .fahrenheit), relativeHumidity: 0.9), 0.059034),
        (Atmosphere(altitude: Measurement(value: 5_000, unit: .feet), pressure: Measurement(value: 29.92, unit: .inchesOfMercury),
                    temperature: Measurement(value: 80, unit: .fahrenheit), relativeHumidity: 0.5), 0.060689),
    ]
    for (atmosphere, expected) in cases {
        #expect(atmosphere.density.isApproximatelyEqual(to: expected, relativeTolerance: 0.001))
    }
}

@Test func standardAtmosphereSpeedOfSound() {
    let standard = Atmosphere(temperature: Measurement(value: 59, unit: .fahrenheit))
    #expect(standard.speedOfSound.isApproximatelyEqual(to: 1116.45, absoluteTolerance: 0.01))
    let cold = Atmosphere(temperature: Measurement(value: 5, unit: .fahrenheit))
    #expect(cold.speedOfSound.isApproximatelyEqual(to: 1056.7, absoluteTolerance: 0.1))
}

@Test func adjustedCoefficientIsUnchangedInReferenceAir() {
    let armyStandardMetro = Atmosphere(
        altitude: Measurement(value: 0, unit: .feet),
        pressure: Measurement(value: 29.53, unit: .inchesOfMercury),
        temperature: Measurement(value: 59, unit: .fahrenheit),
        relativeHumidity: 0.78
    )
    #expect(armyStandardMetro.adjustCoefficient(dragCoefficient: 0.5).isApproximatelyEqual(to: 0.5, relativeTolerance: 1e-12))
}
