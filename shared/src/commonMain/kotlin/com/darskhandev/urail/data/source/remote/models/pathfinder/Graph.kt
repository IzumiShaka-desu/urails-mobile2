package com.darskhandev.urail.data.source.remote.models.pathfinder

import com.darskhandev.urail.data.source.remote.models.station.StationModel
import com.darskhandev.urail.domain.entities.Station
import kotlinx.serialization.Serializable
import kotlin.math.*
import kotlin.math.PI


@Serializable
data class Graph(
    val edges: List<EdgeItem>,
//    vertices
    val stations: List<StationModel>
)

fun Graph.getStationBy(stationId: String): StationModel? {
    return stations.find { it.stationId == stationId }
}

// create extention to get Edge like "edges["THB"] then return edge with source THB or destination THB
//
fun Graph.getEdgesBy(stationId: String): List<EdgeItem> {
//    return as sorted from the shortest distance to longest
    return edges.filter { it.source.stationId == stationId || it.destination.stationId == stationId }
        .sortedBy { it.distance }
}
fun toRadians(degrees: Double): Double {
    return degrees * PI / 180.0
}
//fun Graph.findNearestStation(lat: Double, lng: Double): StationModel? {
//    val maxDistanceOnMeters = 100000
//    val maxDistanceOnDegree = maxDistanceOnMeters / 111000.0
//    val nearestStation = stations.filter {
//        val latDiff = it.latitude - lat
//        val lngDiff = it.longitude - lng
//        sqrt(latDiff * latDiff + lngDiff * lngDiff) < maxDistanceOnDegree
//    }.minByOrNull {
//        val latDiff = it.latitude - lat
//        val lngDiff = it.longitude - lng
//        sqrt(latDiff * latDiff + lngDiff * lngDiff)
//    }
//    return nearestStation
//}

fun havershineDistanceOnMeters(lat1: Double, lng1: Double, lat2: Double, lng2: Double): Double {
    val latDiff = toRadians(lat2 - lat1)
    val lngDiff = toRadians(lng2 - lng1)
    val a = sin(latDiff / 2).pow(2) + cos(toRadians(lat1)) * cos(toRadians(lat2)) * sin(lngDiff / 2).pow(2)
    val c = 2 * atan2(sqrt(a), sqrt(1 - a))
    return c * 6371000
}

fun Graph.findNearbyStation(lat: Double, lng: Double): StationModel? {
    val maxDistanceOnMeters = 100000
    val maxDistanceOnDegree = maxDistanceOnMeters / 111000.0
    val nearestStation = stations.filter {
        val latDiff = it.latitude - lat
        val lngDiff = it.longitude - lng
        sqrt(latDiff * latDiff + lngDiff * lngDiff) < maxDistanceOnDegree
    }.minByOrNull {
        val latDiff = it.latitude - lat
        val lngDiff = it.longitude - lng
        sqrt(latDiff * latDiff + lngDiff * lngDiff)
    }
    return nearestStation
}
fun Graph.findNearestStation(lat: Double, lng: Double): StationModel? {
    var nearestStation: StationModel? = null
    var nearestDistance = Double.MAX_VALUE

    for (station in stations) {
       val distance = havershineDistanceOnMeters(lat, lng, station.latitude, station.longitude)
        if (distance < nearestDistance && distance <= 100000) {
            nearestStation = station
            nearestDistance = distance
        }
    }

    return nearestStation
}

