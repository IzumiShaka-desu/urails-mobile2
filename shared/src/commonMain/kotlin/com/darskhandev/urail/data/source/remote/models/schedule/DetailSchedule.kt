package com.darskhandev.urail.data.source.remote.models.schedule

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable


@Serializable()
data class DetailScheduleRaw(
    @SerialName("ka_id")
    val kaID: String,

    @SerialName("ka_name")
    val kaName: String,

    @SerialName("route_name")
    val routeName: String,

    @SerialName("origin_id")
    val originID: String,

    @SerialName("destination_id")
    val destinationID: String,

    @SerialName("arrival_time")
    val arrivalTime: String,

    @SerialName("departure_time")
    val departureTime: String,

    @SerialName("created_at")
    val createdAt: String,

    @SerialName("detail_schedule_item")
    val detailScheduleItem: List<DetailScheduleItemRaw>
)


fun DetailScheduleRaw.toScheduleRaw(): ScheduleRaw {
    return ScheduleRaw(
        kaId = kaID,
        kaName = kaName,
        routeName = routeName,
        stationId = detailScheduleItem.first().stationID,
        stationName= detailScheduleItem.first().stationName,
        originId = originID,
        destinationId = destinationID,
        arrivalTime = arrivalTime,
        departureTime = detailScheduleItem.first().timeAtStation
    )
}