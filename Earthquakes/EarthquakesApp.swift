//
//  EarthquakesApp.swift
//  Earthquakes
//
//  The app and main window group scene.
//

import SwiftUI

@main
struct EarthquakesApp: App {
    @StateObject var quakesProvider = QuakesProvider()
    
    var body: some Scene {
        WindowGroup {
            Quakes()
                .environmentObject(quakesProvider)
        }
    }
}
