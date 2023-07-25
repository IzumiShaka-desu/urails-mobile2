//
//  Test7View.swift
//  iosApp
//
//  Created by Akashaka on 13/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import CoreLocation
import MapKit
import SwiftUI

struct LocationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct MapViewWithAnnotations: View {
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 0,
            longitude: 0
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.2,
            longitudeDelta: 0.2
        )
    )
    @State private var annotations: [LocationAnnotation] = []

    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, annotationItems: annotations) { annotation in
                MapAnnotation(coordinate: annotation.coordinate) {
                    Image("place")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            }.overlay(
                Image("place.position")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .offset(x: 0, y: 13)
            )

            VStack {
                Spacer()

                HStack {
                    Button(action: {
                        guard let marker = annotations.first else { return }
                        withAnimation {
                            mapRegion = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(
                                    latitude: marker.coordinate.latitude,
                                    longitude: marker.coordinate.longitude
                                ),
                                span: MKCoordinateSpan(
                                    latitudeDelta: 0.5,
                                    longitudeDelta: 0.5
                                )
                            )
                        }

                    }) {
                        Text("center").font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    Spacer()

                    Button(action: {
                        // Tambahkan lokasi baru ke daftar anotasi
                        let newLocation = LocationAnnotation(coordinate: mapRegion.center)
                        //                        annotations.append(newLocation)
                        annotations = [newLocation]

                    }) {
                        Text("Pick This Location")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 16)
            }
        }
        .ignoresSafeArea()
        .onAppear {
            // Set lokasi awal ke lokasi pengguna terakhir
            // Jika tersedia, Anda dapat menggunakan data lokasi pengguna yang disimpan sebelumnya
            mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        }
    }
}

struct MapViewWithAnnotations_Previews: PreviewProvider {
    static var previews: some View {
        MapViewWithAnnotations()
    }
}
