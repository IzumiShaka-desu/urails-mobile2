//
//  TimelineState.swift
//  iosApp
//
//  Created by Akashaka on 04/07/23.
//  Copyright © 2023 orgName. All rights reserved.
//

import Combine
import shared

class TimelineState: ObservableObject {
  static let shared = TimelineState()
  var routeSchedules: [RouteScheduleRaw] = []
  var route: [String] = []
  var stations: [Station] = []
  var estimatedTime:String {
    var timeInMillis: Int64 = 0
    // Menghitung total waktu dari routeSchedules
    // Cari waktu berangkat dan tiba berdasarkan state first dan last
   
    guard let departTime = state.first?.childsRoute.filter({ route.contains($0.stationID) }).first?.timeAtStation,
          let arriveTime = state.last?.childsRoute.filter({ route.contains($0.stationID) }).last?.timeAtStation else {
      return "Not found"
    }
    print("sss \(timeInMillis)")
    // Konversi timeAtStation menjadi TimeInterval (detik) dan hitung total waktu
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "HH:mm:dd"
//    if let departDate = dateFormatter.date(from: departTime),
//       let arriveDate = dateFormatter.date(from: arriveTime) {
//      print("depart time \(departTime) = \(departDate)")
//      print("arrive time \(arriveTime) = \(arriveDate)")
//
//      timeInMillis = Int64(arriveDate.timeIntervalSince(departDate) * 1000)
//    }
    timeInMillis = timeInMillisBetween(startTime:departTime,endTime:arriveTime) ?? 0
    print("sss \(timeInMillis)")
    // Konversi timeInMillis ke format waktu "x jam x menit"
    let seconds = Int(timeInMillis / 1000)
    let minutes = (seconds / 60) % 60
    let hours = (seconds / 3600)
    
    // Format waktu sebagai "x jam x menit"
    var formattedTime = ""
    if hours > 0 {
      formattedTime += "\(hours) jam "
    }
    if minutes > 0 {
      formattedTime += "\(minutes) menit"
    }
    
    return formattedTime.isEmpty ? "0 menit" : formattedTime
  }
  func timeInMillisBetween(startTime: String, endTime: String) -> Int64? {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "HH:mm:ss"
      
      guard let startDate = dateFormatter.date(from: startTime),
            let endDate = dateFormatter.date(from: endTime) else {
          return nil
      }
      
      let timeIntervalInMillis = Int64(endDate.timeIntervalSince(startDate) * 1000)
      return timeIntervalInMillis
  }
  @Published var state: [RouteScheduleRaw] = []
  var stateAsTimelineData: [any TimelineItem] {
    var result = [any TimelineItem]()
    var lastStationName = ""
    var lastStationId = ""
    
    for (index, schedule) in state.enumerated() {
      var stationName = ""
      var subtitle = ""
      var time = ""
      var destinationTime = ""
      //      let newRoute:[String] = lastStationId == "" ? route : Array(route[route.index(after: route.firstIndex(of: lastStationId)!)...])
      let newRoute: [String] = lastStationId == "" ? route : Array(route[route.firstIndex(of: lastStationId)!...])
      
      let subRoute = schedule.childsRoute.filter { newRoute.contains($0.stationID) }
      print(subRoute)
      stationName = lastStationName
      if let lastDestination = subRoute.last {
        lastStationId = lastDestination.stationID
        destinationTime = lastDestination.timeAtStation
      }
      
      //
      if lastStationName == "" {
        if let firstDestination = subRoute.first {
          stationName = firstDestination.stationName
        }
      }
      print(stationName)
      if let firstDestination = subRoute.first {
        time = "\(firstDestination.timeAtStation.prefix(5))"
        if firstDestination.stationType == StationType.transit {
          //          print(stations)
          if let currentStation = stations.first(where: { firstDestination.stationID == $0.stationId }) {
            if subRoute.count > 1 {
              let nextStation = subRoute[1].stationID
              let availablePeron: [Peron] = currentStation.peronInfo?.filter { $0.line?.contains(nextStation) ?? false } ?? []
              if let description = availablePeron.first?.description_, description.lowercased().contains("gunakan") {
                subtitle += description + " untuk menuju "
              }
              subtitle += availablePeron.map {
                $0.peronName
              }.joined(separator: " atau ")
            }
          }
          
        } else {
          subtitle = "tunggu jadwal kereta \(schedule.routeName) selanjutnya"
        }
      }
      //  print(time)
      //      print(destinationTime)
      //      print("subtitle: \(subtitle)")
      //      stationName += "(\(schedule.routeName))"
      //    print(stationName)
      //      var status:TimelineStatus  = .future
      //      if isScheduleActiveOrPast(time: time) {
      //        status = .active
      //      }
      //      if isScheduleActiveOrPast(time: destinationTime) {
      //        status = .past
      //      }
      var options = [ItemOptions]()
      //
      if schedule == state.first {
        options = generateOptions(
          schedules: routeSchedules,
          route: newRoute,
          currentKaId: schedule.kaId
        )
      } else {
        let previousSchedule = state[index - 1]
        options = generateOptions(
          schedules: state.first?.neighbourRoutes[previousSchedule.kaId] ?? [],
          route: route,
          currentKaId: schedule.kaId
        )
      }
      let pastSchedule = schedule.childsRoute
        .filter { item in
          isScheduleActiveOrPast(time: item.timeAtStation)
        }
      let child = subRoute.map { detail in
        let status: TimelineStatus
        
        if pastSchedule.last == detail {
          status = .active
        } else if pastSchedule.contains(detail) {
          status = .past
        } else {
          status = .future
        }
        return TimelineRouteChild(leading: detail.stationName, trailing: "\(detail.timeAtStation.prefix(5))", status: status)
      }
      let item = TimelineRouteItemData(
        title: stationName,
        subtitle: subtitle,
        time: time.prefix(5).lowercased(),
        image: index == 0 ? "train_origin" : "icon_transit",
        options: options,
        child: child,
        status: .future
      )
      print(item)
      result.append(item)
      if let lastDestination = subRoute.last {
        lastStationName = lastDestination.stationName
      }
      if schedule == state.last {
        if let dest = child.last {
          result.append(TimelineItemData(title: dest.leading, subtitle: "Stasiun Tujuan", time: dest.trailing, image: "train_destination", status: .future))
        }
      }
      print(lastStationId)
    }
    return result
  }
  
