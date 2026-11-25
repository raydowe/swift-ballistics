//
//  BPR.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

/// Point-blank range: the zero that keeps the projectile within ±`vitalSize / 2` of the line of
/// sight for as far as possible, and the ranges that result. Distances are whole yards
/// (truncated), matching libballistics.
struct PBR: Equatable {

    enum SolveError: Error {
        /// The projectile cannot rise to the top of the vital zone at any bore angle up to 45°.
        case unreachable
        /// The trajectory became too steep to track before leaving the vital zone.
        case trajectoryLost
    }

    /// Where the projectile first crosses the line of sight on the way up.
    var nearZeroYards: Int
    /// Where the projectile crosses the line of sight on the way down (the zero to sight in at).
    var farZeroYards: Int
    /// Where the projectile first rises into the vital zone.
    var minPBRYards: Int
    /// Where the projectile falls out of the vital zone.
    var maxPBRYards: Int
    /// Height above the line of sight at 100 yd, in hundredths of an inch.
    var sightInAt100Yards: Int

    /**
     Solves point-blank range for a level shot in standard air.

     - Parameters:
       - dragModel: The drag model the coefficient is for.
       - dragCoefficient: The ballistic coefficient.
       - initialVelocity: Muzzle velocity, ft/s.
       - sightHeight: Sight height above the bore, inches.
       - vitalSize: Diameter of the vital zone, inches.
     */
    static func solve(
        dragModel: DragModel = .g1,
        dragCoefficient: Double,
        initialVelocity: Double,
        sightHeight: Double,
        vitalSize: Double
    ) -> Result<PBR, Error> {
        let trajectory = Trajectory(dragModel: dragModel, dragCoefficient: dragCoefficient)
        let halfVital = vitalSize / 2 / 12  // ft
        let step = Trajectory.maxStepFeet

        func start(_ angle: Double) -> Trajectory.State {
            Trajectory.State(y: -sightHeight / 12, vx: initialVelocity * cos(angle), vy: initialVelocity * sin(angle))
        }

        // Highest point above the line of sight for a given bore angle (nil if lost before apex).
        func apex(_ angle: Double) -> Double? {
            var s = start(angle)
            while s.vy > 0 {
                guard Trajectory.isTracking(s) else { return nil }
                let next = trajectory.step(s, by: step)
                if next.vy <= 0 {
                    // Vertical speed passes through zero in this step; the apex is where it does.
                    let f = s.vy / (s.vy - next.vy)
                    return s.y + f * (next.y - s.y)
                }
                s = next
            }
            return s.y
        }

        // The apex rises with bore angle: bisect for the angle whose apex touches the top of the zone.
        var low: Double = 0
        var high = Math.degToRad(45)
        guard let highest = apex(high), highest >= halfVital else { return .failure(SolveError.unreachable) }
        while high - low > 1e-12 {
            let mid = (low + high) / 2
            if (apex(mid) ?? -.infinity) < halfVital { low = mid } else { high = mid }
        }
        let angle = (low + high) / 2

        // Walk the trajectory, interpolating the downrange distance of each crossing.
        func crossing(_ a: Trajectory.State, _ b: Trajectory.State, height: Double) -> Double {
            a.x + (height - a.y) / (b.y - a.y) * (b.x - a.x)
        }
        var nearZero: Double?, farZero: Double?, minPBR: Double?, maxPBR: Double?
        var s = start(angle)
        if s.y >= -halfVital { minPBR = 0 }
        while maxPBR == nil {
            guard Trajectory.isTracking(s) else { return .failure(SolveError.trajectoryLost) }
            let next = trajectory.step(s, by: step)
            if minPBR == nil, s.y < -halfVital, next.y >= -halfVital { minPBR = crossing(s, next, height: -halfVital) }
            if nearZero == nil, s.y < 0, next.y >= 0 { nearZero = crossing(s, next, height: 0) }
            if nearZero != nil, farZero == nil, s.y >= 0, next.y < 0 { farZero = crossing(s, next, height: 0) }
            if farZero != nil, s.y >= -halfVital, next.y < -halfVital { maxPBR = crossing(s, next, height: -halfVital) }
            s = next
        }
        guard let at100 = trajectory.advance(start(angle), to: 300) else { return .failure(SolveError.trajectoryLost) }

        return .success(PBR(
            nearZeroYards: Int((nearZero ?? 0) / 3),
            farZeroYards: Int((farZero ?? 0) / 3),
            minPBRYards: Int((minPBR ?? 0) / 3),
            maxPBRYards: Int((maxPBR ?? 0) / 3),
            sightInAt100Yards: Int(100 * at100.y * 12)
        ))
    }
}
