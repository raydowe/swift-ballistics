//
//  Drag.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 26/11/2024.
//

import Foundation

struct Drag {

    static func retard(dragCoefficient: Double, projectileVelocity: Double) -> Double {
        guard projectileVelocity > 0, projectileVelocity < 10000 else { return -1 }

        var acceleration: Double = -1
        var mass: Double = -1

        if projectileVelocity > 4230 { acceleration = 1.477404177730177e-04; mass = 1.9565 }
        else if projectileVelocity > 3680 { acceleration = 1.920339268755614e-04; mass = 1.925 }
        else if projectileVelocity > 3450 { acceleration = 2.894751026819746e-04; mass = 1.875 }
        else if projectileVelocity > 3295 { acceleration = 4.349905111115636e-04; mass = 1.825 }
        else if projectileVelocity > 3130 { acceleration = 6.520421871892662e-04; mass = 1.775 }
        else if projectileVelocity > 2960 { acceleration = 9.748073694078696e-04; mass = 1.725 }
        else if projectileVelocity > 2830 { acceleration = 1.453721560187286e-03; mass = 1.675 }
        else if projectileVelocity > 2680 { acceleration = 2.162887202930376e-03; mass = 1.625 }
        else if projectileVelocity > 2460 { acceleration = 3.209559783129881e-03; mass = 1.575 }
        else if projectileVelocity > 2225 { acceleration = 3.904368218691249e-03; mass = 1.55 }
        else if projectileVelocity > 2015 { acceleration = 3.222942271262336e-03; mass = 1.575 }
        else if projectileVelocity > 1890 { acceleration = 2.203329542297809e-03; mass = 1.625 }
        else if projectileVelocity > 1810 { acceleration = 1.511001028891904e-03; mass = 1.675 }
        else if projectileVelocity > 1730 { acceleration = 8.609957592468259e-04; mass = 1.75 }
        else if projectileVelocity > 1595 { acceleration = 4.086146797305117e-04; mass = 1.85 }
        else if projectileVelocity > 1520 { acceleration = 1.954473210037398e-04; mass = 1.95 }
        else if projectileVelocity > 1420 { acceleration = 5.431896266462351e-05; mass = 2.125 }
        else if projectileVelocity > 1360 { acceleration = 8.847742581674416e-06; mass = 2.375 }
        else if projectileVelocity > 1315 { acceleration = 1.456922328720298e-06; mass = 2.625 }
        else if projectileVelocity > 1280 { acceleration = 2.419485191895565e-07; mass = 2.875 }
        else if projectileVelocity > 1220 { acceleration = 1.657956321067612e-08; mass = 3.25 }
        else if projectileVelocity > 1185 { acceleration = 4.745469537157371e-10; mass = 3.75 }
        else if projectileVelocity > 1150 { acceleration = 1.379746590025088e-11; mass = 4.25 }
        else if projectileVelocity > 1100 { acceleration = 4.070157961147882e-13; mass = 4.75 }
        else if projectileVelocity > 1060 { acceleration = 2.938236954847331e-14; mass = 5.125 }
        else if projectileVelocity > 1025 { acceleration = 1.228597370774746e-14; mass = 5.25 }
        else if projectileVelocity > 980 { acceleration = 2.916938264100495e-14; mass = 5.125 }
        else if projectileVelocity > 945 { acceleration = 3.855099424807451e-13; mass = 4.75 }
        else if projectileVelocity > 905 { acceleration = 1.185097045689854e-11; mass = 4.25 }
        else if projectileVelocity > 860 { acceleration = 3.566129470974951e-10; mass = 3.75 }
        else if projectileVelocity > 810 { acceleration = 1.045513263966272e-08; mass = 3.25 }
        else if projectileVelocity > 780 { acceleration = 1.291159200846216e-07; mass = 2.875 }
        else if projectileVelocity > 750 { acceleration = 6.824429329105383e-07; mass = 2.625 }
        else if projectileVelocity > 700 { acceleration = 3.569169672385163e-06; mass = 2.375 }
        else if projectileVelocity > 640 { acceleration = 1.839015095899579e-05; mass = 2.125 }
        else if projectileVelocity > 600 { acceleration = 5.71117468873424e-05; mass = 1.95 }
        else if projectileVelocity > 550 { acceleration = 9.226557091973427e-05; mass = 1.875 }
        else if projectileVelocity > 250 { acceleration = 9.337991957131389e-05; mass = 1.875 }
        else if projectileVelocity > 100 { acceleration = 7.225247327590413e-05; mass = 1.925 }
        else if projectileVelocity > 65 { acceleration = 5.792684957074546e-05; mass = 1.975 }
        else if projectileVelocity > 0 { acceleration = 5.206214107320588e-05; mass = 2.000 }

        if acceleration != -1, mass != -1 {
            return acceleration * pow(projectileVelocity, mass) / dragCoefficient
        } else {
            return -1
        }
    }

}
