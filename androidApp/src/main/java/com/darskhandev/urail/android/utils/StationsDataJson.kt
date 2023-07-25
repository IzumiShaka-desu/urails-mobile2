package com.darskhandev.urail.android.utils

import com.google.gson.annotations.SerializedName

data class StationsDataJson(
	@field:SerializedName("stations")
	val stationsDataJson: List<StationsDataJsonItem?>? = null
)

data class StationsDataJsonItem(

	@field:SerializedName("station_name")
	val stationName: String? = null,

	@field:SerializedName("station_id")
	val stationId: String? = null,

	@field:SerializedName("latitude")
	val latitude: Double? = null,

	@field:SerializedName("type")
	val type: String? = null,

	@field:SerializedName("station_type")
	val stationType: String? = null,

	@field:SerializedName("longitude")
	val longitude: Double? = null
)