  func generateOptions(schedules: [RouteScheduleRaw], route: [String], currentKaId: String) -> [ItemOptions] {
    var options = [ItemOptions]()
    
    for neigbour in schedules {
      let subRoute = neigbour.childsRoute.filter { route.contains($0.stationID) }
      if subRoute.first?.timeAtStation == nil {
        print(neigbour)
        print(route)
        print(neigbour.childsRoute)
        print(subRoute)
      }
      let option = ItemOptions(
        leading: "\(neigbour.routeName) (\(neigbour.kaId))",
        trailing: (subRoute.first?.timeAtStation ?? "").prefix(5).lowercased(),
        isActive: neigbour.kaId == currentKaId
      ) {
        if neigbour.kaId != currentKaId {
          self.reArrangeTimeline(
            kaIdBefore: currentKaId,
            kaIdAfter: neigbour.kaId
          )
        }
      }
      options.append(option)
    }
    return options
  }
  
  func isScheduleActiveOrPast(time: String) -> Bool {
    let currentTime = Date()
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm:ss"
    guard let timeAtStation = dateFormatter.date(from: time) else {
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
  
  func findSubRoute(routeSchedules: RouteScheduleRaw, route: [String]) -> [DetailScheduleItemRaw] {
    return routeSchedules.childsRoute.filter { route.contains($0.stationID) }
  }
  
  func findExactTimeInRoute(routeSchedules: RouteScheduleRaw, route: [String]) -> String {
    let routeOnRouteSchedules = routeSchedules.childsRoute.filter { route.contains($0.stationID) }
    return routeOnRouteSchedules.last?.timeAtStation ?? ""
  }
  
  func replaceState(routeSchedules: [RouteScheduleRaw], route: [String]) {
    self.routeSchedules = routeSchedules
    self.route = route
    state = []
    
    self.routeSchedules.sort { a, b in
      let aTime = parseTime(timeString: a.departureTime)
      let bTime = parseTime(timeString: b.departureTime)
      return aTime > bTime
    }
    
    //        print(self.routeSchedules.map { e -> String in
    //            let subRoute = findSubRoute(routeSchedules: e, route: route)
    //            return "\(e.kaId)  initial depart-arrive: \(e.departureTime)-\(e.arrivalTime) actual depart \(subRoute.first?.timeAtStation ?? "")(\(subRoute.first?.stationID ?? ""))-\(subRoute.last?.timeAtStation ?? "")(\(subRoute.last?.stationID ?? ""))"
    //        })
    
    arrangeTimeline()
  }
  
  func arrangeTimeline() {
    var tried = 0
    var stationCheckpoint = ""
    while true {
      let newRoute: [String] = stationCheckpoint == "" ? route : Array(route[route.firstIndex(of: stationCheckpoint)!...])
      if tried > 10 {
        break
      }
      
      if !state.isEmpty && findSubRoute(routeSchedules: state.last!, route: newRoute).last?.stationID == route.last {
        break
      }
      
      if state.isEmpty {
        print("state empty : append \(String(describing: routeSchedules.first?.kaId))")
        state.append(routeSchedules.first!)
      } else {
        print("get neighbour of \(state.last!.kaId)")
        
        var neighbours: [RouteScheduleRaw] = (routeSchedules.first { element in
          state.first!.kaId == element.kaId
        }?.neighbourRoutes[state.last!.kaId] ?? [])
        neighbours.sort { a, b in
          let kaIdA = a.kaId
          let kaIdB = b.kaId
          let aRoute = a.childsRoute.map { $0.stationID }
          let bRoute = b.childsRoute.map { $0.stationID }
          let aSubroute = findSubRoute(routeSchedules: a, route: newRoute)
          let bSubroute = findSubRoute(routeSchedules: b, route: newRoute)
          if aSubroute.isEmpty {
            return false
          }
          if bSubroute.isEmpty {
            return true
          }
          
          //          let aTime = parseTime(timeString: a.departureTime)
          //          let bTime = parseTime(timeString: b.departureTime)
          let aTime = parseTime(timeString: aSubroute.first!.timeAtStation)
          let bTime = parseTime(timeString: bSubroute.first!.timeAtStation)
          return aTime > bTime
        }
        print(neighbours.map { e -> String in
          let subRoute = findSubRoute(routeSchedules: e, route: newRoute)
          
          return "\(e.kaId) initial depart-arrive: \(e.departureTime)-\(e.arrivalTime) actual depart \(subRoute.first?.timeAtStation ?? "")(\(subRoute.first?.stationID ?? ""))-\(subRoute.last?.timeAtStation ?? "")(\(subRoute.last?.stationID ?? ""))"
        })
        if let neighbour = neighbours.first {
          print(state.last!.kaId)
          print(neighbour.kaId)
          stationCheckpoint = findSubRoute(routeSchedules: neighbour, route: newRoute).last?.stationID ?? ""
          state.append(neighbour)
        }
      }
      
      tried += 1
    }
  }
  
  func getNeigbourKaSchedule(kaId: String) -> [String] {
    return state.first?.neighbourRoutes[kaId]?.map { $0.kaId } ?? []
  }
  
  func reArrangeTimeline(kaIdBefore: String, kaIdAfter: String) {
    print(kaIdBefore)
    print(kaIdAfter)
    var initialNewState = [RouteScheduleRaw]()
    for item in state {
      if item.kaId == kaIdBefore {
        break
      }
      initialNewState.append(item)
    }
    
    print(
      initialNewState
    )
    if initialNewState.isEmpty {
      if let kaAfter = routeSchedules.first(where: { $0.kaId == kaIdAfter }) {
        initialNewState.append(kaAfter)
      }
    } else {
      let neighbourRoutes = state.first!.neighbourRoutes[initialNewState.last!.kaId] ?? []
      if let kaAfter = neighbourRoutes.first(where: { $0.kaId == kaIdAfter }) {
        initialNewState.append(kaAfter)
      }
    }
    print(initialNewState.map { $0.kaId })
    print(state.map { $0.kaId })
    state = initialNewState
    arrangeTimeline()
  }
  
  private func parseTime(timeString: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter.date(from: "1970-01-01 \(timeString)") ?? Date()
  }
}
