package com.darskhandev.urail.data.source.remote.models.route

import com.darskhandev.urail.data.source.remote.models.schedule.RouteScheduleRaw
import kotlinx.serialization.Serializable
import kotlinx.serialization.SerialName
//class implementation from json
//{
//            "route_name": "RKS-Sudirman (via THB)",
//            "origin_id": "RKS",
//            "destination_id": "SDR",
//            "estimated_distance": 15.6,
//            "estimated_fare": 10000,
//            "schedules": []}
@Serializable
data class KaRoute(
    @SerialName("route_name") val routeName: String,
    @SerialName("origin_id") val originId: String,
    @SerialName("destination_id") val destinationId: String,
    @SerialName("estimated_distance") val estimatedDistance: Double,
    @SerialName("estimated_fare") val estimatedFare: Int,
    @SerialName("schedules") val schedules: List<RouteScheduleRaw>
)

