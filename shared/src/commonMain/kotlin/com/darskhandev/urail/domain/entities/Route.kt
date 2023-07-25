package com.darskhandev.urail.domain.entities

import com.darskhandev.urail.data.source.remote.models.station.StationModel
import com.darskhandev.urail.data.source.remote.models.station.StationType

data class Route(
    val routes: List<List<Station>>,
//    val distance: Double,
    val fare : Int,
)

//get extension to get simple routes from route
fun Route.getSimpleRoutes(): List<List<Station>> {
    val simpleRoutes = mutableListOf<List<Station>>()
    routes.forEach { route ->
        val simpleRoute = mutableListOf<Station>()
        route.forEach { station ->
            if (station==route.last()||station==route.first()||station.stationType == StationType.TRANSIT.name) {
                simpleRoute.add(station)
            }
        }
        simpleRoutes.add(simpleRoute)
    }
    return simpleRoutes
}

data class RouteSchedule1(
    val childsRoute: List<RouteChild>,
    val arrivalTime: String,
    val routeName: String,
    val stationId: String,
    val destinationId: String,
    val kAName: String,
    val originId: String,
    val kAId: String,
    val departureTime: String,
    val estimatedTime: String,
    val neighbourRoute: List<RouteNeighbour>
)

data class RouteChild(
    val childsRoute: List<RouteChild>,
    val arrivalTime: String,
    val routeName: String,
    val stationId: String,
    val destinationId: String,
    val kAName: String,
    val originId: String,
    val kAId: String,
    val departureTime: String,
    val estimatedTime: String,
    val neighbourRoute: List<RouteNeighbour>
)

data class RouteNeighbour(
    val childsRoute: List<RouteChild>,
    val arrivalTime: String,
    val routeName: String,
    val stationId: String,
    val destinationId: String,
    val kAName: String,
    val originId: String,
    val kAId: String,
    val departureTime: String,
    val estimatedTime: String,
    val neighbourRoute: List<RouteNeighbour>
)

