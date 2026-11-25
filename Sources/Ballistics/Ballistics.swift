//
//  Ballistics.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

public struct Ballistics {

    // Stores sampled points along the trajectory at fixed distance steps in the preferred unit.
    var distances: [Point] = []

    // Sampling configuration captured so getPoint(at:) can map requests to indices correctly.
    private let preferredDistanceUnit: UnitLength
    private let distanceStep: Measurement<UnitLength>

    init(
        preferredDistanceUnit: UnitLength = .yards,
        distanceStep: Measurement<UnitLength> = Measurement(value: 1, unit: .yards)
    ) {
        self.preferredDistanceUnit = preferredDistanceUnit
        self.distanceStep = distanceStep.converted(to: preferredDistanceUnit)
    }

    /**
     Solves the projectile trajectory based on provided ballistic and environmental parameters.

     This method calculates the trajectory of a projectile, considering factors like aerodynamic drag,
     initial velocity, sight height, shooting angle, zeroing angle, and wind conditions.
     It returns key trajectory points, allowing for analysis of the projectile's flight path.

     - Parameters:
       - preferredDistanceUnit: The preferred distance unit, used for sampling
       - dragCoefficient: The ballistic coefficient of the projectile, expressed against `dragModel`.
       - dragModel: The reference drag model the coefficient was measured against (`.g1` or `.g7`). Default is `.g1`.
       - initialVelocity: The muzzle velocity of the projectile in meters per second (ft/s).
       - sightHeight: The height of the sight above the bore axis in inches (in).
       - shootingAngle: The actual angle of elevation at which the projectile is fired, in degrees. Positive is up, negative is down.
       - zeroRange: The distance the projectile is zeroed at.
       - atmosphere: The atmospheric conditions to consider. Optional.
       - windSpeed: The speed of the wind.
       - windAngle: The direction of the wind relative to the projectile's path, in degrees (0° = headwind, 90° = left to right).
       - weight: The projectile weight.
       - preferredDistanceUnit: The unit in which you want sampling to occur (e.g., .yards or .meters). Default is .yards.
       - distanceStep: The sampling step. Default is 1 of `preferredDistanceUnit` (1 yd, or 1 m when sampling in meters).

     - Returns:
       A ballistics object, which contains a set of trajectory points sampled at fixed distance steps
       in the preferred unit.
    */
    public static func solve(
        preferredDistanceUnit: UnitLength = .yards,
        dragCoefficient: Double,
        dragModel: DragModel = .g1,
        initialVelocity: Measurement<UnitSpeed>,
        sightHeight: Measurement<UnitLength>,
        shootingAngle: Measurement<UnitAngle>,
        zeroRange: Measurement<UnitLength>,
        atmosphere: Atmosphere? = nil,
        windSpeed: Measurement<UnitSpeed>,
        windAngle: Double,
        weight: Measurement<UnitMass> = Measurement<UnitMass>(value: 0, unit: .grains),
        distanceStep: Measurement<UnitLength>? = nil
    ) -> Ballistics {

        let distanceStep = distanceStep ?? Measurement(value: 1, unit: preferredDistanceUnit)
        var ballistics = Ballistics(
            preferredDistanceUnit: preferredDistanceUnit,
            distanceStep: distanceStep
        )

        // Normalize step to feet for threshold checks; keep a clean preferred-unit step for labeling.
        let stepInPreferred = distanceStep.converted(to: preferredDistanceUnit)
        let stepFeet = stepInPreferred.converted(to: .feet).value

        let maxFeet = Double(Constants.BALLISTICS_COMPUTATION_MAX_YARDS) * 3.0

        let airDensity = atmosphere?.density ?? Atmosphere.referenceDensity
        let speedOfSound = atmosphere?.speedOfSound ?? Drag.standardSpeedOfSound
        let initialVelocityFPS = initialVelocity.converted(to: .feetPerSecond).value
        let zeroAngle = Angle.zeroAngle(
            dragModel: dragModel,
            dragCoefficient: dragCoefficient,
            airDensity: airDensity,
            speedOfSound: speedOfSound,
            initialVelocity: initialVelocity,
            sightHeight: sightHeight,
            zeroRange: zeroRange,
            yIntercept: 0
        )
        let headwind = headwindSpeed(windSpeed: windSpeed.converted(to: .feetPerSecond).value, windAngle: windAngle)
        let crosswind = crosswindSpeed(windSpeed: windSpeed.converted(to: .feetPerSecond).value, windAngle: windAngle)

        let trajectory = Trajectory(
            dragModel: dragModel,
            dragCoefficient: dragCoefficient,
            airDensity: airDensity,
            speedOfSound: speedOfSound,
            headwindFPS: headwind,
            crosswindFPS: crosswind,
            shootingAngleDegrees: shootingAngle.converted(to: .degrees).value
        )
        var state = Trajectory.State(
            y: -sightHeight.converted(to: .feet).value,
            vx: initialVelocityFPS * cos(Math.degToRad(zeroAngle)),
            vy: initialVelocityFPS * sin(Math.degToRad(zeroAngle))
        )
        var sampleIndex = 0

        func emitPoint(_ s: Trajectory.State) {
            let xFeet = s.x
            let yFeet = s.y
            let currentV = s.speed
            let pathInches = yFeet * 12
            let moaDrop = xFeet > 0 ? -Math.radToMOA(atan(yFeet / xFeet)) : 0
            let windageInches = s.z * 12
            let moaWindage = xFeet > 0 ? Math.radToMOA(atan(s.z / xFeet)) : 0
            let ftlbs = weight.converted(to: .grains).value * (pow(currentV, 2)) / (2 * -Constants.GRAVITY * 7000)

            // Range labeling in preferred unit aligned to exact sample index
            let rangeValue = Double(sampleIndex) * stepInPreferred.value
            let point = Point(
                range: Measurement(value: rangeValue, unit: ballistics.preferredDistanceUnit),
                drop: Measurement(value: pathInches, unit: .inches),
                dropCorrection: Measurement(value: moaDrop, unit: .minutesOfAngle),
                windage: Measurement(value: windageInches, unit: .inches),
                windageCorrection: Measurement(value: moaWindage, unit: .minutesOfAngle),
                travelTime: Measurement(value: s.t, unit: .seconds),
                velocity: Measurement(value: currentV, unit: .feetPerSecond),
                velocityX: Measurement(value: s.vx, unit: .feetPerSecond),
                velocityY: Measurement(value: s.vy, unit: .feetPerSecond),
                energy: Measurement(value: ftlbs, unit: .footPounds)
            )
            ballistics.distances.append(point)
        }

        // Land exactly on every sample distance, starting at the muzzle.
        emitPoint(state)
        while true {
            sampleIndex += 1
            let target = Double(sampleIndex) * stepFeet
            guard target <= maxFeet, let next = trajectory.advance(state, to: target) else { break }
            state = next
            emitPoint(state)
        }

        return ballistics
    }

