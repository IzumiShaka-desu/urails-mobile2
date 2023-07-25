//
//  ScheduleView.swift
//  iosApp
//
//  Created by Akashaka on 08/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import shared
import SwiftUI

struct ScheduleView: View {
    @ObservedObject var viewModel = HomeObservableObject.shared
    @State private var selectedStationIndex = -1
    @State private var stations = ["Stasiun A", "Stasiun B", "Stasiun C"]
    @State var isPoppoverActive = false
    private let oneHour: TimeInterval = 3600
    @State private var selectedTimeFrom: Date = .init()
    @State private var selectedTimeTo: Date = .init()
    @State private var searchText = ""
    @State private var errorToastIsVisible = false
    @State private var isDetailVisible = false

    init() {
        let currentDate = Date()
        selectedTimeFrom = currentDate
        // Menggunakan selectedTimeFrom yang sudah ditambah satu jam untuk menginisialisasi selectedTimeTo
        selectedTimeTo = currentDate.addingTimeInterval(3600) // Menambahkan 1 jam (3600 detik)
    }

    private var filteredStations: [String] {
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    if viewModel.stationsState is AppStateSuccess<StationList> {
                        StationPicker(isPopoverPresented: isPoppoverActive, onChanged: { selectedStation in
                            if !(selectedStation == nil) {
                                selectedStationIndex = viewModel.stationsStateStrings.firstIndex(of: selectedStation!) ?? -1
                            }
                        }, stations: viewModel.stationsStateStrings).frame(maxWidth: .infinity)
                    } else {
                        StationPicker(isPopoverPresented: isPoppoverActive, onChanged: { selectedStation in
                            if !(selectedStation == nil) {
                                selectedStationIndex = stations.firstIndex(of: selectedStation!) ?? -1
                            }
                        }, stations: []).frame(maxWidth: .infinity)
                    }

                    HStack {
                        Spacer()
                        VStack {
                            Text("Dari jam :    ")
                            DatePicker(
                                "",
                                selection: $selectedTimeFrom,
                                displayedComponents: .hourAndMinute
                            ).labelsHidden()
                                .onChange(of: selectedTimeFrom) { newValue in
                                    // Cek apakah selectedTimeFrom lebih besar dari selectedTimeTo
                                    if newValue > selectedTimeTo {
                                        // Geser selectedTimeTo satu jam lebih dari selectedTimeFrom
                                        selectedTimeTo = newValue.addingTimeInterval(3600)
                                    }
                                }
                        }
                        Spacer()
                        VStack {
                            Text("Sampai jam : ")
                            DatePicker(
                                "",
                                selection: $selectedTimeTo,
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                            .onChange(of: selectedTimeTo) { newValue in
                                // Cek apakah selectedTimeTo lebih kecil dari selectedTimeFrom
                                if newValue < selectedTimeFrom {
                                    // Geser selectedTimeFrom satu jam sebelum selectedTimeTo
                                    selectedTimeFrom = newValue.addingTimeInterval(-3600)
                                }
                            }
                        }
                        Spacer()
                    }
                    Button(action: {
                        print(selectedTimeFrom <= selectedTimeTo)
                        print(selectedStationIndex >= 0)
                        print(selectedStationIndex)
                        print(formattedTime(date: selectedTimeTo))
                        // Pemeriksaan validitas
                        if selectedStationIndex >= 0, selectedTimeFrom < selectedTimeTo {
                            print(viewModel.stationsIdState[selectedStationIndex])
                            // Aksi yang ingin dilakukan jika valid
                            viewModel.findSchedule(
                                stationId: viewModel.stationsIdState[selectedStationIndex],
                                timeFrom: formattedTime(date: selectedTimeFrom),
                                timeTo: formattedTime(date: selectedTimeTo)
                            )
                        } else {
                            // Menampilkan pesan Snackbar jika tidak valid
                            errorToastIsVisible = true
                        }
                    }) {
                        Spacer()
                        if !(selectedStationIndex >= 0 && (selectedTimeFrom < selectedTimeTo)) {
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
                        Spacer().frame(minWidth: 16, maxWidth: 16)
                    }.padding(8).alert(isPresented: $errorToastIsVisible) {
                        Alert(
                            title: Text("Warning"),
                            message: Text("silahkan isi form pencarian dengan valid"),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }.padding()
                // Tampilkan loading dialog jika dalam keadaan loading
                if viewModel.scheduleState is AppStateLoading<ScheduleList> {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }

                // List untuk menampilkan hasil pencarian jika dalam keadaan success
                if let scheduleList = viewModel.scheduleState.data {
                    List(scheduleList.schedules, id: \.kaId) { schedule in
                        ScheduleItem(schedule: schedule).onTapGesture {
                            viewModel.setKaIdDetailSchedule(
                                kaId: schedule.kaId
                            )
                            isDetailVisible = true
                        }
                    }.sheet(isPresented: $isDetailVisible) {
                        VStack {
                            DragIndicator().padding()
                            DetailSchedulePage()
                        }
                        //                       .presentationDetents([.medium, .large])
                    }
                }

                // Tampilkan pesan error jika dalam keadaan error
                if let errorMessage = viewModel.scheduleState.message {
                    VStack {
                        Spacer()
                        Text(errorMessage)
                        //                     .foregroundColor(.red)
                        Spacer()
                    }
                }
                // List untuk menampilkan hasil pencarian
                //        List() {
                //          // Tambahkan item-item dari hasil pencarian di sini
                //          let schedule = Schedule(kaId: "13:00", kaName: "234234", routeName: "ANGKE-BEKASI", stationName: "THB", stationId: "BKS", originId: "AK",destinationId : "Bekasi Line",   arrivalTime: "12:00", departureTime: "11:30")
                //          ScheduleItem(schedule: schedule)
                //          ScheduleItem(schedule: schedule)
                //          ScheduleItem(schedule: schedule)
                //        }
            }.frame(maxWidth: .infinity)

        }.frame(maxWidth: .infinity)
    }

    func formattedTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }

    func getIconName(kaName: String) -> String {
        switch kaName.lowercased() {
        case let name where name.contains("bekasi"):
            return "line.merah"
        case let name where name.contains("Bogor"):
            return "line.merah"
        case let name where name.contains("Tangerang"):
            return "line.biru"
        case let name where name.contains("Jatinegara"):
            return "line.kuning"
        case let name where name.contains("Rangkas"):
            return "line.coklat"
        case let name where name.contains("Parungpanjang"):
            return "line.pink"
        case let name where name.contains("Maja"):
            return "line.ungu"
        default:
            return "line.merah"
        }
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
