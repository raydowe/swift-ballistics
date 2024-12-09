//
//  Adjustment.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 04/12/2024.
//

public struct Adjustment: Equatable, Hashable {

    public let moa: Double
    public var mils: Double { moa / 3.43775 }

    init(moa: Double) {
        self.moa = moa
    }

    init(mils: Double) {
        self.moa = mils * 3.43775
    }
}
