package com.darskhandev.urail.data.source.remote.models.schedule
import com.darskhandev.urail.domain.entities.Schedule
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

// class implementation from json
//{
//      "ka_id": "001",
//      "ka_name": "Serpong Line",
//      "route_name": "THB-RKS",
//      "station_id": "CKY",
//      "origin_id": "THB",
//      "destination_id": "RKS",
//      "arrival_time": "07:45",
//      "departure_time": "07:50"
//    },

@Serializable()
data class ScheduleRaw (
    @SerialName("ka_id") val kaId: String,
    @SerialName("ka_name") val kaName: String,
    @SerialName("route_name") val routeName: String,
    @SerialName("station_name") val stationName: String,
    @SerialName("station_id") val stationId: String,
    @SerialName("origin_id") val originId: String,
    @SerialName("destination_id") val destinationId: String,
    @SerialName("arrival_time") val arrivalTime: String,
    @SerialName("departure_time") val departureTime: String
)

fun ScheduleRaw.asEntity() = Schedule(
    kaId = kaId,
    kaName = kaName,
    routeName = routeName,
    stationName = stationName,
    stationId = stationId,
    originId = originId,
    destinationId = destinationId,
    arrivalTime = arrivalTime,
    departureTime = departureTime
)

fun List<ScheduleRaw>.mapToListSchedule() = map { it.asEntity() }