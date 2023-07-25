//
//  Test2View.swift
//  iosApp
//
//  Created by Akashaka on 11/06/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct TTimelineView: View {
    var steps: [Step]

    var body: some View {
        ScrollView {
            VStack(alignment: HorizontalAlignment.leading, spacing: 0) {
                ForEach(steps) { step in
                    if step == steps.first {
                        TTimelineStepView(step: step, iconName: "train_origin")
                    } else if step == steps.last {
                        TTimelineStepView(step: step, iconName: "train_destination")
                    } else {
                        TTimelineStepView(step: step, iconName: "icon_transit")
                    }

                    if step != steps.last {
                        TimelineLineView().padding(.horizontal, 10)
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 4)
        }
    }
}

struct TTimelineStepView: View {
    var step: Step
    var iconName: String?

    var body: some View {
        HStack(spacing: 8) {
            if iconName == nil {
                Circle()
                    .frame(width: 24, height: 24)
                    .foregroundColor(step.color)
            } else {
                Image(iconName!).resizable().frame(width: 30, height: 24).padding(.trailing, 8)
                //          .cornerRadius(8).shadow(radius: 4)
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
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.top, 8)
    }
}

struct TimelineLineView: View {
    let options: [String] = ["Angke 12:15", "KampungBandan via MGR 12:30", "angke 12:43"]
    let stops: [String] = ["Bekasi 12:15", "Pondok Ranji 12:30", "Matraman 12:43"]
    @State var isOptionsExpanded: Bool = false
    @State var isStopsExpanded: Bool = false
    var body: some View {
        VStack(alignment: HorizontalAlignment.leading) {
            HStack {
                VStack {
                    Spacer()
                    Rectangle()
                        .frame(width: 1)
                        .foregroundColor(.gray)
                    //          Spacer()
                }
                Spacer().frame(width: 24)
                VStack(alignment: HorizontalAlignment.leading) {
                    HStack {
                        if isOptionsExpanded {
                            Image(systemName: "chevron.up")
                        } else {
                            Image(systemName: "chevron.down")
                        }
                        Text("terdapat \(options.count) pilihan jadwal lainnya")
                    }.onTapGesture {
                        isOptionsExpanded.toggle()
                    }.padding(.top, 8)

                    VStack(alignment: HorizontalAlignment.leading) {
                        if isOptionsExpanded {
                            VStack(alignment: HorizontalAlignment.leading) {
                                ForEach(options, id: \.self) { optionItem in
                                    //                Text(optionItem)
                                    if optionItem == options.first {
                                        HStack {
                                            Text("Kampung Bandan via MGR").lineLimit(1)
                                            Text("12:00")
                                        }.padding(16)
                                            .overlay(RoundedRectangle(cornerRadius: 8)
                                                .stroke(.blue, lineWidth: 2)
                                            )
                                    } else {
                                        HStack {
                                            Text("Kampung Bandan via MGR").lineLimit(1)
                                            Text("12:00")
                                        }.padding(16)
                                    }
                                }
                            }
                            .background(Color.white)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                        }
                    }

                    VStack(alignment: HorizontalAlignment.leading) {
                        HStack {
                            if isStopsExpanded {
                                Image(systemName: "chevron.up")
                            } else {
                                Image(systemName: "chevron.down")
                            }
                            Text("terdapat \(options.count) pemberhentian")
                        }.onTapGesture {
                            isStopsExpanded.toggle()
                        }
                    }.padding(.top, 8)
                }.padding(.bottom, 8)
            }

//      }.padding(0)
        }
        if isStopsExpanded {
            ForEach(stops, id: \.self) { stop in
                HStack {
                    VStack(alignment: HorizontalAlignment.leading) {
                        //          Spacer()
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(.gray)
                        Circle()
                            .frame(width: 3, height: 3)
                            .foregroundColor(.blue)
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(.gray)
                        //          Spacer()
                    }
                    Spacer().frame(width: 48)
                    VStack(alignment: HorizontalAlignment.leading) {
                        Text(stop).font(.caption)
                            .foregroundColor(.secondary)
                    }
//          Spacer()
                    //      }.padding(0)
                }
            }
        }
    }
}

struct TTContentView: View {
    let steps: [Step] = [
        Step(title: "Start", subtitle: "Departure", color: .blue),
        Step(title: "Transit", subtitle: "Change trains", color: .yellow),
        Step(title: "Transit2", subtitle: "Change trains", color: .yellow),
        Step(title: "Transit3", subtitle: "Change trains", color: .yellow),
        Step(title: "Transit2", subtitle: "Change trains", color: .yellow),
        Step(title: "Transit3", subtitle: "Change trains", color: .yellow),
        Step(title: "Transit3", subtitle: "Change trains", color: .yellow),
        Step(title: "Transit2", subtitle: "Change trains", color: .yellow),
        Step(title: "Transit3", subtitle: "Change trains", color: .yellow),
        Step(title: "Arrive", subtitle: "Destination", color: .green),
    ]

    var body: some View {
        VStack {
            Text("Timeline")
                .font(.title)
                .bold()
//        .padding()

            TTimelineView(steps: steps)
                .padding()
        }
    }
}

struct TTContentView_Previews: PreviewProvider {
    static var previews: some View {
        TTContentView()
    }
}
