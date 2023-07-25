//
//  LocationPickerView.swift
//  iosApp
//
//  Created by Akashaka on 15/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import CoreLocation
import MapKit
import SwiftUI

struct LocationPickerView: View {
    @Binding var pickedLocation: LocationPoint?
    @Environment(\.presentationMode) var presentationMode
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: -6.200000,
            longitude: 106.816666
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.1,
            longitudeDelta: 0.1
        )
    )
    @State private var annotations: [LocationAnnotation] = []
    @State private var isShowingSearchView = false
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: annotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    Image("place")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(.bottom, 22)
                }
            }.overlay(
                Image("place.position")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .offset(x: 0, y: 0)
            ).ignoresSafeArea()

            VStack {
                Button(action: {
                    isShowingSearchView = true
                }) {
                    HStack {
                        Image("place")
                        Spacer()
                        Text("Search Here")
                        Spacer()
                        Image(systemName: "magnifyingglass")
                    }.frame(maxWidth: .infinity)
                        .foregroundColor(colorScheme == .dark ? .white : .gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            colorScheme == .dark ? Color.flatDarkCardBackground : Color.flatWhiteBackground
                        )
                        .cornerRadius(16)
                        .shadow(
                            color: Color.black.opacity(1),
                            radius: 4,
                            x: 0, y: 4
                        )
                }
                .padding().fullScreenCover(isPresented: $isShowingSearchView) {
                    LocationSearchView(mapRegion: $mapRegion)
                }
                Spacer()
                // Mapn Zoom out button
                HStack {
                    Spacer()
                    VStack {
                        Button("-") {
                            withAnimation {
                                mapRegion.span.latitudeDelta /= 0.6
                                mapRegion.span.longitudeDelta /= 0.6
                            }
                        }
                        .padding()

                        // Map Zoom in button
                        Button("+") {
                            withAnimation {
                                mapRegion.span.latitudeDelta *= 0.6
                                mapRegion.span.longitudeDelta *= 0.6
                            }
                        }
                        .padding()
                    }.background(Color.black.opacity(0.6))
                        .foregroundColor(.white)

                }.padding()
                HStack {
                    Spacer()
                    Button(action: {
                        // Tambahkan lokasi baru ke daftar anotasi
                        let newLocation = LocationAnnotation(coordinate: mapRegion.center)
                        //                        annotations.append(newLocation)
                        annotations = [newLocation]
                        LocationViewModel.shared.getPlaceNameFromLocation(
                            location: CLLocation(
                                latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude
                            )
                        ) { placeNameOrStreet in
                            if let placeNameOrStreet = placeNameOrStreet {
                                print("Place Name or Nearest Street: \(placeNameOrStreet)")
                                pickedLocation = LocationPoint(
                                    latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude, placeName: placeNameOrStreet
                                )
                            } else {
                                print("Failed to get place name or nearest street.")
                                pickedLocation = LocationPoint(
                                    latitude: newLocation.coordinate.latitude,
                                    longitude: newLocation.coordinate.longitude,
                                    placeName: " "
                                )
                            }
                            presentationMode.wrappedValue.dismiss()
                        }

                    }) {
                        Text("Pick This Location")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
        }

        .onAppear {
            // Set lokasi awal ke lokasi pengguna terakhir
            // Jika tersedia, Anda dapat menggunakan data lokasi pengguna yang disimpan sebelumnya
            guard let location = pickedLocation else { return }
            withAnimation {
                mapRegion = MKCoordinateRegion(
                    center: CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    ),
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.1,
                        longitudeDelta: 0.1
                    )
                )
            }
        }
    }
}

struct TestContentView: View {
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
            LocationPickerView(pickedLocation: $pickedLocation)
        }
    }
}

struct LocationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        TestContentView()
    }
}
