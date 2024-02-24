//
//  Quake+Preview.swift
//  Earthquakes
//
//  Created by hybrayhem.
//

import Foundation

extension Quake {
    static var preview: Quake {
        var quake = Quake(
            magnitude: 0.34,
            place: "Shakey Acres",
            time: Date(timeIntervalSinceNow: -1000),
            code: "nc73649170",
            detail: URL(string: "https://example.com")!
        )
        quake.location = QuakeLocation(latitude: 38.809_333_8, longitude: -122.796_836_9)
        return quake
    }
}
