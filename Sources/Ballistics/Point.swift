//
//  Point.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

public struct Point: Equatable, Hashable {
    // All internal values are in SI units (meters, m/s, etc.)
    public let range: Double
    public let drop: Double
    public let windage: Double
    public let seconds: Double
    public let velocity: Double
    public let velocityX: Double
    public let velocityY: Double
    public let energy: Double
    public let dropCorrectionClicks: Int?
    public let windageCorrectionClicks: Int?

    // Public getters to return Measurement values for convenience
    public var rangeMeasurement: Measurement<UnitLength> { Measurement(value: range, unit: .meters) }
    public var dropMeasurement: Measurement<UnitLength> { Measurement(value: drop, unit: .meters) }
    public var windageMeasurement: Measurement<UnitLength> { Measurement(value: windage, unit: .meters) }
    public var velocityMeasurement: Measurement<UnitSpeed> { Measurement(value: velocity, unit: .metersPerSecond) }
    public var energyMeasurement: Measurement<UnitEnergy> { Measurement(value: energy, unit: .joules) }

    public var dropCorrection: Measurement<UnitAngle> {
        guard range > 0 else { return Measurement(value: 0, unit: .minutesOfAngle) }
        let moa = -Math.radToMOA(atan(drop / range))
        return Measurement(value: moa, unit: .minutesOfAngle)
    }

    public var windageCorrection: Measurement<UnitAngle> {
        guard range > 0 else { return Measurement(value: 0, unit: .minutesOfAngle) }
        let moa = Math.radToMOA(atan(windage / range))
        return Measurement(value: moa, unit: .minutesOfAngle)
    }

    internal init(
        range: Double,
        drop: Double,
        windage: Double,
        seconds: Double,
        velocity: Double,
        velocityX: Double,
        velocityY: Double,
        energy: Double,
        dropCorrectionClicks: Int? = nil,
        windageCorrectionClicks: Int? = nil
    ) {
        self.range = range
        self.drop = drop
        self.windage = windage
        self.seconds = seconds
        self.velocity = velocity
        self.velocityX = velocityX
        self.velocityY = velocityY
        self.energy = energy
        self.dropCorrectionClicks = dropCorrectionClicks
        self.windageCorrectionClicks = windageCorrectionClicks
    }
}
