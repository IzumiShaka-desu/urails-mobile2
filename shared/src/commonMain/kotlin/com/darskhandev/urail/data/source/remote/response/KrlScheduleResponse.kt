package com.darskhandev.urail.data.source.remote.response

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class KrlScheduleResponse(

	@SerialName("status_code")
	val statusCode: Int,

	@SerialName("data")
	val data: List<ScheduleItem>,

	@SerialName("message")
	val message: String
)

@Serializable
data class ScheduleItem(

	@SerialName("arrival_time")
	val arrivalTime: String,

	@SerialName("ka_id")
	val kaId: String,

	@SerialName("route_name")
	val routeName: String,

	@SerialName("station_id")
	val stationId: String,

	@SerialName("destination_id")
	val destinationId: String,

	@SerialName("origin_id")
	val originId: String,

	@SerialName("ka_name")
	val kaName: String,

	@SerialName("departure_time")
	val departureTime: String
)
