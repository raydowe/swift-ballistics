//
//  Drag.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

struct Drag {

    /**
     Calculates the drag coefficient (Cd) for a given projectile velocity and atmospheric conditions.
     - Parameters:
        - model: The drag model to use (e.g., .g1, .g7).
        - velocity: The projectile's velocity in meters per second.
        - atmosphere: The atmospheric conditions.
     - Returns: The calculated drag coefficient (Cd).
    */
    static func coefficient(for model: DragModel, velocity: Double, atmosphere: Atmosphere) -> Double {
        let dragTable: [DragTable]
        switch model {
        case .g1:
            dragTable = g1DragTable
        case .g7:
            dragTable = g7DragTable
        }

        let speedOfSound = atmosphere.speedOfSound()
        guard speedOfSound > 0 else { return 0 }

        let machValue = velocity / speedOfSound

        // Find the two points in the table that bracket the mach value
        guard let upperIndex = dragTable.firstIndex(where: { $0.mach >= machValue }) else {
            // If mach value is higher than table, return the last value
            return dragTable.last?.cd ?? 0
        }

        if upperIndex == 0 {
            return dragTable.first?.cd ?? 0
        }

        let lowerIndex = upperIndex - 1
        let lowerPoint = dragTable[lowerIndex]
        let upperPoint = dragTable[upperIndex]

        // Linear interpolation
        let machRange = upperPoint.mach - lowerPoint.mach
        guard machRange > 0 else { return lowerPoint.cd }

        let cdRange = upperPoint.cd - lowerPoint.cd
        let machFraction = (machValue - lowerPoint.mach) / machRange

        let interpolatedCd = lowerPoint.cd + (cdRange * machFraction)

        return interpolatedCd
    }

    @available(*, deprecated, message: "Use coefficient(for:velocity:atmosphere:) instead. This function uses an outdated, hardcoded G1 model.")
    static func retard(dragCoefficient: Double, projectileVelocity: Double) -> Double {
        // projectileVelocity is in meters per second. This function works with feet per second internally.
        let projectileVelocityFPS = projectileVelocity * 3.28084 // m/s to ft/s

        guard projectileVelocityFPS > 0, projectileVelocityFPS < 10000 else { return -1 }

        var acceleration: Double = -1
        var mass: Double = -1

        if projectileVelocityFPS > 4230 { acceleration = 1.477404177730177e-04; mass = 1.9565 }
        else if projectileVelocityFPS > 3680 { acceleration = 1.920339268755614e-04; mass = 1.925 }
        else if projectileVelocityFPS > 3450 { acceleration = 2.894751026819746e-04; mass = 1.875 }
        else if projectileVelocityFPS > 3295 { acceleration = 4.349905111115636e-04; mass = 1.825 }
        else if projectileVelocityFPS > 3130 { acceleration = 6.520421871892662e-04; mass = 1.775 }
        else if projectileVelocityFPS > 2960 { acceleration = 9.748073694078696e-04; mass = 1.725 }
        else if projectileVelocityFPS > 2830 { acceleration = 1.453721560187286e-03; mass = 1.675 }
        else if projectileVelocityFPS > 2680 { acceleration = 2.162887202930376e-03; mass = 1.625 }
        else if projectileVelocityFPS > 2460 { acceleration = 3.209559783129881e-03; mass = 1.575 }
        else if projectileVelocityFPS > 2225 { acceleration = 3.904368218691249e-03; mass = 1.55 }
        else if projectileVelocityFPS > 2015 { acceleration = 3.222942271262336e-03; mass = 1.575 }
        else if projectileVelocityFPS > 1890 { acceleration = 2.203329542297809e-03; mass = 1.625 }
        else if projectileVelocityFPS > 1810 { acceleration = 1.511001028891904e-03; mass = 1.675 }
        else if projectileVelocityFPS > 1730 { acceleration = 8.609957592468259e-04; mass = 1.75 }
        else if projectileVelocityFPS > 1595 { acceleration = 4.086146797305117e-04; mass = 1.85 }
        else if projectileVelocityFPS > 1520 { acceleration = 1.954473210037398e-04; mass = 1.95 }
        else if projectileVelocityFPS > 1420 { acceleration = 5.431896266462351e-05; mass = 2.125 }
        else if projectileVelocityFPS > 1360 { acceleration = 8.847742581674416e-06; mass = 2.375 }
        else if projectileVelocityFPS > 1315 { acceleration = 1.456922328720298e-06; mass = 2.625 }
        else if projectileVelocityFPS > 1280 { acceleration = 2.419485191895565e-07; mass = 2.875 }
        else if projectileVelocityFPS > 1220 { acceleration = 1.657956321067612e-08; mass = 3.25 }
        else if projectileVelocityFPS > 1185 { acceleration = 4.745469537157371e-10; mass = 3.75 }
        else if projectileVelocityFPS > 1150 { acceleration = 1.379746590025088e-11; mass = 4.25 }
        else if projectileVelocityFPS > 1100 { acceleration = 4.070157961147882e-13; mass = 4.75 }
        else if projectileVelocityFPS > 1060 { acceleration = 2.938236954847331e-14; mass = 5.125 }
        else if projectileVelocityFPS > 1025 { acceleration = 1.228597370774746e-14; mass = 5.25 }
        else if projectileVelocityFPS > 980 { acceleration = 2.916938264100495e-14; mass = 5.125 }
        else if projectileVelocityFPS > 945 { acceleration = 3.855099424807451e-13; mass = 4.75 }
        else if projectileVelocityFPS > 905 { acceleration = 1.185097045689854e-11; mass = 4.25 }
        else if projectileVelocityFPS > 860 { acceleration = 3.566129470974951e-10; mass = 3.75 }
        else if projectileVelocityFPS > 810 { acceleration = 1.045513263966272e-08; mass = 3.25 }
        else if projectileVelocityFPS > 780 { acceleration = 1.291159200846216e-07; mass = 2.875 }
        else if projectileVelocityFPS > 750 { acceleration = 6.824429329105383e-07; mass = 2.625 }
        else if projectileVelocityFPS > 700 { acceleration = 3.569169672385163e-06; mass = 2.375 }
        else if projectileVelocityFPS > 640 { acceleration = 1.839015095899579e-05; mass = 2.125 }
        else if projectileVelocityFPS > 600 { acceleration = 5.71117468873424e-05 ; mass = 1.950 }
        else if projectileVelocityFPS > 550 { acceleration = 9.226557091973427e-05; mass = 1.875 }
        else if projectileVelocityFPS > 250 { acceleration = 9.337991957131389e-05; mass = 1.875 }
        else if projectileVelocityFPS > 100 { acceleration = 7.225247327590413e-05; mass = 1.925 }
        else if projectileVelocityFPS > 65 { acceleration = 5.792684957074546e-05; mass = 1.975 }
        else if projectileVelocityFPS > 0 { acceleration = 5.206214107320588e-05; mass = 2.000 }

        if acceleration != -1, mass != -1 {
            let retardationFPS2 = acceleration * pow(projectileVelocityFPS, mass) / dragCoefficient
            return retardationFPS2 * 0.3048 // convert ft/s^2 to m/s^2
        } else {
            return -1
        }
    }

}
