//
//  RouteFinderView.swift
//  iosApp
//
//  Created by Akashaka on 08/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import shared
import SwiftUI

struct RouteFinderView: View {
    @State var startingPoint: LocationPoint?
    @State private var isShowingStartLocationPicker = false
    @State private var isShowingDestinationLocationPicker = false
    @State private var selectedTimeFrom: Date = .init()
    @State var destinationPoint: LocationPoint?
    @State var selectedRoute = [String]()
    @StateObject private var locationViewModel = LocationViewModel.shared
    @ObservedObject private var viewmodel = HomeObservableObject.shared
    @State private var isDetailVisible = false
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                VStack {
                    HStack {
                        VStack {
                            Image("circle.position")
                                .foregroundColor(.blue)
                            Image(systemName: "ellipsis")
                                .rotationEffect(
                                    Angle(degrees: 90)
                                )
                                .padding(.vertical, 8)
                                .padding(.horizontal)
                            Image("place.position")
                        }
                        VStack {
                            Button(action: {
                                isShowingStartLocationPicker = true
                            }) {
                                if !(startingPoint == nil) {
                                    Text(startingPoint!.placeName)
                                } else {
                                    Text("Your Location")
                                }
                            }.frame(maxWidth: .infinity).padding(10)
                                .overlay(RoundedRectangle(cornerRadius: 16)
                                    .stroke(.blue, lineWidth: 2)
                                )
                                .padding(.horizontal, 10)
                                .fullScreenCover(isPresented: $isShowingStartLocationPicker) {
                                    LocationPickerView(
                                        pickedLocation: $startingPoint
                                    )
                                }
                            Spacer().frame(maxHeight: 16)
                            Button(action: {
                                isShowingDestinationLocationPicker = true
                            }) {
                                if !(destinationPoint == nil) {
                                    Text(destinationPoint!.placeName)
                                } else {
                                    Text("Destination Location")
                                }
                            }.frame(maxWidth: .infinity)
                                .padding(10)
                                .overlay(RoundedRectangle(cornerRadius: 16)
                                    .stroke(.blue, lineWidth: 2)
                                )
                                .padding(.horizontal, 10)
                                .fullScreenCover(isPresented: $isShowingDestinationLocationPicker) {
                                    LocationPickerView(
                                        pickedLocation: $destinationPoint
                                    )
                                }
                        }
                    }
                    HStack {
                        VStack {
                            Text("Dari jam :   ")
                            DatePicker("", selection: $selectedTimeFrom, displayedComponents: .hourAndMinute).labelsHidden()
                        }.padding(.leading, 16)
                        Spacer()
                        Button(action: {
                            if let start = startingPoint,
                               let destination = destinationPoint
                            {
                                print("\(startingPoint) \(destinationPoint)")
                                if let graph = viewmodel.graphState.data {
                                    print(
                                        "nearest \(graph.findNearestStation(lat: start.latitude, lng: start.longitude))"
                                    )
                                    print(
                                        "nearest \(graph.findNearestStation(lat: destination.latitude, lng: destination.longitude))"
                                    )
                                }
                                viewmodel.findRouteByLocation(
                                    start: start,
                                    destination: destination,
                                    departTime: selectedTimeFrom.asFormattedTime
                                )
                            } else {
                                print("\(startingPoint) \(destinationPoint)")
                            }
                        }) {
                            if !(startingPoint != nil && destinationPoint != nil) {
                                HStack {
                                    Spacer().frame(minWidth: 8, maxWidth: 8)
                                    Text("Cari")
                                    Spacer().frame(minWidth: 16, maxWidth: 16)
                                    Image(systemName: "magnifyingglass")
                                    Spacer().frame(minWidth: 8, maxWidth: 8)
                                }.padding(8).background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.blue, lineWidth: 2)
                                    //              .background(Color.white)
                                ).foregroundColor(.blue)
                            } else {
                                HStack {
                                    Spacer().frame(minWidth: 8, maxWidth: 8)
                                    Text("Cari")
                                    Spacer().frame(minWidth: 16, maxWidth: 16)
                                    Image(systemName: "magnifyingglass")
                                    Spacer().frame(minWidth: 8, maxWidth: 8)
                                }.padding(8).background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.blue)
                                    //
                                ).foregroundColor(.white)
                            }
                        }
                    }.padding(.top, 8)
                }.padding()
                if viewmodel.routeState is AppStateLoading<Route> {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                if viewmodel.routeState is AppStateError<Route> {
                    if let errorMessage = viewmodel.routeState.message {
                        VStack {
                            Spacer()
                            Text(errorMessage)
                            Spacer()
                        }
                    }
                }
                if let routeResult = viewmodel.routeState.data {
                    let simpleRoutes = routeResult.getSimpleRoutes()
                    List(simpleRoutes, id: \.indices) { route in

                        let steps = route.map { station -> Step in
                            if station == route.first {
                                return Step(
                                    title: station.stationName,
                                    subtitle: "Departure",
                                    color: .yellow
                                )
                            } else if station == route.last {
                                return Step(
                                    title: station.stationName,
                                    subtitle: "Arrival",
                                    color: .yellow
                                )
                            } else {
                                return Step(
                                    title: station.stationName,
                                    subtitle: "Transit",
                                    color: .yellow
                                )
                            }
                        }
                        let index = simpleRoutes.firstIndex(of: route) ?? 0

                        if route == simpleRoutes.first {
                            Text("Rekomendasi")
                        }

                        RouteItemCard(steps: steps) {
                            selectedRoute = routeResult.routes[index]
                                .map { station in
                                    station.stationId
                                }
                            viewmodel.loadRouteSchedule(
                                routes: selectedRoute,
                                timeFrom: selectedTimeFrom.asFormattedTime
                            )
                            isDetailVisible = true
                        }
                        if route == simpleRoutes.first {
                            Text("Rute Alternatif")
                        }
                    }
                    HStack {
                        Spacer()
                        Text("Biaya Perjalanan")
                        Spacer()
                        Text(formatCurrency(routeResult.fare)).font(.title2)
                        Spacer()
                    }.sheet(isPresented: $isDetailVisible) {
                        VStack {
                            DragIndicator().padding()
                            RouteScheduleView(
                                route: selectedRoute,
                                fare: routeResult.fare
                            )
                        }
                    }
                }
                //        List(){
                //          let steps: [Step] = [
                //            Step(title: "Rangkasbitung", subtitle: "Departure", color: .blue),
                //            Step(title: "Tanah Abang", subtitle: "Change trains", color: .yellow),
                //            Step(title: "Bekasi", subtitle: "Change trains", color: .yellow),
                //            Step(title: "Cikarang", subtitle: "Change trains", color: .yellow)
                //          ]
                //          Text("Rekomendasi")
                //          RouteItemCard(steps: steps)
                //          let steps2: [Step] = [
                //            Step(title: "Rangkasbitung", subtitle: "Departure", color: .blue),
                //            Step(title: "Tanah Abang", subtitle: "Change trains", color: .yellow),
                //            Step(title: "Bekasi", subtitle: "Change trains", color: .yellow),
                //            Step(title: "Cikarang", subtitle: "Change trains", color: .yellow)
                //          ]
                //          Text("Rute Alternatif")
                //          RouteItemCard(steps: steps2)
                //        }
                //        HStack{
                //          Spacer()
                //          Text("Biaya Perjalanan")
                ////          Spacer()
                //
                //          Spacer()
                //          Text("Rp.19.000").font(.title2)
                //          Spacer()
                //        }

            }.onAppear {
                locationViewModel.requestLocation()
            }

        }.preferredColorScheme(.light)
        //      .accentColor(Color.flatWhiteBackground)
    }
}

struct RouteFinderView_Previews: PreviewProvider {
    static var previews: some View {
        RouteFinderView()
    }
}
