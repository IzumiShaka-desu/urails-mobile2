//
//  Test3View.swift
//  iosApp
//
//  Created by Akashaka on 11/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import MapKit
import SwiftUI

struct LocationCoordinateWrapper: Equatable, Identifiable {
    let coordinate: CLLocationCoordinate2D
    let id = UUID()
    static func == (lhs: LocationCoordinateWrapper, rhs: LocationCoordinateWrapper) -> Bool {
        return lhs.coordinate.latitude == rhs.coordinate.latitude && lhs.coordinate.longitude == rhs.coordinate.longitude
    }
}

struct T3LocationPickerView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    @State private var searchQuery = ""
    @State private var selectedLocation: LocationPoint?
    @State private var selectedCoordinate: LocationCoordinateWrapper?
    @State private var showSearchResults = false
    @State private var searchResults: [MKMapItem] = []

    var body: some View {
        VStack {
            if showSearchResults {
                SearchResultsView(searchQuery: $searchQuery, searchResults: $searchResults, selectLocation: selectLocation)
            } else {
                Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true, annotationItems: [selectedCoordinate].compactMap { $0 }) { coordinateWrapper in
                    MapMarker(coordinate: coordinateWrapper.coordinate, tint: .red)
                }
                .ignoresSafeArea(edges: .bottom)
            }

            Button(action: {
                if let location = selectedLocation {
                    // Handle the selected location
                    // For this example, we'll print the selected location
                    print(location)
                }
            }) {
                Text("Pick This Location")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .padding()
        }
        .navigationBarTitle("Pick Location")
        .onAppear {
            // Update the map's region to user's current location
            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: region.center.latitude, longitude: region.center.longitude), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        }
        .onChange(of: selectedCoordinate) { coordinateWrapper in
            if let coordinateWrapper = coordinateWrapper {
                region = MKCoordinateRegion(center: coordinateWrapper.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
            }
        }
    }

    func selectLocation(mapItem: MKMapItem) {
        selectedLocation = LocationPoint(latitude: mapItem.placemark.coordinate.latitude, longitude: mapItem.placemark.coordinate.longitude, placeName: mapItem.placemark.name ?? "")
        selectedCoordinate = LocationCoordinateWrapper(coordinate: mapItem.placemark.coordinate)
        showSearchResults = false
    }
}

struct SearchResultsView: View {
    @Binding var searchQuery: String
    @Binding var searchResults: [MKMapItem]
    let selectLocation: (MKMapItem) -> Void

    var body: some View {
        VStack {
            TextField("Search", text: $searchQuery, onCommit: {
                UIApplication.shared.endEditing()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)

            List(searchResults, id: \.self) { mapItem in
                Text(mapItem.placemark.name ?? "")
                    .onTapGesture {
                        selectLocation(mapItem)
                    }
            }
            .listStyle(PlainListStyle())
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// struct LocationPoint {
//    let latitude: Double
//    let longitude: Double
//    let placeName: String
// }

struct TT2ContentView: View {
    @State private var isPresentingLocationPicker = false

    var body: some View {
        NavigationView {
            VStack {
                Text("Selected Location: ")
                    .font(.headline)

                Button(action: {
                    isPresentingLocationPicker = true
                }) {
                    Text("Select Location")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .font(.headline)
                }
                .padding()
            }
            .sheet(isPresented: $isPresentingLocationPicker) {
                T3LocationPickerView()
            }
            .navigationBarTitle("Location Picker")
        }
    }
}

struct TT2ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TT2ContentView()
    }
}
