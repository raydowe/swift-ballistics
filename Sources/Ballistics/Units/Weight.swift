//
//  Weight.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 10/12/2024.
//

public struct Weight: Equatable, Hashable {

    public let grains: Double
    public var grams: Double { grains * 0.06479891 }

    public init(grains: Double) {
        self.grains = grains
    }

    public init(grams: Double) {
        self.grains = grams / 0.06479891
    }
}
