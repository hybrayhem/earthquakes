//
//  QuakeDetailMap.swift
//  Earthquakes
//
//  Created by hybrayhem.
//

import MapKit
import SwiftUI

struct QuakeDetailMap: View {
    let location: QuakeLocation
    let tintColor: Color
    private var place: QuakePlace
    
    @State private var region = MKCoordinateRegion()
    
    init(location: QuakeLocation, tintColor: Color) {
        self.location = location
        self.tintColor = tintColor
        self.place = QuakePlace(location: location)
    }
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: [place]) { place in
            MapMarker(coordinate: place.location, tint: tintColor)
        }
        .onAppear {
            withAnimation {
                region.center = place.location
                region.span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 0.5)
            }
        }
    }
}

struct QuakePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    
    init(id: UUID = UUID(), location: QuakeLocation) {
        self.id = id
        self.location = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
    }
}

#Preview {
    let location = Quake.preview.location!
    return QuakeDetailMap(location: location, tintColor: .blue)
}
