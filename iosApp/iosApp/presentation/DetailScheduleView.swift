//
//  DetailScheduleView.swift
//  iosApp
//
//  Created by Akashaka on 01/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import shared
import SwiftUI

struct DetailScheduleView: View {
    let schedule: DetailScheduleRaw

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
//        Button(action: {
//          // Handle back button action
//        }) {
//          Image(systemName: "chevron.left")
//            .foregroundColor(.blue)
//        }

                Text(schedule.kaName)
                    .font(.headline)

                Spacer()
            }

//      Text(schedule.kaName)
//        .font(.title)

            Text(schedule.routeName)
                .font(.headline)
                .foregroundColor(.secondary)

            HStack {
                Spacer()
//        VStack{
                Text("Berangkat : ")
                Text(schedule.departureTime.prefix(5))
//        }
                Spacer()
//        VStack{
                Text("Tiba : ")
                Text(schedule.arrivalTime.prefix(5))
//        }
                Spacer()
            }

//      Text("Detail Schedule:")
//        .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                let pastSchedule = schedule.detailScheduleItem
                    .filter { item in
                        isScheduleActiveOrPast(item: item)
                    }

                TimelineScheduleView(items: schedule.detailScheduleItem.map { detail in
                    let status: TimelineStatus

                    if pastSchedule.last == detail {
                        status = .active
                    } else if pastSchedule.contains(detail) {
                        status = .past
                    } else {
                        status = .future
                    }

                    return TimelineItemData(
                        title: detail.stationName,
                        subtitle: nil,
                        time: detail.timeAtStation,
                        status: status
                    )
                })
            }
        }
        .padding()
    }

    func isScheduleActiveOrPast(item: DetailScheduleItemRaw) -> Bool {
        let currentTime = Date()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        guard let timeAtStation = dateFormatter.date(from: item.timeAtStation) else {
            return false
        }

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: currentTime)
        let currentHour = components.hour ?? 0
        let currentMinute = components.minute ?? 0

        let itemHour = calendar.component(.hour, from: timeAtStation)
        let itemMinute = calendar.component(.minute, from: timeAtStation)

        if currentHour < itemHour {
            return false // Jadwal belum tercapai
        } else if currentHour == itemHour && currentMinute < itemMinute {
            return false // Jadwal belum tercapai
        }

        return true
    }
}

struct DetailScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        let schedule = DetailScheduleRaw(kaID: "6019", kaName: "CKR", routeName: "CIKARANG-KAMPUNGBANDAN", originID: "CKR", destinationID: "KPB", arrivalTime: "09:00:00", departureTime: "07:46:00", createdAt: "", detailScheduleItem: [
            DetailScheduleItemRaw(kaID: "6019", kaName: "BEKASI LINE", stationID: "CKR", stationName: "CIKARANG", timeAtStation: "07:46:00", stationType: StationType.big, createdAt: "", itemID: 123),
            DetailScheduleItemRaw(kaID: "6019", kaName: "BEKASI LINE", stationID: "MTM", stationName: "M.TELAGAMURNI", timeAtStation: "07:51:00", stationType: StationType.small, createdAt: "", itemID: 123),
            DetailScheduleItemRaw(kaID: "6019", kaName: "BEKASI LINE", stationID: "BKS", stationName: "Bekasi", timeAtStation: "07:51:00", stationType: StationType.small, createdAt: "", itemID: 123),
        ])
        DetailScheduleView(schedule: schedule)
    }
}
