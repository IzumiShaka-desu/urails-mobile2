//
//  TestTimelineJir.swift
//  iosApp
//
//  Created by Akashaka on 07/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import shared
import SwiftUI

struct TestTimelineJir: View {
    @ObservedObject var viewmodel = HomeObservableObject.shared
    var body: some View {
        ZStack {
            if let stations = viewmodel.stationsState.data {
                let dummyRoute = GetRouteSchedule(routes: ["CKR", "MTM", "CIT", "TB", "BKST", "BKS", "KRI", "CUK", "KLDB", "BUA", "KLD", "JNG", "MTR", "MRI", "SUD", "SUDB", "KAT", "THB", "PLM", "KBY", "PDJ", "JMU", "SDM", "RU", "SRP", "CSK", "CC", "PRP", "CJT", "DAR", "TEJ", "TGS", "CKY", "MJ", "CTR"], timeFrom: "10:11")
                TimelineRouteSchedulePage(
                    routeSchedules: dummyRoute.getDummyData(),
                    fare:19000,
                    route: dummyRoute.routes
                )
            }
            if viewmodel.stationsState is AppStateLoading<StationList> {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else {
                if let message = viewmodel.stationsState.message {
                    Text(message)
                }
            }
        }
    }
}

struct TestTimelineJir_Previews: PreviewProvider {
    static var previews: some View {
        TestTimelineJir()
    }
}
