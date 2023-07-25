//
//  Test5View.swift
//  iosApp
//
//  Created by Akashaka on 12/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import MapKit
import SwiftUI

struct TLocationSearchView: View {
    @State private var searchQuery = ""
    @State private var searchResults: [MKMapItem] = []

    var body: some View {
        VStack {
            TSearchBarView(searchQuery: $searchQuery, onSearch: searchLocations)
                .padding(.horizontal)

            List(searchResults.indices, id: \.self) { index in
                let item = searchResults[index]
                let selectedItem = item.placemark
                VStack(alignment: .leading) {
                    Text(searchResults[index].name ?? "")
                        .font(.headline)
                    Text("\(selectedItem.thoroughfare ?? ""), \(selectedItem.locality ?? ""), \(selectedItem.subLocality ?? ""), \(selectedItem.administrativeArea ?? ""), \(selectedItem.postalCode ?? ""), \(selectedItem.country ?? "")")
                        .font(.subheadline)
                }
                .onTapGesture {
                    // Handle the selection of a location
                    let selectedLocation = LocationPoint(
                        latitude: selectedItem.coordinate.latitude,
                        longitude: selectedItem.coordinate.longitude,
                        placeName: item.name ?? ""
                    )
                    print("Selected Location: \(selectedLocation)")
                }
            }
            .listStyle(GroupedListStyle())
        }
        .navigationBarTitle("Location Search")
    }

    private func searchLocations() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response, error == nil else {
                // Handle the error
                return
            }

            searchResults = response.mapItems
        }
    }
}

struct TSearchBarView: View {
    @Binding var searchQuery: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search", text: $searchQuery, onCommit: {
                onSearch()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                onSearch()
            }) {
                Image(systemName: "magnifyingglass")
                    .padding(.trailing, 8)
            }
        }
    }
}

struct TLocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TLocationSearchView()
        }
    }
}
