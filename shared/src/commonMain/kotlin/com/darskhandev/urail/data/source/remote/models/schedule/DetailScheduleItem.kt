package com.darskhandev.urail.data.source.remote.models.schedule

import com.darskhandev.urail.data.source.remote.models.station.StationType
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable()
data class DetailScheduleItemRaw(
    @SerialName("ka_id")
    val kaID: String,

    @SerialName("ka_name")
    val kaName: String,

    @SerialName("station_id")
    val stationID: String,

    @SerialName("station_name")
    val stationName: String,

    @SerialName("time_at_station")
    val timeAtStation: String,

    @SerialName("station_type")
    val stationType: StationType,

    @SerialName("created_at")
    val createdAt: String,

    @SerialName("item_id")
    val itemID: Long
)



