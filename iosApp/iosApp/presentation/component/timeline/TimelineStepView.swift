//
//  TimelineStepView.swift
//  iosApp
//
//  Created by Akashaka on 02/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct TimelineStepView: View {
    var step: any TimelineItem
    var iconName: String?
    var body: some View {
        HStack(spacing: 8) {
            if step.image == nil {
                CircleIndicator(status: step.status)
            } else {
                ZStack {
                    Image(step.image!).resizable()
                }.frame(width: 24, height: 24)
            }
            VStack(alignment: .leading) {
                Text(step.title)
                    .font(.headline)
                if let subtitle = step.subtitle {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            if let time = step.time {
                Text(time.prefix(5))
                    .font(.subheadline)
                    .foregroundColor(step.status == TimelineStatus.future ? .secondary : .blue)
            }
        }
        .padding(.top, 8)
    }
}

struct TimelineStepView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TimelineStepView(
                step: TimelineItemData(
                    title: "Station",
                    subtitle: nil,
                    time: "12:00",
                    status: .past
                )
            )
            TimelineStepView(
                step: TimelineItemData(
                    title: "Station",
                    subtitle: nil,
                    time: "12:00",
                    status: .active
                )
            )
            TimelineStepView(
                step: TimelineItemData(
                    title: "Station",
                    subtitle: nil,
                    time: "12:00",
                    status: .future
                )
            )
            TimelineStepView(
                step: TimelineItemData(
                    title: "Station",
                    subtitle: nil,
                    time: "12:00",
                    status: .future
                ),
                iconName: "train_destination"
            )
        }
    }
}
