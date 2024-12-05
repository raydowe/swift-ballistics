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
       - windSpeed: The speed of the wind in miles per hour (mph).
       - windAngle: The direction of the wind relative to the projectile's path, in degrees (0° = tailwind, 90° = crosswind).
    
     - Returns:
       A ballistics object, which contains a set of trajectory points, typically including time, horizontal position, vertical position,
       and deviations caused by environmental factors (e.g., wind drift).
    */
    public static func solve(
        dragCoefficient: Double,
        initialVelocity: ProjectileSpeed,
        sightHeight: Measurement,
        shootingAngle: Double,
        zeroRange: Distance,
        windSpeed: WindSpeed,
        windAngle: Double
    ) -> Ballistics {
        var ballistics = Ballistics()
        let zeroAngle = Angle.zeroAngle(
            dragCoefficient: dragCoefficient,
            initialVelocity: initialVelocity,
            sightHeight: sightHeight,
            zeroRange: zeroRange,
            yIntercept: 0
        )
        let headwind = headwindSpeed(windSpeed: windSpeed.mph, windAngle: windAngle)
        let crosswind = crosswindSpeed(windSpeed: windSpeed.mph, windAngle: windAngle)
        let gy = Constants.GRAVITY * cos(Math.degToRad(shootingAngle + zeroAngle))
        let gx = Constants.GRAVITY * sin(Math.degToRad(shootingAngle + zeroAngle))

        var vx = initialVelocity.fps * cos(Math.degToRad(zeroAngle))
        var vy = initialVelocity.fps * sin(Math.degToRad(zeroAngle))
        var x: Double = 0
        var y: Double = -sightHeight.inches / 12
        var n = 0
        var t: Double = 0

        while true {
            let v = sqrt(vx * vx + vy * vy)
            let dv = Drag.retard(dragCoefficient: dragCoefficient, projectileVelocity: v + headwind)
            let dvx = -(vx / v) * dv
            let dvy = -(vy / v) * dv

            let dt = 0.5 / v
            vx += dt * dvx + dt * gx
            vy += dt * dvy + dt * gy

            if x / 3 >= Double(n) {
                let pathInches = y * 12
                let moaCorrection = -Math.radToMOA(atan(y / x))
                let windageInches = windage(windSpeed: crosswind, initialVelocity: initialVelocity.fps, x: x, t: t + dt)
                let windageMoa = Math.radToMOA(atan((windageInches / 12) / x))

                let point = Point(
                    rangeYards: Distance(yards: x / 3),
                    pathInches: Measurement(inches: pathInches),
                    correction: Adjustment(moa: moaCorrection),
                    seconds: t + dt,
                    windageInches: Measurement(inches: windageInches),
                    windageMoa: Adjustment(moa: windageMoa),
                    velocityFPS: ProjectileSpeed(fps: v),
                    velocityXFPS: ProjectileSpeed(fps: vx),
                    velocityYFPS: ProjectileSpeed(fps: vy)
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

    public func getRange(at distance: Distance) -> Distance {
        let yards = Int(distance.yards.rounded())
        guard yards < distances.count else { return Distance(yards: 0) }
        return distances[yards].rangeYards
    }

    public func getElevation(at distance: Distance) -> Measurement {
        let yards = Int(distance.yards.rounded())
        guard yards < distances.count else { return Measurement(inches: 0) }
        return distances[yards].pathInches
    }

    public func getElevationCorrection(at distance: Distance) -> Adjustment {
        let yards = Int(distance.yards.rounded())
        guard yards < distances.count else { return Adjustment(moa: 0) }
        return distances[yards].correction
    }

    public func getTime(at distance: Distance) -> Double {
        let yards = Int(distance.yards.rounded())
        guard yards < distances.count else { return 0 }
        return distances[yards].seconds
    }

    public func getWindage(at distance: Distance) -> Measurement {
        let yards = Int(distance.yards.rounded())
        guard yards < distances.count else { return Measurement(inches: 0) }
        return distances[yards].windageInches
    }

    public func getWindageCorrection(at distance: Distance) -> Adjustment {
        let yards = Int(distance.yards.rounded())
        guard yards < distances.count else { return Adjustment(moa: 0) }
        return distances[yards].windageMoa
    }

    public func getVelocity(at distance: Distance) -> ProjectileSpeed {
        let yards = Int(distance.yards.rounded())
        guard yards < distances.count else { return ProjectileSpeed(fps: 0) }
        return distances[yards].velocityFPS
    }

    public func getVelocityX(at distance: Distance) -> ProjectileSpeed {
        let yards = Int(distance.yards.rounded())
        guard yards < distances.count else { return ProjectileSpeed(fps: 0) }
        return distances[yards].velocityXFPS
    }

    public func getVelocityY(at distance: Distance) -> ProjectileSpeed {
        let yards = Int(distance.yards.rounded())
        guard yards < distances.count else { return ProjectileSpeed(fps: 0) }
        return distances[yards].velocityYFPS
    }

    private let BALLISTICS_COMPUTATION_MAX_YARDS = 1000

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
