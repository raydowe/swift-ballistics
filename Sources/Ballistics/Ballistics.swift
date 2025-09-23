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

    public static func solve(
        dragCoefficient: Double,
        initialVelocity: Measurement<UnitSpeed>,
        sightHeight: Measurement<UnitLength>,
        shootingAngle: Measurement<UnitAngle>,
        zeroRange: Measurement<UnitLength>,
        atmosphere: Atmosphere? = nil,
        windSpeed: Measurement<UnitSpeed>,
        windAngle: Double,
        weight: Measurement<UnitMass> = Measurement<UnitMass>(value: 0, unit: .grams)
    ) -> Ballistics {
        var simulation = Simulation(
            dragCoefficient: dragCoefficient,
            initialVelocity: initialVelocity,
            sightHeight: sightHeight,
            shootingAngle: shootingAngle,
            zeroRange: zeroRange,
            atmosphere: atmosphere,
            windSpeed: windSpeed,
            windAngle: windAngle,
            weight: weight
        )
        return simulation.run()
    }

    public func getPoint(at distance: Measurement<UnitLength>) -> Point? {
        let meters = Int(distance.converted(to: .meters).value.rounded())
        guard meters < distances.count else { return nil }
        return distances[meters]
    }
}

private struct Simulation {
    // input parameters
    let dragCoefficient: Double
    let initialVelocity: Measurement<UnitSpeed>
    let sightHeight: Measurement<UnitLength>
    let shootingAngle: Measurement<UnitAngle>
    let zeroRange: Measurement<UnitLength>
    let atmosphere: Atmosphere?
    let windSpeed: Measurement<UnitSpeed>
    let windAngle: Double
    let weight: Measurement<UnitMass>

    // state variables
    var ballistics = Ballistics()
    var vx, vy, x, y, t: Double
    var n: Int

    init(
        dragCoefficient: Double,
        initialVelocity: Measurement<UnitSpeed>,
        sightHeight: Measurement<UnitLength>,
        shootingAngle: Measurement<UnitAngle>,
        zeroRange: Measurement<UnitLength>,
        atmosphere: Atmosphere?,
        windSpeed: Measurement<UnitSpeed>,
        windAngle: Double,
        weight: Measurement<UnitMass>
    ) {
        self.dragCoefficient = dragCoefficient
        self.initialVelocity = initialVelocity
        self.sightHeight = sightHeight
        self.shootingAngle = shootingAngle
        self.zeroRange = zeroRange
        self.atmosphere = atmosphere
        self.windSpeed = windSpeed
        self.windAngle = windAngle
        self.weight = weight

        self.vx = 0
        self.vy = 0
        self.x = 0
        self.y = 0
        self.n = 0
        self.t = 0
    }

    mutating func run() -> Ballistics {
        let environmentDragCoefficient = atmosphere?.adjustCoefficient(dragCoefficient: dragCoefficient) ?? dragCoefficient
        let initialVelocityMPS = initialVelocity.converted(to: .metersPerSecond).value

        let zeroAngle = Angle.zeroAngle(
            dragCoefficient: environmentDragCoefficient,
            initialVelocity: self.initialVelocity,
            sightHeight: self.sightHeight,
            zeroRange: self.zeroRange,
            yIntercept: 0
        )

        self.vx = initialVelocityMPS * cos(zeroAngle)
        self.vy = initialVelocityMPS * sin(zeroAngle)
        self.y = -sightHeight.converted(to: .meters).value

        let headwind = headwindSpeed(windSpeed: windSpeed.converted(to: .metersPerSecond).value, windAngle: windAngle)
        let crosswind = crosswindSpeed(windSpeed: windSpeed.converted(to: .metersPerSecond).value, windAngle: windAngle)

        let shootingAngleRad = shootingAngle.converted(to: .radians).value
        let gy = Constants.GRAVITY * cos(shootingAngleRad + zeroAngle)
        let gx = Constants.GRAVITY * sin(shootingAngleRad + zeroAngle)

        while true {
            let v = sqrt(vx * vx + vy * vy)
            let dv = Drag.retard(dragCoefficient: environmentDragCoefficient, projectileVelocity: v + headwind)
            let dvx = -(vx / v) * dv
            let dvy = -(vy / v) * dv

            let dt = Constants.SIMULATION_TIME_STEP_FACTOR / v

            vx += dt * dvx + dt * gx
            vy += dt * dvy + dt * gy

            if x >= Double(n) {
                addPoint(v: v, dt: dt, crosswind: crosswind, initialVelocityMPS: initialVelocityMPS)
                n += 1
            }

            x += dt * vx
            y += dt * vy

            if abs(vy) > abs(Constants.SIMULATION_STOP_SLOPE * vx) || n >= Constants.BALLISTICS_COMPUTATION_MAX_METERS {
                break
            }

            t += dt
        }
        return ballistics
    }

    private mutating func addPoint(v: Double, dt: Double, crosswind: Double, initialVelocityMPS: Double) {
        let moaDrop = -Math.radToMOA(atan(y / x))
        let windageMeters = windage(windSpeed: crosswind, initialVelocity: initialVelocityMPS, x: x, t: t + dt)
        let moaWindage = Math.radToMOA(atan(windageMeters / x))

        let massInKg = weight.converted(to: .kilograms).value
        let energyInJoules = 0.5 * massInKg * pow(v, 2)

        let point = Point(
            range: Measurement(value: x, unit: .meters),
            drop: Measurement(value: y, unit: .meters),
            dropCorrection: Measurement(value: moaDrop, unit: .minutesOfAngle),
            windage: Measurement(value: windageMeters, unit: .meters),
            windageCorrection: Measurement(value: moaWindage, unit: .minutesOfAngle),
            seconds: t + dt,
            velocity: Measurement(value: v, unit: .metersPerSecond),
            velocityX: Measurement(value: vx, unit: .metersPerSecond),
            velocityY: Measurement(value: vy, unit: .metersPerSecond),
            energy: Measurement(value: energyInJoules, unit: .joules)
        )
        ballistics.distances.append(point)
    }

    private func headwindSpeed(windSpeed: Double, windAngle: Double) -> Double {
        return windSpeed * cos(Math.degToRad(windAngle))
    }

    private func crosswindSpeed(windSpeed: Double, windAngle: Double) -> Double {
        return windSpeed * sin(Math.degToRad(windAngle))
    }

    private func windage(windSpeed: Double, initialVelocity: Double, x: Double, t: Double) -> Double {
        // windSpeed is in m/s. initialVelocity is in m/s. x is in meters. t is in seconds.
        // The result should be in meters.
        return windSpeed * (t - x / initialVelocity)
    }
}
