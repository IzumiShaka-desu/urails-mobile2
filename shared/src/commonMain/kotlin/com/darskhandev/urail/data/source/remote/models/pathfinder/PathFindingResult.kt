package com.darskhandev.urail.data.source.remote.models.pathfinder

import com.darskhandev.urail.data.source.remote.models.station.StationModel
import com.darskhandev.urail.data.source.remote.models.station.asEntity
import com.darskhandev.urail.domain.entities.Route
import kotlinx.serialization.Serializable

@Serializable
data class PathFindingResult(
    val routes: List<List<StationModel>>,
//    val distance: Double,
    val fare : Int,
)

fun PathFindingResult.asEntity() = Route(
    routes = routes.map { route ->
       route.asEntity()
    },
    fare = fare
)

@Serializable
data class FareResult(
    val fare: Int,
    val origin: String,
    val destination: String,
)

@Serializable
data class FareResponse(
    val status:Int,
    val data:List<FareItem>,
){
    @Serializable
    data class FareItem(
        val fare: Int,
        val distance: Double,
    )
}