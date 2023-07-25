//
//  SchedulessView.swift
//  iosApp
//
//  Created by Akashaka on 08/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

import SwiftUI

struct StationPicker: View {
    @State private var searchText = ""
    @State var isPopoverPresented: Bool
    @State private var selectedStation: String = ""

    var onChanged: (String?) -> Void
    var stations: [String]

    var body: some View {
        VStack {
            Button(action: {
                isPopoverPresented = true
            }) {
                if selectedStation.isEmpty {
                    HStack {
                        Image(systemName: "train.side.front.car")
                            .padding(.trailing, 8)
                        Text("Pilih Stasiun")
                            .foregroundColor(.blue).frame(maxWidth: .infinity)
                        Image(systemName: "magnifyingglass.circle.fill")
                            .padding(.leading, 8)
                    }
                    .padding().frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 2)
                        //              .background(Color.white)
                    )

                } else {
                    HStack {
                        Image(systemName: "train.side.front.car")
                            .padding(.trailing, 8)
                        Text(selectedStation)
                            .foregroundColor(.blue).frame(maxWidth: .infinity)
                        Image(systemName: "magnifyingglass.circle.fill")
                            .padding(.leading, 8)
                    }
                    .padding().frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 2)
                        //              .background(Color.white)
                    )
                }
            }.buttonStyle(PlainButtonStyle())
                .frame(maxWidth: .infinity)

            if isPopoverPresented {
                popoverContent
                    .popover(isPresented: $isPopoverPresented, content: {
                        popoverContent
                    })
                    .frame(maxHeight: 200)
            }
        }.frame(maxWidth: .infinity)
            .padding()
    }

    private var popoverContent: some View {
        VStack {
            VStack {
                TextField("Pilih Stasiun", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .ignoresSafeArea(.keyboard)
            }.padding(8)
            List {
                ForEach(filteredStations, id: \.self) { station in
                    Button(action: {
                        selectedStation = station
                        onChanged(station)
                        isPopoverPresented = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Text(station)
                    }
                }
            }
        }
    }

    private var filteredStations: [String] {
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
}

struct StationPickerPreviews: PreviewProvider {
    static var previews: some View {
        let stations = ["Stasiun A", "Stasiun B", "Stasiun C", "Stasiun D", "Stasiun E", "Stasiun f"]
        @State var isPoppoverActive = false
        StationPicker(
            isPopoverPresented: isPoppoverActive, onChanged: { _ in
            }, stations: stations
        )
    }
}
