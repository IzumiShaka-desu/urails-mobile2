//
//  TimelineRouteSchedulePage.swift
//  iosApp
//
//  Created by Akashaka on 04/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import shared
import SwiftUI

struct TimelineRouteSchedulePage: View {
    let routeSchedules: [RouteScheduleRaw]
    let fare:Int32
    let route: [String]
    @ObservedObject var state = TimelineState.shared
    var body: some View {
        ZStack {
//        let txt=state.state.map{item in
//          return " \(item.kaId) : \(item.routeName)"
//        }
            let schedules = state.stateAsTimelineData
          ScrollView{
            VStack {
              HStack{
                Spacer()
                VStack{
                  Image(systemName:"clock")
                    .resizable()
                    .frame(width:32,height:32)
                    .padding(.bottom,8)
                  
                  Text(state.estimatedTime)
                }
                Spacer()
                VStack{
                  Image("idr.icon").scaleEffect(1.5)
                  //                    .resizable()
                  Text(formatCurrency(fare))
                }
                Spacer()
              }
              TimelineScheduleView(items: schedules)
            }
          }
//        VStack{
//          Text("\(state.state.count)")
//          List(txt,id: \.count){item in
//            Text(item)
//
//          }
//        }
        }.onAppear {
            state.replaceState(
                routeSchedules: routeSchedules,
                route: route
            )
        }
    }
}

struct TimelineRouteSchedulePage_Previews: PreviewProvider {
    static var previews: some View {
        let dummyRoute = GetRouteSchedule(routes: ["CKR", "MTM", "CIT", "TB", "BKST", "BKS", "KRI", "CUK", "KLDB", "BUA", "KLD", "JNG", "MTR", "MRI", "SUD", "SUDB", "KAT", "THB", "PLM", "KBY", "PDJ", "JMU", "SDM", "RU", "SRP", "CSK", "CC", "PRP", "CJT", "DAR", "TEJ", "TGS", "CKY", "MJ", "CTR"], timeFrom: "10:11")
      TimelineRouteSchedulePage(
        routeSchedules: dummyRoute.getDummyData(),
        fare:19000,
        route: dummyRoute.routes
      )
    }
}
