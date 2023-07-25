package com.darskhandev.urail.data.source.remote.models.station
import com.darskhandev.urail.domain.entities.Station
import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable
// class implementation from json
//{
//            "station_id": "WIL1",
//            "station_name": "TANAHABANG",
//            "longitude": 0,
//            "latitude": 0,
//            "station_type": "transit_station"
//        }
@Serializable
data class StationModel (
    @SerialName("station_id")   val stationId: String,
    @SerialName("station_name")   val stationName: String,
    val longitude: Double,
    val latitude: Double,
    @SerialName("station_type")  val stationType: StationType,
    @SerialName("peron_info") val peronInfo: List<PeronInfo>?
)

fun StationModel.asEntity():Station = Station(
    stationId = stationId,
    stationName = stationName,
    longitude = longitude,
    latitude = latitude,
    stationType = stationType.name,
    peronInfo = peronInfo?.map { it.asEntity() }
)

fun List<StationModel>.asEntity():List<Station> = map { it.asEntity() }