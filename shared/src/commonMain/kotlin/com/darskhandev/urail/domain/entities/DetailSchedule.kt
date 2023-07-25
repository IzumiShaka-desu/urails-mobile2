package com.darskhandev.urail.domain.entities

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable



data class DetailSchedule(
    val kaID: String,

    val kaName: String,

    val routeName: String,

    val originID: String,

    val destinationID: String,

    val arrivalTime: String,

    val departureTime: String,

    val createdAt: String,

    val detailScheduleItem: List<DetailScheduleItem>
)


fun DetailSchedule.toSchedule(): Schedule {
    return Schedule(
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