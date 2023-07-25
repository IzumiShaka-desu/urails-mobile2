package com.darskhandev.urail.domain.entities

data class Station(
    val stationName: String,
    val stationId: String,
    val latitude: Double,
    val stationType: String,
    val longitude: Double,
    val peronInfo: List<Peron>? = null
)
data class StationList(
    val stations: List<Station>
)