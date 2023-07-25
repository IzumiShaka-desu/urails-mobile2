//
//  MapTabView.swift
//  iosApp
//
//  Created by Akashaka on 03/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import MapKit
import shared
import SwiftUI

struct MapTabView: View {
    @Binding var graphState: AppState<Graph>
    @State var isImageView = false
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

    var body: some View {
        ZStack {
            if !isImageView {
                if let graph = graphState.data {
                    MapPage(graph: graph)
                } else {
                    MapPage(graph: nil)
                }
            } else {
                MapsImageView()
            }

            HStack {
                VStack {
                    HStack {
                        VStack {
                            Image(systemName: "photo").padding(4)
                                .foregroundColor(isImageView ? .blue : .gray)
                            //              Text("image")
                        }.onTapGesture {
                            isImageView = true
                        }

                        Text("|")
                        VStack {
                            Image(systemName: "map").padding(4)
                                .foregroundColor(!isImageView ? .blue : .gray)
                            //              Text("map")
                        }.onTapGesture {
                            isImageView = false
                        }
                    }.padding().background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 4)
                    Spacer()
                }.padding(.top, 0)
                Spacer()
            }.padding()
        }
    }
}

struct MapPage: View {
    @State private var annotations = [MKAnnotation]()
    @State private var polylines = [MKPolyline]()
    @State private var userTrackingMode: MKUserTrackingMode = .follow
    @State private var zoomLevel: Double = 0.002
    let initialRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -6.2088, longitude: 106.8456), span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
    let graph: Graph?
    var body: some View {
        CustomMapView(
            annotations: $annotations,
            polylines: $polylines,
            userTrackingMode: $userTrackingMode,
            zoomLevel: $zoomLevel,
            initialRegion: initialRegion
        ).edgesIgnoringSafeArea(.all)
            .onAppear {
                if let graph = graph {
                    annotations.append(
                        contentsOf: graph.stations.map { station in
                            CustomAnnotation(
                                coordinate: CLLocationCoordinate2D(
                                    latitude: station.latitude,
                                    longitude: station.longitude
                                ),
                                image: "icon_station_circle",
                                placeName: station.stationName
                            )
                        }
                    )
                    polylines.append(
                        contentsOf: graph.generatePolylines()
                    )
                }
            }
    }
}

struct MapTabView_Previews: PreviewProvider {
    static var previews: some View {
        @ObservedObject var viewModel = HomeObservableObject.shared
        MapTabView(graphState: $viewModel.graphState)
    }
}
