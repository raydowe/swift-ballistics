//
//  Angle.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

struct Angle {
    /**
     Calculates the angle of elevation required to zero a firearm at a specific range using an iterative solver.

     This method determines the angle of elevation that aligns the projectile's trajectory
     with the point of aim at the zero range by running simulations at different angles
     until the desired y-intercept is achieved.
    
     - Parameter simulation: The simulation object containing all projectile and environmental parameters.
     - Returns: A `Double` representing the required angle of elevation in radians.
   */
    
    static func zeroAngle(for simulation: Simulation) -> Double {

        let yIntercept: Double = 0 // Assuming the target is at the same height as the scope

        // Secant method for root finding
        var angle0 = Math.degToRad(-1) // First guess
        var angle1 = Math.degToRad(1)  // Second guess

        var f0 = simulation.solveDropAtRange(launchAngle: angle0, targetRange: simulation.zeroRange) - yIntercept
        var f1 = simulation.solveDropAtRange(launchAngle: angle1, targetRange: simulation.zeroRange) - yIntercept

        for _ in 0..<10 { // Iterate up to 10 times, which should be plenty
            if abs(f1) < 1e-6 { // If we are close enough, exit
                return angle1
            }

            let nextAngle = angle1 - f1 * (angle1 - angle0) / (f1 - f0)

            if abs(nextAngle - angle1) < 1e-6 { // If the angle isn't changing much, we're done
                return nextAngle
            }

            angle0 = angle1
            f0 = f1

            angle1 = nextAngle
            f1 = simulation.solveDropAtRange(launchAngle: angle1, targetRange: simulation.zeroRange) - yIntercept
        }

        return angle1
    }
}
