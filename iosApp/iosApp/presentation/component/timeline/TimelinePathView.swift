//
//  TimelinePathView.swift
//  iosApp
//
//  Created by Akashaka on 06/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import SwiftUI

struct TimelinePathView: View {
    let item: any TimelineItem
    @State var isOptionsExpanded: Bool = false
    @State var isStopsExpanded: Bool = false
    var body: some View {
//    ZStack{
        switch item {
        case is TimelineRouteItemData:
            let currentItem = item as! TimelineRouteItemData
            let options = currentItem.options
            let stops = currentItem.child
            VStack(alignment: HorizontalAlignment.leading) {
                HStack {
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(.gray)
                        //          Spacer()
                    }.padding(.leading, 10)
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
                                    ForEach(options, id: \.id) { optionItem in
                                        //                Text(optionItem)
                                        if optionItem.isActive {
                                            HStack {
                                                Text(optionItem.leading).lineLimit(1)
                                                Spacer()
                                                Text(optionItem.trailing)
                                            }.padding(16)
                                                .overlay(RoundedRectangle(cornerRadius: 8)
                                                    .stroke(.blue, lineWidth: 2)
                                                ).onTapGesture {
                                                    optionItem.action()
                                                }
                                        } else {
                                            HStack {
                                                Text(optionItem.leading).lineLimit(1)
                                                Spacer()
                                                Text(optionItem.trailing)
                                            }.padding(16).onTapGesture {
                                                optionItem.action()
                                            }
                                        }
                                    }
                                }
//                  .background(Color.white)
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
                                Text("terdapat \(stops.count) pemberhentian")
                            }.onTapGesture {
                                isStopsExpanded.toggle()
                            }
                        }.padding(.top, 8)
                    }.padding(.bottom, 8)
                }

            }.padding(0)
//        }
            if isStopsExpanded {
                ForEach(stops, id: \.id) { stop in
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
                        }.padding(.leading, 10)
                        Spacer().frame(width: 48)
                        VStack(alignment: HorizontalAlignment.leading) {
                            HStack {
                                Text(stop.leading).font(.caption)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text(stop.trailing).font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        case is TimelineItemData:
            VStack(alignment: HorizontalAlignment.leading) {
                HStack {
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(
                                item.status != TimelineStatus.future ? .blue : .gray
                            )
                    }
                    Spacer().frame(width: 24)
                    VStack {
                        Text("")
                        Text("")
                    }
                }
            }.padding(.horizontal, 12)
        default:
            VStack(alignment: HorizontalAlignment.leading) {
                HStack {
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(width: 1)
                            .foregroundColor(
                                item.status != TimelineStatus.future ? .blue : .gray
                            )
                    }
                    Spacer().frame(width: 24)
                    VStack {
                        Text("")
                        Text("")
                    }
                }
            }.padding(.horizontal, 12)
        }
    }
    //  }
}

// struct TimelinePathsView: View {
//  let item : any TimelineItem
//  @State var isOptionsExpanded:Bool = false;
//  @State var isStopsExpanded:Bool = false;
//  var body: some View {
//    VStack(alignment: HorizontalAlignment.leading){
//      HStack{
//        VStack {
//          Spacer()
//          Rectangle()
//            .frame(width: 1)
//            .foregroundColor(.gray)
//          //          Spacer()
//        }
//        Spacer().frame(width: 24)
//        VStack(alignment: HorizontalAlignment.leading){
//          HStack{
//            if(isOptionsExpanded){
//              Image(systemName: "chevron.up")
//            }else{
//              Image(systemName: "chevron.down")
//            }
//            Text("terdapat \(options.count) pilihan jadwal lainnya")
//          }.onTapGesture {
//            isOptionsExpanded.toggle()
//          }.padding(.top,8)
//
//          VStack(alignment: HorizontalAlignment.leading){
//            if()
//            if(isOptionsExpanded){
//              VStack(alignment: HorizontalAlignment.leading){
//                ForEach(options,id: \.self){optionItem in
//                  //                Text(optionItem)
//                  if(optionItem == options.first){
//                    HStack{
//                      Text("Kampung Bandan via MGR").lineLimit(1)
//                      Text("12:00")
//                    }.padding(16)
//                      .overlay(RoundedRectangle(cornerRadius: 8)
//                        .stroke(.blue, lineWidth: 2)
//                      )
//                  }else{
//                    HStack{
//                      Text("Kampung Bandan via MGR").lineLimit(1)
//                      Text("12:00")
//                    }.padding(16)
//                  }
//                }
//              }
//              .background(Color.white)
//              .cornerRadius(8)
//              .shadow(radius: 4)
//            }
//          }
//
//          VStack(alignment: HorizontalAlignment.leading){
//            HStack{
//              if(isStopsExpanded){
//                Image(systemName: "chevron.up")
//              }else{
//                Image(systemName: "chevron.down")
//              }
//              Text("terdapat \(options.count) pemberhentian")
//            }.onTapGesture {
//              isStopsExpanded.toggle()
//            }
//          }.padding(.top,8)
//        }.padding(.bottom,8)
//      }
//
////      }.padding(0)
//    }
//    if(isStopsExpanded){
//      ForEach(stops,id: \.self){stop in
//        HStack(){
//          VStack(alignment: HorizontalAlignment.leading){
//            //          Spacer()
//            Rectangle()
//              .frame(width: 1)
//              .foregroundColor(.gray)
//            Circle()
//              .frame(width: 3, height: 3)
//              .foregroundColor(.blue)
//            Rectangle()
//              .frame(width: 1)
//              .foregroundColor(.gray)
//            //          Spacer()
//          }
//          Spacer().frame(width: 48)
//          VStack(alignment: HorizontalAlignment.leading){
//            Text(stop).font(.caption)
//              .foregroundColor(.secondary)
//          }
////          Spacer()
//          //      }.padding(0)
//
//        }
//      }
//    }
//  }
// }
struct TimelinePathView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            TimelinePathView(
                item: TimelineItemData(
                    title: "CIkarang",
                    subtitle: "Start",
                    time: "12:00",
                    status: .active
                )
            )
            CircleIndicator(status: .active)
            TimelinePathView(
                item: TimelineRouteItemData(
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
                )
            )
        }
    }
}
