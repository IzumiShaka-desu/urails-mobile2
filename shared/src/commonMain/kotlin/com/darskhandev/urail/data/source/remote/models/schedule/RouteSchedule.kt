package com.darskhandev.urail.data.source.remote.models.schedule
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable


@Serializable()
data class RouteScheduleRaw (
    @SerialName("KA_id") val kaId: String,
    @SerialName("KA_name") val kaName: String,
    @SerialName("route_name") val routeName: String,
    @SerialName("station_id") val stationId: String,
    @SerialName("origin_id") val originId: String,
    @SerialName("destination_id") val destinationId: String,
    @SerialName("arrival_time") val arrivalTime: String,
    @SerialName("departure_time") val departureTime: String,
    @SerialName("estimated_time") val estimatedTime: String,
    @SerialName("childs_route") val childsRoute: List<DetailScheduleItemRaw>,
    @SerialName("neighbour_routes") val neighbourRoutes: Map<String,List<RouteScheduleRaw>>,

    )

fun Map<RouteScheduleRaw,List<RouteScheduleRaw>>.getRouteSchedules(): List<RouteScheduleRaw> {
    val routeScheduleList = mutableListOf<RouteScheduleRaw>()
    this.forEach { (t, u) ->
        routeScheduleList.add(t)
        routeScheduleList.addAll(u)
    }
    return routeScheduleList
}

data class ListRouteScheduleRaw(
    val routeSchedules: List<RouteScheduleRaw>
)