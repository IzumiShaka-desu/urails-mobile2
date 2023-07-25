package com.darskhandev.urail.domain.entities
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable



data class RouteSchedule (
     val kaId: String,
     val kaName: String,
     val routeName: String,
     val stationId: String,
     val originId: String,
     val destinationId: String,
     val arrivalTime: String,
     val departureTime: String,
     val estimatedTime: String,
     val childsRoute: List<DetailScheduleItem>,
     val neighbourRoutes: Map<String,List<RouteSchedule>>,

    )

fun Map<RouteSchedule,List<RouteSchedule>>.getRouteSchedules(): List<RouteSchedule> {
    val routeScheduleList = mutableListOf<RouteSchedule>()
    this.forEach { (t, u) ->
        routeScheduleList.add(t)
        routeScheduleList.addAll(u)
    }
    return routeScheduleList
}

data class ListRouteSchedule(
    val routeSchedules: List<RouteSchedule>
)