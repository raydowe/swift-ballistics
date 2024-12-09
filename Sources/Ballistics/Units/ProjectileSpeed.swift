//
//  Wind.swift
//  swift-ballistics
//
//  Created by Raymond Dowe on 04/12/2024.
//

public struct ProjectileSpeed: Equatable, Hashable {

    public let fps: Double
    public var ms: Double { fps * 0.3048 }

    public init(fps: Double) {
        self.fps = fps
    }

    public init(ms: Double) {
        self.fps = ms / 0.3048
    }
}
