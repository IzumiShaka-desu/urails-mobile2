package com.darskhandev.urail.domain.entities

import kotlinx.serialization.SerialName

data class Schedule(
    val kaId: String,
    val kaName: String,
    val routeName: String,
    val stationName: String,
    val stationId: String,
    val originId: String,
    val destinationId: String,
    val arrivalTime: String,
    val departureTime: String
)
data class ScheduleList(
    val schedules: List<Schedule>
)