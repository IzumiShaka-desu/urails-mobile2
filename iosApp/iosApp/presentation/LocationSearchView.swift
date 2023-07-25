//
//  SearchLocation.swift
//  iosApp
//
//  Created by Akashaka on 15/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import MapKit
import SwiftUI

struct LocationSearchView: View {
    @State private var searchQuery = ""
    @State private var searchResults: [MKMapItem] = []
    @State private var isLoading = false
    @Environment(\.presentationMode) var presentationMode
    @Binding var mapRegion: MKCoordinateRegion

    var body: some View {
        VStack {
            SearchBarView(
              searchQuery: $searchQuery,
              onSearch: searchLocations,
              onBack: {
                presentationMode.wrappedValue.dismiss()
              }
            )
                .padding(.horizontal)

            if isLoading {
                List {
                    ProgressView() // Menampilkan indikator loading saat isLoading true
                        .padding()
                }

            } else {
                List(searchResults.indices, id: \.self) { index in
                    let item = searchResults[index]
                    let selectedItem = item.placemark
                    VStack(alignment: .leading) {
                        Text(searchResults[index].name ?? "")
                            .font(.headline)
                        Text(selectedLocationAddress(selectedItem: selectedItem)).font(.subheadline)
                        //            Text("\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")")
                        //              .font(.subheadline)
                    }
                    .onTapGesture {
                        // Handle the selection of a location
                        let selectedLocation = LocationPoint(
                            latitude: selectedItem.coordinate.latitude,
                            longitude: selectedItem.coordinate.longitude,
                            placeName: item.name ?? ""
                        )
                        print("Selected Location: \(selectedLocation)")
                        withAnimation {
                            mapRegion = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(
                                    latitude: selectedItem.coordinate.latitude,
                                    longitude: selectedItem.coordinate.longitude
                                ),
                                span: MKCoordinateSpan(
                                    latitudeDelta: 0.1 / 20,
                                    longitudeDelta: 0.1 / 20
                                )
                            )
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                //        .listStyle(GroupedListStyle())
            }
        }
        .navigationBarTitle("Location Search")
    }

    private func selectedLocationAddress(selectedItem: CLPlacemark) -> String {
        let addressComponents: [String?] = [
            selectedItem.thoroughfare,
            selectedItem.locality,
            selectedItem.subLocality,
            selectedItem.administrativeArea,
            selectedItem.postalCode,
            selectedItem.country,
        ]

        let filteredComponents = addressComponents.compactMap { $0 }
        let address = filteredComponents.joined(separator: ", ")

        return address
    }

    private func searchLocations() {
        guard !isLoading else {
            return // Menghindari pemanggilan pencarian jika sedang loading
        }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery

        let search = MKLocalSearch(request: request)
        isLoading = true // Mengatur isLoading menjadi true sebelum memulai pencarian
        search.start { response, error in
            isLoading = false // Mengatur isLoading menjadi false setelah pencarian selesai

            guard let response = response, error == nil else {
                // Handle the error
                return
            }

            searchResults = response.mapItems
        }
    }
}

struct SearchBarView: View {
    @Binding var searchQuery: String
    var onSearch: () -> Void
    var onBack: () -> Void

    @Environment(\.colorScheme) var colorScheme
    var body: some View {
      
        HStack{
          Button(action:onBack){
            Image(systemName:"chevron.left")
          }
          HStack {
         
            
              HStack {
                  Image("place")
                      .resizable()
                      .frame(width: 25, height: 25)
                  TextField("Search", text: $searchQuery, onCommit: {
                      if !searchQuery.isEmpty {
                          onSearch()
                      }
                  }).foregroundColor(.gray)
                      .padding(.horizontal)
                  //      .textFieldStyle(RoundedBorderTextFieldStyle())
                  if !searchQuery.isEmpty {
                      Button(action: {
                          searchQuery = ""
                      }) {
                          Image(systemName: "xmark.circle")
                              .padding(.trailing, 8)
                      }
                  }
                  Button(action: {
                      if !searchQuery.isEmpty {
                          onSearch()
                      }
                  }) {
                      Image(systemName: "magnifyingglass")
                          .padding(.trailing, 8)
                  }
              }.padding()
          }.frame(maxWidth: .infinity)
              .foregroundColor(colorScheme == .dark ? .white : .gray)
              .overlay(RoundedRectangle(cornerRadius: 16)
                  .stroke(.gray, lineWidth: 2)
              )
              .frame(maxWidth: .infinity)
              //      .background(
              //        colorScheme == .dark ? Color.flatDarkCardBackground : Color.flatWhiteBackground
              //      )
              .padding()
              .background(colorScheme == .dark ? Color.flatDarkCardBackground : Color.flatWhiteBackground)
              .cornerRadius(16)
      }
        }
}

struct TestSearchContentView: View {
    @State private var isShowingLocationPicker = false
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: -6.200000,
            longitude: 106.816666
        ),
        span: MKCoordinateSpan(
            latitudeDelta: 0.01,
            longitudeDelta: 0.01
        )
    )

    var body: some View {
        VStack {
            //      if let location = mapRegion {
            //        Text("Picked Location: \(location.center.latitude), \(location.center.longitude)")
            //      } else {
            //        Text("No location picked")
            //      }

            Text("Picked Location: \(mapRegion.center.latitude), \(mapRegion.center.longitude)")

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
            LocationSearchView(mapRegion: $mapRegion)
        }
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        TestSearchContentView()
    }
}
