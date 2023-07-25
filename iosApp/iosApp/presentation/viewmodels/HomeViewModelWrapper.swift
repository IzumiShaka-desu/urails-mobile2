//
//  HomeViewModelWrapper.swift
//  iosApp
//
//  Created by Akashaka on 01/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Combine
import Foundation
import shared

class HomeViewModelWrapper: ObservableObject {
    private let homeViewModel: HomeViewModel

    @Published var routeState: AppState<Route> = AppStateNoState()
    @Published var stationListState: AppState<StationList> = AppStateNoState()
    @Published var graphState: AppState<Graph> = AppStateNoState()

    private var cancellables = Set<AnyCancellable>()

    init(homeViewModel: HomeViewModel) {
        self.homeViewModel = homeViewModel

        homeViewModel.routeState
            .sink { [weak self] state in
                self?.routeState = state
            }
            .store(in: &cancellables)

        homeViewModel.routeScheduleState
            .sink { [weak self] state in
                self?.routeScheduleState = state
            }
            .store(in: &cancellables)

        homeViewModel.getStationList
            .sink { [weak self] state in
                self?.stationListState = state
            }
            .store(in: &cancellables)

        homeViewModel.getGraph
            .sink { [weak self] state in
                self?.graphState = state
            }
            .store(in: &cancellables)
    }

    func getScheduleSearch(stationId: String, timeFrom: String, timeTo: String) {
        homeViewModel.getScheduleSearch(stationId: stationId, timeFrom: timeFrom, timeTo: timeTo)
    }

    func setKaIdforDetailSchedule(kaId: String) {
        homeViewModel.setKaIdforDetailSchedule(kaId: kaId)
    }

    func setRouteSearch(originStationId: String, destinationStationId: String, departureTime: String) {
        homeViewModel.setRouteSearch(originStationId: originStationId, destinationStationId: destinationStationId, departureTime: departureTime)
    }

    func setRouteSchedule(routesId: [String], timeFrom: String) {
        homeViewModel.setRouteSchedule(routesId: routesId, timeFrom: timeFrom)
    }

    var getDetailSchedule: AnyPublisher<AppState<DetailSchedule>, Never> {
        homeViewModel.getDetailSchedule
            .eraseToAnyPublisher()
    }

    var getSchedule: AnyPublisher<AppState<Schedule>, Never> {
        homeViewModel.getSchedule
            .eraseToAnyPublisher()
    }

    var getRoute: AnyPublisher<AppState<Route>, Never> {
        homeViewModel.getRoute
            .eraseToAnyPublisher()
    }

    var getRouteSchedule: AnyPublisher<AppState<RouteSchedule>, Never> {
        homeViewModel.getRouteSchedule
            .eraseToAnyPublisher()
    }

    // Other methods and properties from HomeViewModel can be exposed here
}
