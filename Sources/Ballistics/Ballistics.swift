//
//  Ballistics.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

public struct Ballistics {

    var yardages: [Point]

    init() {
        yardages = []
    }

    func getRange(at yardage: Int) -> Double {
        guard yardage < yardages.count else { return 0 }
        return yardages[yardage].rangeYards
    }

    func getPath(at yardage: Int) -> Double {
        guard yardage < yardages.count else { return 0 }
        return yardages[yardage].pathInches
    }

    func getMOA(at yardage: Int) -> Double {
        guard yardage < yardages.count else { return 0 }
        return yardages[yardage].moaCorrection
    }

    func getTime(at yardage: Int) -> Double {
        guard yardage < yardages.count else { return 0 }
        return yardages[yardage].seconds
    }

    func getWindage(at yardage: Int) -> Double {
        guard yardage < yardages.count else { return 0 }
        return yardages[yardage].windageInches
    }

    func getWindageMOA(at yardage: Int) -> Double {
        guard yardage < yardages.count else { return 0 }
        return yardages[yardage].windageMoa
    }

    func getVelocity(at yardage: Int) -> Double {
        guard yardage < yardages.count else { return 0 }
        return yardages[yardage].velocityFPS
    }

    func getVelocityX(at yardage: Int) -> Double {
        guard yardage < yardages.count else { return 0 }
        return yardages[yardage].velocityXFPS
    }

    func getVelocityY(at yardage: Int) -> Double {
        guard yardage < yardages.count else { return 0 }
        return yardages[yardage].velocityYFPS
    }

    static func solveBallistics(
        dragFunction: Drag.DragFunction,
        dragCoefficient: Double,
        initialVelocity: Double,
        sightHeight: Double,
        shootingAngle: Double,
        zeroAngle: Double,
        windSpeed: Double,
        windAngle: Double
    ) -> Ballistics {

        var ballistics = Ballistics()

        let headwind = headwindSpeed(windSpeed: windSpeed, windAngle: windAngle)
        let crosswind = crosswindSpeed(windSpeed: windSpeed, windAngle: windAngle)
        let gy = Constants.GRAVITY * cos(Math.degToRad(shootingAngle + zeroAngle))
        let gx = Constants.GRAVITY * sin(Math.degToRad(shootingAngle + zeroAngle))

        var vx = initialVelocity * cos(Math.degToRad(zeroAngle))
        var vy = initialVelocity * sin(Math.degToRad(zeroAngle))
        var x: Double = 0
        var y: Double = -sightHeight / 12
        var n = 0
        var t: Double = 0

        while true {
            let v = sqrt(vx * vx + vy * vy)
            let dv = Drag.retard(dragFunction: dragFunction, dragCoefficient: dragCoefficient, vp: v + headwind)
            let dvx = -(vx / v) * dv
            let dvy = -(vy / v) * dv

            let dt = 0.5 / v
            vx += dt * dvx + dt * gx
            vy += dt * dvy + dt * gy

            if x / 3 >= Double(n) {
                let pathInches = y * 12
                let moaCorrection = -Math.radToMOA(atan(y / x))
                let windageInches = calculateWindage(crosswind: crosswind, initialVelocity: initialVelocity, x: x, time: t + dt)
                let windageMoa = Math.radToMOA(atan(windageInches / 12 / x))

                let point = Point(
                    rangeYards: x / 3,
                    pathInches: pathInches,
                    moaCorrection: moaCorrection,
                    seconds: t + dt,
                    windageInches: windageInches,
                    windageMoa: windageMoa,
                    velocityFPS: v,
                    velocityXFPS: vx,
                    velocityYFPS: vy
                )
                ballistics.yardages.append(point)
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

    // Constants and Helper Functions
    let BALLISTICS_COMPUTATION_MAX_YARDS = 1000

    static func headwindSpeed(windSpeed: Double, windAngle: Double) -> Double {
        return windSpeed * cos(Math.degToRad(windAngle))
    }

    static func crosswindSpeed(windSpeed: Double, windAngle: Double) -> Double {
        return windSpeed * sin(Math.degToRad(windAngle))
    }

    static func calculateWindage(crosswind: Double, initialVelocity: Double, x: Double, time: Double) -> Double {
        // Replace this with the actual windage calculation logic
        return crosswind * time
    }
}
