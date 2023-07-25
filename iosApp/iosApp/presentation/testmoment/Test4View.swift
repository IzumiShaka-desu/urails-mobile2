//
//  Test4View.swift
//  iosApp
//
//  Created by Akashaka on 12/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import CoreLocation
import SwiftUI

struct T5ContentView: View {
    @State private var isShowingLocationPicker = false
    @State private var pickedLocation: LocationPoint? = nil

    var body: some View {
        VStack {
            if let location = pickedLocation {
                Text("Picked Location: \(location.latitude), \(location.longitude)")
            } else {
                Text("No location picked")
            }

            Button(action: {
                isShowingLocationPicker = true
            }) {
                Text("Pick Location")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .sheet(isPresented: $isShowingLocationPicker) {
                T5LocationPickerView(pickedLocation: $pickedLocation)
            }
        }
        .padding()
    }
}

struct T5LocationPickerView: View {
    @Binding var pickedLocation: LocationPoint?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Text("Location Picker")
                .font(.headline)

            Button(action: {
                // Simulate picking a location
                let location = LocationPoint(latitude: 37.7749, longitude: -122.4194, placeName: "San Francisco")
                pickedLocation = location
                presentationMode.wrappedValue.dismiss() // Kembali ke halaman sebelumnya
            }) {
                Text("Pick This Location")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .padding()
    }
}

struct T4LocationPickerView: View {
    @Binding var pickedLocation: LocationPoint?
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Text("Location Picker")
                .font(.headline)

            Button(action: {
                // Simulate picking a location
                let location = LocationPoint(latitude: 37.7749, longitude: -122.4194, placeName: "San Francisco")
                pickedLocation = location
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Pick This Location")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .padding()
    }
}

struct T4ContentView: View {
    @State private var isShowingLocationPicker = false
    @State private var pickedLocation: LocationPoint? = nil

    var body: some View {
        VStack {
            if let location = pickedLocation {
                Text("Picked Location: \(location.latitude), \(location.longitude)")
            } else {
                Text("No location picked")
            }

            Button(action: {
                isShowingLocationPicker = true
            }) {
                Text("Pick Location")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .padding()
        .fullScreenCover(isPresented: $isShowingLocationPicker) {
            T4LocationPickerView(pickedLocation: $pickedLocation)
        }
    }
}

struct T5ContentView_Previews: PreviewProvider {
    static var previews: some View {
//    T5ContentView()
        T4ContentView()
    }
}
