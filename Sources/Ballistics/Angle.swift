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
       - dragModel: The drag model (G1 or G7) the drag coefficient is expressed in.
       - dragCoefficient: The drag coefficient of the projectile, representing its aerodynamic properties.
       - airDensity: Air density, lb/ft³.
       - speedOfSound: Local speed of sound, ft/s.
       - initialVelocity: The muzzle velocity of the projectile in feet per second (f/s).
       - sightHeight: The height of the sight above the bore axis in inches (in).
       - zeroRange: The desired zero range in yards (yrd), where the projectile intersects the line of sight.
       - yIntercept: The vertical offset of the projectile at the muzzle in inches (in).

     - Returns:
       A `Double` representing the required angle of elevation in degrees to achieve the zero range.
   */

    static func zeroAngle(
        dragModel: DragModel = .g1,
        dragCoefficient: Double,
        airDensity: Double = Atmosphere.referenceDensity,
        speedOfSound: Double = Drag.standardSpeedOfSound,
        initialVelocity: Measurement<UnitSpeed>,
        sightHeight: Measurement<UnitLength>,
        zeroRange: Measurement<UnitLength>,
        yIntercept: Double
    ) -> Double {
        let velocity = initialVelocity.converted(to: .feetPerSecond).value
        let startY = -sightHeight.converted(to: .feet).value
        let rangeFeet = zeroRange.converted(to: .feet).value

        // Zeroing assumes a level line of sight, so gravity acts straight down in its frame.
        let trajectory = Trajectory(
            dragModel: dragModel,
            dragCoefficient: dragCoefficient,
            airDensity: airDensity,
            speedOfSound: speedOfSound
        )

        // Height of the projectile relative to the line of sight at the zero range, in feet.
        func height(atBoreAngle angle: Double) -> Double {
            let start = Trajectory.State(y: startY, vx: velocity * cos(angle), vy: velocity * sin(angle))
            return trajectory.advance(start, to: rangeFeet)?.y ?? -.infinity
        }

        // Height at the zero range rises with bore angle, so bisect between level and 45°.
        var low: Double = 0
        var high = Math.degToRad(45)
        guard height(atBoreAngle: high) >= yIntercept else { return 45 }
        while high - low > 1e-12 {
            let mid = (low + high) / 2
            if height(atBoreAngle: mid) < yIntercept { low = mid } else { high = mid }
        }
        return Math.radToDeg((low + high) / 2)
    }
}
