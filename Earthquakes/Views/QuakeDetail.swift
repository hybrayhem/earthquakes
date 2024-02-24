//
//  QuakeDetail.swift
//  Earthquakes
//
//  Created by hybrayhem.
//

import SwiftUI

struct QuakeDetail: View {
    var quake: Quake
    @EnvironmentObject private var quakesProvider: QuakesProvider
    @State private var location: QuakeLocation? = nil

    @State var limitFraction: Bool = true
    
    var body: some View {
        VStack {
            if let location = self.location {
                QuakeDetailMap(location: location, tintColor: quake.color)
                    .ignoresSafeArea(.container)
            }
            
            QuakeMagnitude(quake: quake)
            
            Text(quake.place)
                .font(.title3)
                .bold()
            
            Text("\(quake.time.formatted())")
                .foregroundStyle(Color.secondary)
            
            if let location = quake.location {
                Group {
                    Text("Latitude: \(latitudeText(location))")
                    Text("Longitude: \(longitudeText(location))")
                }.onTapGesture {
                    limitFraction.toggle()
                }
            }
        }
        .task {
            if self.location == nil {
                if let quakeLocation = quake.location {
                    self.location = quakeLocation
                } else {
                    self.location = try? await quakesProvider.location(for: quake)
                }
            }
        }
    }
    
    private func latitudeText(_ location: QuakeLocation) -> String {
        return limitFraction ? fraction3(location.latitude) : String(location.latitude)
    }
    
    private func longitudeText(_ location: QuakeLocation) -> String {
        return limitFraction ? fraction3(location.longitude) : String(location.longitude)
    }
    
    private func fraction3(_ number: Double) -> String {
        return number.formatted(.number.precision(.fractionLength(3)))
    }
}

#Preview {
    QuakeDetail(quake: Quake.preview)
}
