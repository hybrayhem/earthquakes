//
//  QuakeClient.swift
//  Earthquakes
//
//  Created by hybrayhem.
//

import Foundation

actor QuakeClient { // Making QuakeClient an actor protects the cache from simultaneous access from multiple threads.
    private let quakeCache: NSCache<NSString, CacheEntryObject> = NSCache()
    
    private lazy var decoder: JSONDecoder = {
        let aDecoder = JSONDecoder()
        aDecoder.dateDecodingStrategy = .millisecondsSince1970 // anonymous closure to init with strategy change
        return aDecoder
    }()

    private let feedURL = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson")!

    private let downloader: any HTTPDataDownloader
    
    var quakes: [Quake] {
        get async throws {
            let data = try await downloader.httpData(from: feedURL)
            let allQuakes = try decoder.decode(GeoJSON.self, from: data)
            
            var updatedQuakes = allQuakes.quakes
            try await updateQuakeLocations(&updatedQuakes, allQuakes)
            
            return updatedQuakes
        }
    }

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
    
    func updateQuakeLocations(_ updatedQuakes: inout [Quake], _ allQuakes: GeoJSON) async throws {
        let olderThanOneHour = updatedQuakes.firstIndex(where: {  $0.time.timeIntervalSinceNow > 3600 })
        
        if let olderThanOneHour {
            let indexRange = updatedQuakes.startIndex..<olderThanOneHour
            
            try await withThrowingTaskGroup(of: (Int, QuakeLocation).self) { group in
                
                for index in indexRange {
                    group.addTask {
                        // Part which will be executed
                        let location = try await self.quakeLocation(from: allQuakes.quakes[index].detail)
                        return (index, location)
                    }
                }
                
                while let result = await group.nextResult() {
                    // Evaulation of results
                    switch result {
                    case .failure(let error):
                        throw error
                    case .success(let (index, location)):
                        updatedQuakes[index].location = location
                    }
                }
                
            }
        }
    }
}
