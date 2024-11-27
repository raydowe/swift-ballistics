import Testing
@testable import Ballistics

@Test func testLibrary() async throws {

    var bc: Double = 0.414 // The ballistic coefficient for the projectile
    let v: Double = 3300 // Initial velocity, in ft/s
    let sh: Double = 1.8 // Sight height over bore, in inches
    let angle: Double = 0 // The shooting angle (uphill/downhill), in degrees
    let zero: Double = 100 // The zero range of the rifle, in yards
    let windspeed: Double = 0 // Wind speed in miles per hour
    let windangle: Double = 0 // Wind angle (0=headwind, 90=right to left, etc.)

    // Optional: Correct the ballistic coefficient for weather conditions
    bc = Atmosphere.adjustCoefficient(dragCoefficient: bc, altitude: 0, barometer: 29.92, temperature: 138, relativeHumidity: 0.0)

    // Find the "zero angle"
    let zeroAngle = Angle.zeroAngle(
        dragCoefficient: bc,
        initialVelocity: v,
        sightHeight: sh,
        zeroRange: zero,
        yIntercept: 0
    )

    // Generate a full ballistic solution
    let solution = Ballistics.solve(
        dragCoefficient: bc,
        initialVelocity: v,
        sightHeight: sh,
        shootingAngle: angle,
        zeroAngle: zeroAngle,
        windSpeed: windspeed,
        windAngle: windangle
    )

    struct Point: Equatable {
        let range: Double
        let inches: Double
        let velocity: Double
        var readable: String { "\(range),\(inches),\(velocity)" }
    }

    var drops: [Point] = []
    for index in stride(from: 0, through: 600, by: 25) {
        let x = solution.getRange(at: index)
        let y = solution.getPath(at: index)
        let v = solution.getVelocity(at: index)
        drops.append(Point(range: x, inches: y, velocity: v))
    }

    #expect(drops.map { $0.readable } == [
        "0.0,-1.7999999999999998,3300.0000000000005",
        "25.163827067823906,-1.0298297678135324,3244.427176102468",
        "50.160999826845206,-0.4718987863729519,3189.94467693073",
        "75.15816476830241,-0.1275468515712207,3136.1740584072536",
        "100.15532026196051,-0.004160564690024353,3083.105582490506",
        "125.15246253681481,-0.10941305604020546,3030.693609855036",
        "150.149589647502,-0.4512809044546673,2978.930824331706",
        "175.14669910416714,-1.0380587301006838,2927.8037146921533",
        "200.1437868389252,-1.878375429241867,2877.2755551473047",
        "225.1408502106198,-2.981214164321439,2827.3397361557572",
        "250.1378853126006,-4.355930359726251,2777.9727126925027",
        "275.13488772994776,-6.012273295565768,2729.1482580357265",
        "300.13185414467625,-7.960409738972572,2680.8639905675773",
        "325.1287796029669,-10.210945411942236,2633.096581399448",
        "350.12565871211115,-12.774951833744577,2585.8226528650657",
        "375.122487053326,-15.663995364657566,2539.0408885086704",
        "400.1192597994706,-18.890163714605578,2492.7499655661177",
        "425.11597095494795,-22.466093690301438,2446.9379546512264",
        "450.11261266100684,-26.40500482384045,2401.573902133122",
        "475.1091798969688,-30.720738561631492,2356.6768136047067",
        "500.1056657260908,-35.42778857610974,2312.2458387632664",
        "525.1020625662286,-40.54133701724821,2268.2801235097368",
        "550.0983621275061,-46.07729351782898,2224.7788100204325",
        "575.0945532440975,-52.05233851600542,2181.7135555426125",
        "600.0906296766896,-58.483973569441005,2139.1323595038343"
    ])
}
