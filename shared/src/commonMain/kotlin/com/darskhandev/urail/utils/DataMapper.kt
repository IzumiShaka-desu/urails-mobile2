package com.darskhandev.urail.utils

import com.darskhandev.urail.data.source.remote.models.station.StationModel
import com.darskhandev.urail.data.source.remote.models.station.asEntity
import com.darskhandev.urail.data.source.remote.response.ChildsRouteItem
import com.darskhandev.urail.data.source.remote.response.NeighbourRouteItem
import com.darskhandev.urail.data.source.remote.response.PeronInfoItem
import com.darskhandev.urail.data.source.remote.response.RouteItem
import com.darskhandev.urail.data.source.remote.response.ScheduleItem
import com.darskhandev.urail.data.source.remote.response.SchedulesItem
import com.darskhandev.urail.data.source.remote.response.StationItem
import com.darskhandev.urail.domain.entities.Peron
import com.darskhandev.urail.domain.entities.Route
import com.darskhandev.urail.domain.entities.RouteChild
import com.darskhandev.urail.domain.entities.RouteNeighbour
import com.darskhandev.urail.domain.entities.RouteSchedule
import com.darskhandev.urail.domain.entities.Schedule
import com.darskhandev.urail.domain.entities.Station

//fun StationItem.asModel(): Station =
//    Station(
//        stationId = stationId,
//        latitude = latitude,
//        stationType = stationType,
//        longitude = longitude,
//        peronInfo = peronInfo.map { it.asModel() },
//        stationName = stationName,
//    )

fun PeronInfoItem.asModel(): Peron =
    Peron(
        peronName = peronName,
        line = line,
        description = description,
    )

//fun List<PeronInfoItem>.mapToList(): List<Peron> =
//    map {
//        it.asModel()
//    }

fun List<StationModel>.mapToListStation(): List<Station> =
    map {
        it.asEntity()
    }

//fun ScheduleItem.asModel(): Schedule =
//    Schedule(
//        arrivalTime = arrivalTime,
//        kaId = kaId,
//        routeName = routeName,
//        stationId = stationId,
//        destinationId = destinationId,
//        originId = originId,
//        kaName = kaName,
//        departureTime = departureTime,
//    )

//fun List<ScheduleItem>.mapToListSchedule(): List<Schedule> =
//    map {
//        it.asModel()
//    }

//fun RouteItem.asModel(): Route =
//    Route(
//        estimatedDistance = estimatedDistance,
//        routeName = routeName,
//        destinationId = destinationId,
//        schedules = schedules.map { it.asModel() },
//        estimatedFare = estimatedFare,
//        originId = originId,
//    )

fun ChildsRouteItem.asModel(): RouteChild =
    RouteChild(
        childsRoute = childsRoute.map { it.asModel() },
        arrivalTime = arrivalTime,
        routeName = routeName,
        stationId = stationId,
        destinationId = destinationId,
        kAName = kAName,
        originId = originId,
        kAId = kAId,
        departureTime = departureTime,
        estimatedTime = estimatedTime,
        neighbourRoute = neighbourRoute.map { it.asModel() },
    )

fun NeighbourRouteItem.asModel(): RouteNeighbour =
    RouteNeighbour(
        childsRoute = childsRoute.map { it.asModel() },
        arrivalTime = arrivalTime,
        routeName = routeName,
        stationId = stationId,
        destinationId = destinationId,
        kAName = kAName,
        originId = originId,
        kAId = kAId,
        departureTime = departureTime,
        estimatedTime = estimatedTime,
        neighbourRoute = neighbourRoute.map { it.asModel() },
    )

//fun SchedulesItem.asModel(): RouteSchedule =
//    RouteSchedule(
//        childsRoute = childsRoute.map { it.asModel() },
//        arrivalTime = arrivalTime,
//        routeName = routeName,
//        stationId = stationId,
//        destinationId = destinationId,
//        kAName = kAName,
//        originId = originId,
//        kAId = kAId,
//        departureTime = departureTime,
//        estimatedTime = estimatedTime,
//        neighbourRoute = neighbourRoute.map { it.asModel() },
//    )
//
//fun List<SchedulesItem>.mapToList(): List<RouteSchedule> =
//    map {
//        it.asModel()
//    }
//
//fun List<NeighbourRouteItem>.mapToList(): List<RouteNeighbour> =
//    map {
//        it.asModel()
//    }
//
//fun List<ChildsRouteItem>.mapToList(): List<RouteChild> =
//    map {
//        it.asModel()
//    }

//fun List<RouteItem>.mapToListRoute(): List<Route> =
//    map {
//        it.asModel()
//    }