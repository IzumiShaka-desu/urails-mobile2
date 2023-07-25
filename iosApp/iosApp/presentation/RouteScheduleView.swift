//
//  RouteScheduleView.swift
//  iosApp
//
//  Created by Akashaka on 04/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import shared
import SwiftUI

struct RouteScheduleView: View {
    @ObservedObject var viewmodel = HomeObservableObject.shared
    let route: [String]
    let fare:Int32
    var body: some View {
        ZStack {
            if viewmodel.routeScheduleState is AppStateLoading {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
            if viewmodel.routeScheduleState is AppStateError {
                VStack {
                    Spacer()
                    Text(viewmodel.routeScheduleState.message ?? "Unknown Error")
                    Spacer()
                }
            }
            if let routeSchedules = viewmodel.routeScheduleState.data {
                if routeSchedules.routeSchedules.isEmpty {
                    VStack {
                        Spacer()
                        Text("jadwal tidak ditemukan")
                        Spacer()
                    }
                } else {
                    TimelineRouteSchedulePage(
                        routeSchedules: routeSchedules.routeSchedules,
                        fare: fare,
                        route: route
                    )
                }
            }
        }
    }
}

struct RouteScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        RouteScheduleView(route: [],fare: 19000)
    }
}
