//
//  GeoJSON.swift
//  EarthquakesTests
//
//  Created by hybrayhem.
//

import Foundation

struct GeoJSON: Decodable {

    private enum RootCodingKeys: String, CodingKey {
        case features
    }
    private enum FeatureCodingKeys: String, CodingKey {
        case properties
    }

    private(set) var quakes: [Quake] = []

    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootCodingKeys.self)
        var featuresContainer = try rootContainer.nestedUnkeyedContainer(forKey: .features) // returns as unkeyed

        while !featuresContainer.isAtEnd {
            let propertiesContainer = try featuresContainer.nestedContainer(keyedBy: FeatureCodingKeys.self)

            if let properties = try? propertiesContainer.decode(Quake.self, forKey: .properties) {
                quakes.append(properties)
            }
        }
    }
}

// Sample GeoJSON:
//     type:
//     metadata:
//     features:
//          0: properties, geometries
//          1: properties, geometries
//     bbox:
