//
//  ScheduleItem.swift
//  iosApp
//
//  Created by Akashaka on 09/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import shared
import SwiftUI

struct ScheduleItem: View {
    var schedule: Schedule
    var body: some View {
        ZStack {
            HStack {
                Image(getIconName(kaName: schedule.kaName))
                    .resizable()
                    .frame(width: 64, height: 64)

                VStack(alignment: .leading) {
                    Text(schedule.kaName)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(schedule.routeName)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text(schedule.departureTime.prefix(5))
            }
        }
    }

    func getIconName(kaName: String) -> String {
        let lowercaseName = kaName.lowercased()
        switch lowercaseName {
        case let name where name.contains("bekasi"):
            return "line.biru"
        case let name where name.contains("bogor"):
            return "line.merah"
        case let name where name.contains("tangerang"):
            return "line.coklat"
        case let name where name.contains("serpong"):
            return "line.hijau"
        case let name where name.contains("tanjungpriuk"):
            return "line.pink"
        default:
            return "line.merah"
        }
    }
}

struct ScheduleItem_Previews: PreviewProvider {
    static var previews: some View {
        let schedule = Schedule(kaId: "234234", kaName: "Bekasi Line", routeName: "ANGKE-BEKASI", stationName: "some", stationId: "THB", originId: "AK", destinationId: "BKS", arrivalTime: "13:00", departureTime: "12:00")
        ScheduleItem(schedule: schedule)
    }
}
