//
//  Drag.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

/// The standard reference projectile a ballistic coefficient is measured against.
public enum DragModel: Sendable, CaseIterable {
    /// G1 (flat-base) reference projectile. Most published BCs use this model.
    case g1
    /// G7 (long boat-tail, VLD) reference projectile. Better suited to modern long-range bullets.
    case g7
}

struct Drag {

    /// Speed of sound at 59 °F, ft/s (49.0223 · √°R).
    static let standardSpeedOfSound = 49.0223 * sqrt(59 + 459.67)

    /// π/8 ÷ 144: converts ρ·v²·Cd/BC (BC in lb/in²) into deceleration in ft/s².
    private static let dragConstant = Double.pi / 8 / 144

    /**
     Drag deceleration of a projectile.

     - Parameters:
       - dragModel: The reference projectile the ballistic coefficient is expressed against.
       - dragCoefficient: The ballistic coefficient, lb/in².
       - projectileVelocity: Speed relative to the air, ft/s.
       - airDensity: Air density, lb/ft³. Defaults to Army Standard Metro.
       - speedOfSound: Local speed of sound, ft/s. Defaults to 59 °F.
     - Returns: Deceleration in ft/s² (0 for a non-positive velocity).
     */
    static func retard(
        dragModel: DragModel = .g1,
        dragCoefficient: Double,
        projectileVelocity: Double,
        airDensity: Double = Atmosphere.referenceDensity,
        speedOfSound: Double = standardSpeedOfSound
    ) -> Double {
        guard projectileVelocity > 0 else { return 0 }
        let cd = coefficient(dragModel, mach: projectileVelocity / speedOfSound)
        return dragConstant * airDensity * projectileVelocity * projectileVelocity * cd / dragCoefficient
    }

    /// Drag coefficient of the reference projectile at the given Mach number.
    static func coefficient(_ model: DragModel, mach: Double) -> Double {
        switch model {
        case .g1: return g1Curve.value(at: mach)
        case .g7: return g7Curve.value(at: mach)
        }
    }

    private static let g1Curve = MonotoneCubic(points: Tables.g1)
    private static let g7Curve = MonotoneCubic(points: Tables.g7)
}

/// Monotone piecewise cubic Hermite interpolation (Fritsch–Carlson / PCHIP).
///
/// Passes through every table point, has a continuous first derivative, and never overshoots
/// between points, so the drag curve has no artificial bumps. Values outside the table are
/// held at the nearest end point.
///
/// The curves are built once and live for the whole process, so their data is kept in plain
/// buffers rather than arrays: drag is evaluated millions of times per solve, and this avoids
/// reference-counting traffic on every lookup (which contends badly across threads in debug builds).
/// The buffers are written only during `init` and are read-only afterwards, so sharing is safe.
struct MonotoneCubic: @unchecked Sendable {
    private let xs: UnsafeBufferPointer<Double>
    private let ys: UnsafeBufferPointer<Double>
    private let slopes: UnsafeBufferPointer<Double>

    private static func permanent(_ values: [Double]) -> UnsafeBufferPointer<Double> {
        let buffer = UnsafeMutableBufferPointer<Double>.allocate(capacity: values.count)
        _ = buffer.initialize(from: values)
        return UnsafeBufferPointer(buffer)
    }

    init(points: [(mach: Double, cd: Double)]) {
        let xs = points.map(\.mach)
        let ys = points.map(\.cd)
        self.xs = Self.permanent(xs)
        self.ys = Self.permanent(ys)
        let n = xs.count
        let h = (0..<n - 1).map { xs[$0 + 1] - xs[$0] }
        let delta = (0..<n - 1).map { (ys[$0 + 1] - ys[$0]) / h[$0] }

        var m = [Double](repeating: 0, count: n)
        for i in 1..<n - 1 {
            let d0 = delta[i - 1], d1 = delta[i]
            if d0 == 0 || d1 == 0 || (d0 > 0) != (d1 > 0) { continue }
            let w1 = 2 * h[i] + h[i - 1]
            let w2 = h[i] + 2 * h[i - 1]
            m[i] = (w1 + w2) / (w1 / d0 + w2 / d1)
        }
        func endSlope(_ h0: Double, _ h1: Double, _ d0: Double, _ d1: Double) -> Double {
            let s = ((2 * h0 + h1) * d0 - h0 * d1) / (h0 + h1)
            if (s > 0) != (d0 > 0) || s == 0 || d0 == 0 { return 0 }
            return abs(s) > 3 * abs(d0) ? 3 * d0 : s
        }
        m[0] = endSlope(h[0], h[1], delta[0], delta[1])
        m[n - 1] = endSlope(h[n - 2], h[n - 3], delta[n - 2], delta[n - 3])
        slopes = Self.permanent(m)
    }

    func value(at x: Double) -> Double {
        if x <= xs[0] { return ys[0] }
        if x >= xs[xs.count - 1] { return ys[ys.count - 1] }
        // Binary search for the segment containing x.
        var low = 0, high = xs.count - 1
        while high - low > 1 {
            let mid = (low + high) / 2
            if xs[mid] <= x { low = mid } else { high = mid }
        }
        let h = xs[high] - xs[low]
        let t = (x - xs[low]) / h
        let t2 = t * t, t3 = t2 * t
        return (2 * t3 - 3 * t2 + 1) * ys[low]
            + (t3 - 2 * t2 + t) * h * slopes[low]
            + (-2 * t3 + 3 * t2) * ys[high]
            + (t3 - t2) * h * slopes[high]
    }
}

