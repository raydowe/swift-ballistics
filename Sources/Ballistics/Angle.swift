//
//  Angle.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

public struct Angle {

    /**
     Calculates the angle of elevation required to zero a firearm at a specific range.

     This method determines the angle of elevation that aligns the projectile's trajectory
     with the point of aim at the zero range, considering the drag coefficient, initial velocity,
     sight height, and the y-intercept (height offset at the muzzle or near the firearm).
    
     - Parameters:
       - dragCoefficient: The G1 drag coefficient of the projectile, representing its aerodynamic properties.
       - initialVelocity: The muzzle velocity of the projectile.
       - sightHeight: The height of the sight above the bore axis.
       - zeroRange: The desired zero range, where the projectile intersects the line of sight.
       - yIntercept: The vertical offset of the projectile at the muzzle in meters.

     - Returns:
       A `Double` representing the required angle of elevation in radians to achieve the zero range.
   */

    static func zeroAngle(
        dragCoefficient: Double,
        initialVelocity: Measurement<UnitSpeed>,
        sightHeight: Measurement<UnitLength>,
        zeroRange: Measurement<UnitLength>,
        yIntercept: Double
    ) -> Double {

        let initialVelocityMPS = initialVelocity.converted(to: .metersPerSecond).value
        let sightHeightMeters = sightHeight.converted(to: .meters).value
        let zeroRangeMeters = zeroRange.converted(to: .meters).value

        var dt: Double = 1 / initialVelocityMPS
        var y: Double = -sightHeightMeters
        var x: Double = 0
        var da: Double

        var v: Double = 0
        var vx: Double = 0
        var vy: Double = 0
        var vx1: Double = 0
        var vy1: Double = 0
        var dv: Double = 0
        var dvx: Double = 0
        var dvy: Double = 0
        var Gx: Double = 0
        var Gy: Double = 0

        var angle: Double = 0
        var quit = false

        da = Math.degToRad(14)

        while !quit {
            vy = initialVelocityMPS * sin(angle)
            vx = initialVelocityMPS * cos(angle)
            Gx = Constants.GRAVITY * sin(angle)
            Gy = Constants.GRAVITY * cos(angle)
            
            x = 0
            y = -sightHeightMeters

            while x <= zeroRangeMeters {
                vy1 = vy
                vx1 = vx
                v = sqrt(vx * vx + vy * vy)
                dt = 1 / v

                dv = Drag.retard(dragCoefficient: dragCoefficient, projectileVelocity: v)
                dvy = -dv * vy / v * dt
                dvx = -dv * vx / v * dt

                vx += dvx + dt * Gx
                vy += dvy + dt * Gy

                x += dt * (vx + vx1) / 2
                y += dt * (vy + vy1) / 2

                if vy < 0 && y < yIntercept {
                    break
                }
                if abs(vy) > Constants.SIMULATION_STOP_SLOPE * abs(vx) {
                    break
                }
            }

            if y > yIntercept && da > 0 {
                da = -da / 2
            }

            if y < yIntercept && da < 0 {
                da = -da / 2
            }

            if abs(da) < Math.moaToRad(0.01) || angle > Math.degToRad(45) {
                quit = true
            }

            angle += da
        }

        return angle
    }
}
