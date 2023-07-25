package com.darskhandev.urail.data.source.remote.response

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class KrlRouteResponse(

	@SerialName("status_code")
	val statusCode: Int,

	@SerialName("data")
	val data: List<RouteItem>,

	@SerialName("message")
	val message: String
)

@Serializable
data class SchedulesItem(

	@SerialName("childs_route")
	val childsRoute: List<ChildsRouteItem>,

	@SerialName("arrival_time")
	val arrivalTime: String,

	@SerialName("route_name")
	val routeName: String,

	@SerialName("station_id")
	val stationId: String,

	@SerialName("destination_id")
	val destinationId: String,

	@SerialName("KA_name")
	val kAName: String,

	@SerialName("origin_id")
	val originId: String,

	@SerialName("KA_id")
	val kAId: String,

	@SerialName("departure_time")
	val departureTime: String,

	@SerialName("estimated_time")
	val estimatedTime: String,

	@SerialName("neighbour_route")
	val neighbourRoute: List<NeighbourRouteItem>
)

@Serializable
data class ChildsRouteItem(

	@SerialName("childs_route")
	val childsRoute: List<ChildsRouteItem>,

	@SerialName("arrival_time")
	val arrivalTime: String,

	@SerialName("route_name")
	val routeName: String,

	@SerialName("station_id")
	val stationId: String,

	@SerialName("destination_id")
	val destinationId: String,

	@SerialName("KA_name")
	val kAName: String,

	@SerialName("origin_id")
	val originId: String,

	@SerialName("KA_id")
	val kAId: String,

	@SerialName("departure_time")
	val departureTime: String,

	@SerialName("estimated_time")
	val estimatedTime: String,

	@SerialName("neighbour_route")
	val neighbourRoute: List<NeighbourRouteItem>
)

@Serializable
data class RouteItem(

	@SerialName("estimated_distance")
	val estimatedDistance: Float?,

	@SerialName("route_name")
	val routeName: String,

	@SerialName("destination_id")
	val destinationId: String,

	@SerialName("schedules")
	val schedules: List<SchedulesItem>,

	@SerialName("estimated_fare")
	val estimatedFare: Int,

	@SerialName("origin_id")
	val originId: String
)

@Serializable
data class NeighbourRouteItem(

	@SerialName("childs_route")
	val childsRoute: List<ChildsRouteItem>,

	@SerialName("arrival_time")
	val arrivalTime: String,

	@SerialName("route_name")
	val routeName: String,

	@SerialName("station_id")
	val stationId: String,

	@SerialName("destination_id")
	val destinationId: String,

	@SerialName("KA_name")
	val kAName: String,

	@SerialName("origin_id")
	val originId: String,

	@SerialName("KA_id")
	val kAId: String,

	@SerialName("departure_time")
	val departureTime: String,

	@SerialName("estimated_time")
	val estimatedTime: String,

	@SerialName("neighbour_route")
	val neighbourRoute: List<NeighbourRouteItem>
)
