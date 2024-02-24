//
//  QuakeClient.swift
//  Earthquakes
//
//  Created by hybrayhem.
//

import Foundation

actor QuakeClient { // Making QuakeClient an actor protects the cache from simultaneous access from multiple threads.
    private let quakeCache: NSCache<NSString, CacheEntryObject> = NSCache()
    
    var quakes: [Quake] {
        get async throws {
            let data = try await downloader.httpData(from: feedURL)
            let allQuakes = try decoder.decode(GeoJSON.self, from: data)
            return allQuakes.quakes
        }
    }

    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .millisecondsSince1970 // anonymous closure to init with strategy change
        return aDecoder
    }()

    private let feedURL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")!

    private let downloader: any HTTPDataDownloader

    init(downloader: any HTTPDataDownloader = URLSession.shared) {
        self.downloader = downloader
    }
    
    func quakeLocation(from url: URL) async throws -> QuakeLocation {
        if let cached = quakeCache[url] {
            switch cached {
            case .ready(let location):
                return location
            case .inProgress(let task):
                return try await task.value // dont make a new request, if url already cached
            }
        }
        
        // define location fetching task
        let task = Task<QuakeLocation, Error> {
            let data = try await downloader.httpData(from: url)
            let location = try decoder.decode(QuakeLocation.self, from: data)
            return location
        }
        
        // add task to cache, like queue
        quakeCache[url] = .inProgress(task)
        
        do {
            // wait for fetch
            let location = try await task.value
            
            // fetch done, store and return location
            quakeCache[url] = .ready(location)
            return location
            
        } catch {
            // remove task from cache
            quakeCache[url] = nil
            throw error
        }
    }
}
