package com.darskhandev.urail.data.source.remote.response

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class KrlStationsResponse(

	@SerialName("data")
	val data: List<StationItem>,

	@SerialName("message")
	val message: String,

	@SerialName("status")
	val status: Int
)

@Serializable
data class PeronInfoItem(

	@SerialName("peron_name")
	val peronName: String,

	@SerialName("line")
	val line: List<String>,

	@SerialName("description")
	val description: String
)

@Serializable
data class StationItem(

	@SerialName("station_name")
	val stationName: String,

	@SerialName("station_id")
	val stationId: String,

	@SerialName("latitude")
	val latitude: Double,

	@SerialName("station_type")
	val stationType: String,

	@SerialName("longitude")
	val longitude: Double,

	@SerialName("peron_info")
	val peronInfo: List<PeronInfoItem>
)
