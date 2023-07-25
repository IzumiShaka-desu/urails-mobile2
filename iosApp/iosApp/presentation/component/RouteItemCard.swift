//
//  RouteItemCard.swift
//  iosApp
//
//  Created by Akashaka on 10/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct RouteItemCard: View {
    var steps: [Step]
    var action: () -> Void
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(steps) { step in
                if step == steps.first {
                    TTimelineStepView(step: step, iconName: "train_origin")
                } else if step == steps.last {
                    TTimelineStepView(step: step, iconName: "train_destination")
                } else {
                    TTimelineStepView(step: step, iconName: "icon_transit")
                }

                if step != steps.last {
                    Image(systemName: "ellipsis")
                        .rotationEffect(
                            Angle(degrees: 90))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 1)
                }
            }
            VStack(alignment: .trailing) {
                HStack {
                    Spacer()
                    Button(action: action) {
                        Text("Lihat Rute").padding().background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.blue, lineWidth: 2)
                            //              .background(Color.white)
                        )
                    }
                }
            }
        }.padding()
    }
}

struct RouteItemCard_Previews: PreviewProvider {
    static var previews: some View {
        let steps: [Step] = [
            Step(title: "Rangkasbitung", subtitle: "Departure", color: .blue),
            Step(title: "Tanah Abang", subtitle: "Change trains", color: .yellow),
            Step(title: "Bekasi", subtitle: "Change trains", color: .yellow),
            Step(title: "Cikarang", subtitle: "Change trains", color: .yellow),
        ]
        RouteItemCard(steps: steps) {}
    }
}