    /**
     Returns the trajectory point at the given distance.

     Points are calculated exactly at each multiple of `distanceStep`, in `preferredDistanceUnit`.
     The requested distance may be in any unit, but it must land on that grid; otherwise `nil`
     is returned rather than a point at a nearby distance. To query metric distances, solve with
     a metric `preferredDistanceUnit`.

     - Parameter distance: The distance to look up.
     - Returns: The point at exactly that distance, or `nil` if it is off the sampling grid or out of range.
     */
    public func getPoint(at distance: Measurement<UnitLength>) -> Point? {
        let stepValue = distanceStep.value
        guard stepValue > 0 else { return nil }

        let steps = distance.converted(to: preferredDistanceUnit).value / stepValue
        let index = steps.rounded()
        // Allow only for floating-point noise from unit conversion, never a different distance.
        guard abs(steps - index) <= 1e-9 * max(1, abs(steps)) else { return nil }
        guard index >= 0, index < Double(distances.count) else { return nil }
        return distances[Int(index)]
    }

    private static func headwindSpeed(windSpeed: Double, windAngle: Double) -> Double {
        return windSpeed * cos(Math.degToRad(windAngle))
    }

    private static func crosswindSpeed(windSpeed: Double, windAngle: Double) -> Double {
        return windSpeed * sin(Math.degToRad(windAngle))
    }
}
