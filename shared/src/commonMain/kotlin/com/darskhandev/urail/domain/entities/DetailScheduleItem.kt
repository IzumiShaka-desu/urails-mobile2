package com.darskhandev.urail.domain.entities

import com.darskhandev.urail.data.source.remote.models.station.StationType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

data class DetailScheduleItem(
    val kaID: String,
    val kaName: String,
    val stationID: String,
    val stationName: String,
    val stationType: StationType,
    val timeAtStation: String,
    val createdAt: String,
    val itemID: Long
)