extension Drag {
    /// Standard drag tables: drag coefficient of the reference projectile by Mach number
    /// (as published by the U.S. Army Ballistic Research Laboratory; same values as JBM and
    /// py-ballisticcalc).
    enum Tables {
    static let g1: [(mach: Double, cd: Double)] = [
        (0.0, 0.2629), (0.05, 0.2558), (0.1, 0.2487), (0.15, 0.2413),
        (0.2, 0.2344), (0.25, 0.2278), (0.3, 0.2214), (0.35, 0.2155),
        (0.4, 0.2104), (0.45, 0.2061), (0.5, 0.2032), (0.55, 0.202),
        (0.6, 0.2034), (0.7, 0.2165), (0.725, 0.223), (0.75, 0.2313),
        (0.775, 0.2417), (0.8, 0.2546), (0.825, 0.2706), (0.85, 0.2901),
        (0.875, 0.3136), (0.9, 0.3415), (0.925, 0.3734), (0.95, 0.4084),
        (0.975, 0.4448), (1.0, 0.4805), (1.025, 0.5136), (1.05, 0.5427),
        (1.075, 0.5677), (1.1, 0.5883), (1.125, 0.6053), (1.15, 0.6191),
        (1.2, 0.6393), (1.25, 0.6518), (1.3, 0.6589), (1.35, 0.6621),
        (1.4, 0.6625), (1.45, 0.6607), (1.5, 0.6573), (1.55, 0.6528),
        (1.6, 0.6474), (1.65, 0.6413), (1.7, 0.6347), (1.75, 0.628),
        (1.8, 0.621), (1.85, 0.6141), (1.9, 0.6072), (1.95, 0.6003),
        (2.0, 0.5934), (2.05, 0.5867), (2.1, 0.5804), (2.15, 0.5743),
        (2.2, 0.5685), (2.25, 0.563), (2.3, 0.5577), (2.35, 0.5527),
        (2.4, 0.5481), (2.45, 0.5438), (2.5, 0.5397), (2.6, 0.5325),
        (2.7, 0.5264), (2.8, 0.5211), (2.9, 0.5168), (3.0, 0.5133),
        (3.1, 0.5105), (3.2, 0.5084), (3.3, 0.5067), (3.4, 0.5054),
        (3.5, 0.504), (3.6, 0.503), (3.7, 0.5022), (3.8, 0.5016),
        (3.9, 0.501), (4.0, 0.5006), (4.2, 0.4998), (4.4, 0.4995),
        (4.6, 0.4992), (4.8, 0.499), (5.0, 0.4988),
    ]

    static let g7: [(mach: Double, cd: Double)] = [
        (0.0, 0.1198), (0.05, 0.1197), (0.1, 0.1196), (0.15, 0.1194),
        (0.2, 0.1193), (0.25, 0.1194), (0.3, 0.1194), (0.35, 0.1194),
        (0.4, 0.1193), (0.45, 0.1193), (0.5, 0.1194), (0.55, 0.1193),
        (0.6, 0.1194), (0.65, 0.1197), (0.7, 0.1202), (0.725, 0.1207),
        (0.75, 0.1215), (0.775, 0.1226), (0.8, 0.1242), (0.825, 0.1266),
        (0.85, 0.1306), (0.875, 0.1368), (0.9, 0.1464), (0.925, 0.166),
        (0.95, 0.2054), (0.975, 0.2993), (1.0, 0.3803), (1.025, 0.4015),
        (1.05, 0.4043), (1.075, 0.4034), (1.1, 0.4014), (1.125, 0.3987),
        (1.15, 0.3955), (1.2, 0.3884), (1.25, 0.381), (1.3, 0.3732),
        (1.35, 0.3657), (1.4, 0.358), (1.5, 0.344), (1.55, 0.3376),
        (1.6, 0.3315), (1.65, 0.326), (1.7, 0.3209), (1.75, 0.316),
        (1.8, 0.3117), (1.85, 0.3078), (1.9, 0.3042), (1.95, 0.301),
        (2.0, 0.298), (2.05, 0.2951), (2.1, 0.2922), (2.15, 0.2892),
        (2.2, 0.2864), (2.25, 0.2835), (2.3, 0.2807), (2.35, 0.2779),
        (2.4, 0.2752), (2.45, 0.2725), (2.5, 0.2697), (2.55, 0.267),
        (2.6, 0.2643), (2.65, 0.2615), (2.7, 0.2588), (2.75, 0.2561),
        (2.8, 0.2533), (2.85, 0.2506), (2.9, 0.2479), (2.95, 0.2451),
        (3.0, 0.2424), (3.1, 0.2368), (3.2, 0.2313), (3.3, 0.2258),
        (3.4, 0.2205), (3.5, 0.2154), (3.6, 0.2106), (3.7, 0.206),
        (3.8, 0.2017), (3.9, 0.1975), (4.0, 0.1935), (4.2, 0.1861),
        (4.4, 0.1793), (4.6, 0.173), (4.8, 0.1672), (5.0, 0.1618),
    ]
    }
}
