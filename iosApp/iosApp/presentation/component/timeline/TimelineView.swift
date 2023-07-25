//
//  TimelineView.swift
//  iosApp
//
//  Created by Akashaka on 02/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct TimelineScheduleView: View {
    var items: [any TimelineItem]
    var body: some View {
        ScrollView{
            VStack(
                alignment: HorizontalAlignment.leading,
                spacing: 0
            ) {
                ForEach(items, id: \.id) { item in
                    if item.id == items.first?.id {
                        TimelineStepView(step: item)

                    } else if item.id == items.last?.id {
                        TimelineStepView(step: item)
                    } else {
                        TimelineStepView(step: item)
                    }
                    if item.id != items.last?.id {
                        TimelinePathView(item: item)
//            TimelineLineView()
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            //        .background(Color.white)
            //        .cornerRadius(8)
            //        .shadow(radius: 4)
        }
    }
}

struct TimelineView_Previews: PreviewProvider {
    static var previews: some View {
        let items = [
            TimelineItemData(title: "Cikarang", subtitle: nil, time: "12:00", status: .past),
            TimelineItemData(title: "Cibitung", subtitle: nil, time: "12:10", status: .past),
            TimelineItemData(title: "BekasiTimur", subtitle: nil, time: "12:10", image: "train_destination", status: .active),
            TimelineItemData(title: "Bekasi", subtitle: nil, time: "12:10", status: .future),
        ]
        let items2 = [
            TimelineRouteItemData(
                title: "CIkarang",
                subtitle: "Start",
                time: "12:00", options: [
                    ItemOptions(
                        leading: "bekasi", trailing: "12:00", isActive: true
                    ) {},
                    ItemOptions(
                        leading: "bekasi", trailing: "12:00", isActive: false
                    ) {},
                    ItemOptions(
                        leading: "bekasi", trailing: "12:00", isActive: false
                    ) {},
                ], child: [
                    TimelineRouteChild(leading: "Bekasi Timur", trailing: "12:30", status: .active),
                    TimelineRouteChild(leading: "CAkung", trailing: "12:35", status: .active),
                    TimelineRouteChild(leading: "Matraman", trailing: "12:40", status: .active),
                ],

                status: .active
            ),
            TimelineRouteItemData(
                title: "CIkarang",
                subtitle: "Start",
                time: "12:00", options: [
                    ItemOptions(
                        leading: "bekasi", trailing: "12:00", isActive: true
                    ) {},
                    ItemOptions(
                        leading: "bekasi", trailing: "12:00", isActive: false
                    ) {},
                    ItemOptions(
                        leading: "bekasi", trailing: "12:00", isActive: false
                    ) {},
                ], child: [
                    TimelineRouteChild(leading: "Bekasi Timur", trailing: "12:30", status: .active),
                    TimelineRouteChild(leading: "CAkung", trailing: "12:35", status: .active),
                    TimelineRouteChild(leading: "Matraman", trailing: "12:40", status: .active),
                ],

                status: .future
            ),
        ]
        VStack {
            TimelineScheduleView(items: items)
            TimelineScheduleView(items: items2)
        }
    }
}
