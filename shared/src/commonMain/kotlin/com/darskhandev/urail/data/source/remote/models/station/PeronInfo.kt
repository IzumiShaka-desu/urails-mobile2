package com.darskhandev.urail.data.source.remote.models.station

import com.darskhandev.urail.domain.entities.Peron
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

//data class implementation from json
//{
//    "peron_name":"peron 7",
//    "description":"",
//    "line":[
//    "kampung bandan","jatinegara"
//    ]
//}
@Serializable
data class PeronInfo(
    @SerialName("station_id") val stationId: String,
    @SerialName("peron_name")val peronName: String,
    val description: String,
    val line: String,
)

fun PeronInfo.asEntity() =
    Peron(
//        stationId = stationId,
        peronName = peronName,
        description = description,
        line = stringToList(line)
    )

fun stringToList(line: String): List<String> {
    return line.split(",")
}