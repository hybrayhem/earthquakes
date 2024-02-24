//
//  Quake.swift
//  Earthquakes
//
//  A structure for representing quake data.
//

import Foundation

struct Quake {
    let magnitude: Double
    let place: String
    let time: Date
    let code: String
    let detail: URL
    var location: QuakeLocation?
}

extension Quake: Identifiable {
    var id: String { code }
}

extension Quake: Decodable {
    private enum CodingKeys: String, CodingKey {
        case magnitude = "mag"
        case place
        case time
        case code
        case detail
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawMagnitude = try? values.decode(Double.self, forKey: .magnitude)
        let rawPlace = try? values.decode(String.self, forKey: .place)
        let rawTime = try? values.decode(Date.self, forKey: .time)
        let rawCode = try? values.decode(String.self, forKey: .code)
        let rawDetail = try? values.decode(URL.self, forKey: .detail)
        
        guard let magnitude = rawMagnitude,
              let place = rawPlace,
              let time = rawTime,
              let code = rawCode,
              let detail = rawDetail
        else {
            throw QuakeError.missingData
        }
        
        self.magnitude = magnitude
        self.place = place
        self.time = time
        self.code = code
        self.detail = detail
    }
}

#if DEBUG
extension Quake {
    static let sampleData: [Quake] = [
        Quake(magnitude: 0.8,
              place: "Shakey Acres",
              time: Date(timeIntervalSinceNow: -1000),
              code: "nc73649170",
              detail: URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/nc73649170.geojson")!),
        Quake(magnitude: 2.2,
              place: "Rumble Alley",
              time: Date(timeIntervalSinceNow: -5000),
              code: "hv72783692",
              detail: URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/detail/hv72783692")!)
    ]
}
#endif
