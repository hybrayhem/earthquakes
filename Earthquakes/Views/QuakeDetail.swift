//
//  QuakeDetail.swift
//  Earthquakes
//
//  Created by hybrayhem.
//

import SwiftUI

struct QuakeDetail: View {
    var quake: Quake
    
    @State var fractionLimit: Bool = true
    
    var body: some View {
        VStack {
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
                    fractionLimit.toggle()
                }
            }
        }
    }
    
    private func latitudeText(_ location: QuakeLocation) -> String {
        return fractionLimit ? fraction3(location.latitude) : String(location.latitude)
    }
    
    private func longitudeText(_ location: QuakeLocation) -> String {
        return fractionLimit ? fraction3(location.longitude) : String(location.longitude)
    }
    
    private func fraction3(_ number: Double) -> String {
        return number.formatted(.number.precision(.fractionLength(3)))
    }
}

#Preview {
    QuakeDetail(quake: Quake.preview)
}
