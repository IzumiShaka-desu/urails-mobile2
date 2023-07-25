//
//  HomeViewmodel.swift
//  iosApp
//
//  Created by Akashaka on 19/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Foundation
import shared

public class HomeObservableObject: ObservableObject {
    static let shared = GetComponents().getHomeViewModel().asObservableObject()
    var viewModel: HomeViewModel
    @Published var graphState: AppState<Graph> = AppStateNoState(message: "initial State")

    @Published var stationsState: AppState<StationList> = AppStateNoState(message: "initial State")
    var stationsStateStrings: [String] {
        return (stationsState.data?.stations ?? []).map { station in
            station.stationName
        }
    }

    var stationsIdState: [String] {
        return (stationsState.data?.stations ?? []).map { station in
            station.stationId
        }
    }

    @Published var detailScheduleState: AppState<DetailScheduleRaw> = AppStateNoState(message: "initial State")
    @Published var scheduleState: AppState<ScheduleList> = AppStateNoState(message: "initial State")
    @Published var routeState: AppState<Route> = AppStateNoState(message: "initial State")
    @Published var routeScheduleState: AppState<ListRouteScheduleRaw> = AppStateNoState(message: "initial State")

    init(wrapper: HomeViewModel) {
        viewModel = wrapper
        print("init")
        // get stations
        viewModel.getStationList.collect(collector: Collector<AppState<StationList>> { state in
            if let stationList = state.data {
                TimelineState.shared.stations = stationList.stations
            }
            self.stationsState = state
        }) { error in
            self.stationsState = AppStateError(error: error?.localizedDescription ?? "Unknown Error", data: nil)
        }
        // Map Feature
        viewModel.getGraph.collect(collector: Collector<AppState<Graph>> { state in
            self.graphState = state
        }) { error in
            self.graphState = AppStateError(error: error?.localizedDescription ?? "Unknown Error", data: nil)
        }

        // schedule feature
        viewModel.getSchedule.collect(collector: Collector<AppState<ScheduleList>> { state in
            self.scheduleState = state
            print(state)
        }) { error in
            print(error)
            self.scheduleState = AppStateError(error: error?.localizedDescription ?? "Unknown Error", data: nil)
        }
        viewModel.getDetailSchedule.collect(collector: Collector<AppState<DetailScheduleRaw>> { state in
            self.detailScheduleState = state
        }) { error in
            self.detailScheduleState = AppStateError(error: error?.localizedDescription ?? "Unknown Error", data: nil)
        }
        // route feature
        viewModel.getRoute.collect(collector: Collector<AppState<Route>> { state in
            if state is AppStateSuccess {
                print(state)
            }
            self.routeState = state
        }) { error in
            self.routeState = AppStateError(error: error?.localizedDescription ?? "Unknown Error", data: nil)
        }
        // route schedule feature
        viewModel.getRouteSchedule.collect(collector: Collector<AppState<ListRouteScheduleRaw>> { state in
            if state is AppStateSuccess {
                print(state)
            }
            self.routeScheduleState = state
        }) { error in
            self.routeScheduleState = AppStateError(error: error?.localizedDescription ?? "Unknown Error", data: nil)
        }
    }

    func findSchedule(stationId: String, timeFrom: String, timeTo: String) {
        viewModel.getScheduleSearch(stationId: stationId, timeFrom: timeFrom, timeTo: timeTo)
    }

    func setKaIdDetailSchedule(kaId: String) {
        viewModel.setKaIdforDetailSchedule(kaId: kaId)
    }

    func findRoute(originStationId: String, destinationStationId: String, departureTime: String) {
        viewModel.setRouteSearch(originStationId: originStationId, destinationStationId: destinationStationId, departureTime: departureTime)
    }

    func findRouteByLocation(start: LocationPoint, destination: LocationPoint, departTime: String) {
        viewModel.findRoute(originLat: start.latitude, originLng: start.longitude, destinationLat: destination.latitude, destinationLng: destination.longitude, departureTime: departTime)
    }

    func loadRouteSchedule(routes: [String], timeFrom: String) {
        print(routes)
        print(timeFrom)
        viewModel.setRouteSchedule(routesId: routes, timeFrom: timeFrom)
    }
}

public extension HomeViewModel {
    func asObservableObject() -> HomeObservableObject {
        return HomeObservableObject(wrapper: self)
    }
}
