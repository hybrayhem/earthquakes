//
//  EarthquakesTests.swift
//  EarthquakesTests
//
//  Created by hybrayhem.
//

import XCTest
@testable import Earthquakes

final class EarthquakesTests: XCTestCase {
    
    func testGeoJSONDecoderDecodesQuake() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970
        
        let quake = try decoder.decode(Quake.self, from: testFeature_nc73649170)

        // Code
        XCTAssertEqual(quake.code, "73649170")
        
        // Seconds
        let expectedSeconds = TimeInterval(1636129710550) / 1000
        let decodedSeconds = quake.time.timeIntervalSince1970
        XCTAssertEqual(expectedSeconds, decodedSeconds, accuracy: 0.00001)
    }
    
}
