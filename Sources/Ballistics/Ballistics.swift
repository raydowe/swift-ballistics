//
//  Ballistics.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

public struct Ballistics {

    var distances: [Point] = []

    init() {}
    /**
     Solves the projectile trajectory based on provided ballistic and environmental parameters.
    
     This method calculates the trajectory of a projectile, considering factors like aerodynamic drag,
     initial velocity, sight height, shooting angle, zeroing angle, and wind conditions.
     It returns key trajectory points, allowing for analysis of the projectile's flight path.
    
     - Parameters:
       - dragCoefficient: The G1 drag coefficient of the projectile, a dimensionless number representing aerodynamic resistance.
       - initialVelocity: The muzzle velocity of the projectile in meters per second (ft/s).
       - sightHeight: The height of the sight above the bore axis in inches (in).
       - shootingAngle: The actual angle of elevation at which the projectile is fired, in degrees.
       - zeroAngle: The angle of elevation required to zero the firearm, in radians.
       - atmosphere: The atmospheric conditions to consider. Optional..
       - windSpeed: The speed of the wind in miles per hour (mph).
       - windAngle: The direction of the wind relative to the projectile's path, in degrees (0° = headwind, 90° = left to right).
    
     - Returns:
       A ballistics object, which contains a set of trajectory points, typically including time, horizontal position, vertical position,
       and deviations caused by environmental factors (e.g., wind drift).
    */
    public static func solve(
        dragCoefficient: Double,
        initialVelocity: Measurement<UnitSpeed>,
        sightHeight: Measurement<UnitLength>,
        shootingAngle: Double,
        zeroRange: Measurement<UnitLength>,
        atmosphere: Atmosphere? = nil,
        windSpeed: Measurement<UnitSpeed>,
        windAngle: Double,
        weight: Measurement<UnitMass> = Measurement<UnitMass>(value: 0, unit: .grains)
    ) -> Ballistics {
        var ballistics = Ballistics()
        let environmentDragCoefficient = atmosphere?.adjustCoefficient(dragCoefficient: dragCoefficient) ?? dragCoefficient
        let initialVelocityFPS = initialVelocity.converted(to: .feetPerSecond).value
        let zeroAngle = Angle.zeroAngle(
            dragCoefficient: environmentDragCoefficient,
            initialVelocity: initialVelocity,
            sightHeight: sightHeight,
            zeroRange: zeroRange,
            yIntercept: 0
        )
        let headwind = headwindSpeed(windSpeed: windSpeed.converted(to: .milesPerHour).value, windAngle: windAngle)
        let crosswind = crosswindSpeed(windSpeed: windSpeed.converted(to: .milesPerHour).value, windAngle: windAngle)
        let gy = Constants.GRAVITY * cos(Math.degToRad(shootingAngle + zeroAngle))
        let gx = Constants.GRAVITY * sin(Math.degToRad(shootingAngle + zeroAngle))

        var vx = initialVelocityFPS * cos(Math.degToRad(zeroAngle))
        var vy = initialVelocityFPS * sin(Math.degToRad(zeroAngle))
        var x: Double = 0
        var y: Double = -sightHeight.converted(to: .inches).value / 12
        var n = 0
        var t: Double = 0

        while true {
            let v = sqrt(vx * vx + vy * vy)
            let dv = Drag.retard(dragCoefficient: environmentDragCoefficient, projectileVelocity: v + headwind)
            let dvx = -(vx / v) * dv
            let dvy = -(vy / v) * dv

            let dt = 0.5 / v
            vx += dt * dvx + dt * gx
            vy += dt * dvy + dt * gy

            if x / 3 >= Double(n) {
                let pathInches = y * 12
                let moaDrop = -Math.radToMOA(atan(y / x))
                let windageInches = windage(windSpeed: crosswind, initialVelocity: initialVelocityFPS, x: x, t: t + dt)
                let moaWindage = Math.radToMOA(atan((windageInches / 12) / x))
                let ftlbs = weight.converted(to: .grains).value * (pow(v, 2)) / (2 * 32.163 * 7000)
                let point = Point(
                    range: Measurement(value: x / 3, unit: .yards),
                    drop: Measurement(value: pathInches, unit: .inches),
                    dropCorrection: Measurement(value: moaDrop, unit: .minutesOfAngle),
                    windage: Measurement(value: windageInches, unit: .inches),
                    windageCorrection: Measurement(value: moaWindage, unit: .minutesOfAngle),
                    seconds: t + dt,
                    velocity: Measurement(value: v, unit: .feetPerSecond),
                    velocityX: Measurement(value: vx, unit: .feetPerSecond),
                    velocityY: Measurement(value: vy, unit: .feetPerSecond),
                    energy: Measurement(value: ftlbs, unit: .footPounds)
                )
                ballistics.distances.append(point)
                n += 1
            }

            x += dt * (vx + vx) / 2
            y += dt * (vy + vy) / 2

            if abs(vy) > abs(3 * vx) || n >= Constants.BALLISTICS_COMPUTATION_MAX_YARDS {
                break
            }

            t += dt
        }

        return ballistics
    }

    public func getPoint(at distance: Measurement<UnitLength>) -> Point? {
        let yards = Int(distance.converted(to: .yards).value.rounded())
        guard yards < distances.count else { return nil }
        return distances[yards]
    }

    private static func headwindSpeed(windSpeed: Double, windAngle: Double) -> Double {
        return windSpeed * cos(Math.degToRad(windAngle))
    }

    private static func crosswindSpeed(windSpeed: Double, windAngle: Double) -> Double {
        return windSpeed * sin(Math.degToRad(windAngle))
    }

    private static func windage(windSpeed: Double, initialVelocity: Double, x: Double, t: Double) -> Double {
        let vw = windSpeed * 17.60 // Convert to inches per second
        return vw * (t - x / initialVelocity)
    }
}
