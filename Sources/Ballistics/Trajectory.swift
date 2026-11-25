//
//  Trajectory.swift
//  swift-ballistics
//

import Foundation

/// Point-mass trajectory integrator shared by zeroing, solving and point-blank range.
///
/// Integrates with downrange distance as the independent variable using classic 4th-order
/// Runge–Kutta, so any distance can be landed on exactly by choosing the step length, and
/// the result is effectively independent of how finely the trajectory is sampled.
///
/// Coordinates are in feet, seconds and ft/s, in the line-of-sight frame: `x` along the line
/// of sight, `y` perpendicular to it (positive up), `z` to the side (positive right).
/// Drag acts against the projectile's velocity relative to the (moving) air, so wind
/// deflection and head/tail wind effects come directly out of the integration.
struct Trajectory {

    struct State {
        var x: Double   // ft downrange
        var y: Double   // ft above line of sight
        var z: Double   // ft right of line of sight
        var vx: Double  // ft/s
        var vy: Double  // ft/s
        var vz: Double  // ft/s
        var t: Double   // s

        init(x: Double = 0, y: Double, z: Double = 0, vx: Double, vy: Double, vz: Double = 0, t: Double = 0) {
            self.x = x
            self.y = y
            self.z = z
            self.vx = vx
            self.vy = vy
            self.vz = vz
            self.t = t
        }

        var speed: Double { sqrt(vx * vx + vy * vy + vz * vz) }
    }

    /// Maximum integration step, in feet of downrange travel.
    static let maxStepFeet: Double = 1

    let dragModel: DragModel
    let dragCoefficient: Double
    /// Air density, lb/ft³.
    let airDensity: Double
    /// Local speed of sound, ft/s.
    let speedOfSound: Double
    /// Air velocity in the line-of-sight frame, ft/s.
    let windX: Double
    let windZ: Double
    /// Gravity components in the line-of-sight frame, ft/s².
    let gx: Double
    let gy: Double

    /**
     - Parameters:
       - headwindFPS: Wind component blowing toward the shooter, ft/s (negative = tailwind).
       - crosswindFPS: Wind component blowing left to right, ft/s.
       - shootingAngleDegrees: Inclination of the line of sight (positive = uphill).
     */
    init(
        dragModel: DragModel,
        dragCoefficient: Double,
        airDensity: Double = Atmosphere.referenceDensity,
        speedOfSound: Double = Drag.standardSpeedOfSound,
        headwindFPS: Double = 0,
        crosswindFPS: Double = 0,
        shootingAngleDegrees: Double = 0
    ) {
        self.dragModel = dragModel
        self.dragCoefficient = dragCoefficient
        self.airDensity = airDensity
        self.speedOfSound = speedOfSound
        self.windX = -headwindFPS
        self.windZ = crosswindFPS
        let angle = Math.degToRad(shootingAngleDegrees)
        self.gx = Constants.GRAVITY * sin(angle)
        self.gy = Constants.GRAVITY * cos(angle)
    }

    /// Whether the projectile can still be integrated against downrange distance.
    static func isTracking(_ s: State) -> Bool {
        s.vx > 0 && abs(s.vy) <= abs(3 * s.vx)
    }

    private struct Slope {
        var y, z, vx, vy, vz, t: Double
    }

    /// d(y, z, vx, vy, vz, t)/dx at the given velocity.
    private func slope(vx: Double, vy: Double, vz: Double) -> Slope {
        // Velocity relative to the air.
        let rx = vx - windX
        let rz = vz - windZ
        let airspeed = sqrt(rx * rx + vy * vy + rz * rz)
        let retardation = Drag.retard(
            dragModel: dragModel,
            dragCoefficient: dragCoefficient,
            projectileVelocity: airspeed,
            airDensity: airDensity,
            speedOfSound: speedOfSound
        )
        let k = airspeed > 0 ? retardation / airspeed : 0
        let ax = -k * rx + gx
        let ay = -k * vy + gy
        let az = -k * rz
        return Slope(y: vy / vx, z: vz / vx, vx: ax / vx, vy: ay / vx, vz: az / vx, t: 1 / vx)
    }

    /// Advances the state by `h` feet downrange.
    func step(_ s: State, by h: Double) -> State {
        let k1 = slope(vx: s.vx, vy: s.vy, vz: s.vz)
        let k2 = slope(vx: s.vx + h / 2 * k1.vx, vy: s.vy + h / 2 * k1.vy, vz: s.vz + h / 2 * k1.vz)
        let k3 = slope(vx: s.vx + h / 2 * k2.vx, vy: s.vy + h / 2 * k2.vy, vz: s.vz + h / 2 * k2.vz)
        let k4 = slope(vx: s.vx + h * k3.vx, vy: s.vy + h * k3.vy, vz: s.vz + h * k3.vz)
        let w = h / 6
        return State(
            x: s.x + h,
            y: s.y + w * (k1.y + 2 * k2.y + 2 * k3.y + k4.y),
            z: s.z + w * (k1.z + 2 * k2.z + 2 * k3.z + k4.z),
            vx: s.vx + w * (k1.vx + 2 * k2.vx + 2 * k3.vx + k4.vx),
            vy: s.vy + w * (k1.vy + 2 * k2.vy + 2 * k3.vy + k4.vy),
            vz: s.vz + w * (k1.vz + 2 * k2.vz + 2 * k3.vz + k4.vz),
            t: s.t + w * (k1.t + 2 * k2.t + 2 * k3.t + k4.t)
        )
    }

    /// Integrates from `start` until exactly `targetX`, or returns nil if the projectile
    /// stops tracking (e.g. falls too steeply) first.
    func advance(_ start: State, to targetX: Double) -> State? {
        var s = start
        while s.x < targetX {
            guard Self.isTracking(s) else { return nil }
            let remaining = targetX - s.x
            s = step(s, by: min(Self.maxStepFeet, remaining))
            if remaining <= Self.maxStepFeet { s.x = targetX }
        }
        return Self.isTracking(s) ? s : nil
    }
}
