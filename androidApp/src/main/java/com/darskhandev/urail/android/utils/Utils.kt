package com.darskhandev.urail.android.utils

import android.content.Context
import com.darskhandev.urail.domain.entities.Station
import com.google.gson.Gson
import java.text.SimpleDateFormat
import java.time.LocalTime
import java.time.format.DateTimeFormatter
import java.util.Calendar
import java.util.Locale
import kotlin.math.asin
import kotlin.math.atan2
import kotlin.math.cos
import kotlin.math.pow
import kotlin.math.sin
import kotlin.math.sqrt

object Utils {
    fun haversineCalculateDistance(
        lat1: Double,
        lon1: Double,
        lat2: Double,
        lon2: Double
    ): Double {
        val R = 6372.8 // Earth Rad in kilometers
        val dLat = Math.toRadians(lat2 - lat1)
        val dLon = Math.toRadians(lon2 - lon1)
        val a = sin(dLat / 2).pow(2) +
                cos(Math.toRadians(lat1)) * cos(Math.toRadians(lat2)) *
                sin(dLon / 2).pow(2)
        val c = 2 * asin(sqrt(a))
        return R * c
    }
    fun haversineDistance(lat1: Double, lon1: Double, lat2: Double, lon2: Double): Double {
        val radius = 6371 // Radius Bumi dalam kilometer

        val lat1Rad = Math.toRadians(lat1)
        val lon1Rad = Math.toRadians(lon1)
        val lat2Rad = Math.toRadians(lat2)
        val lon2Rad = Math.toRadians(lon2)

        val deltaLat = lat2Rad - lat1Rad
        val deltaLon = lon2Rad - lon1Rad

        val a = sin(deltaLat / 2).pow(2) + cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2).pow(2)
        val c = 2 * atan2(sqrt(a), sqrt(1 - a))

        return radius * c
    }

    fun getStation(context: Context) : List<Station> {
        val inputStream = context.assets.open("stations.json")
        val jsonString = inputStream.bufferedReader().use { it.readText() }
        val json = Gson().fromJson(jsonString, StationsDataJson::class.java)
        return json.stationsDataJson!!.map {
            Station(
                stationName = it!!.stationName!!,
                stationId = it.stationId!!,
                latitude = it.latitude!! as Double,
                stationType = it.stationType!!,
                longitude = it.longitude!! as Double
            )
        }
    }

    fun getStationNameById(stationId: String, context: Context): String? {
        val getStation = getStation(context).find {
            it.stationId == stationId
        }
        return getStation?.stationName
    }
    fun formatTime(hour: Int, minute: Int): String {
        val calendar = Calendar.getInstance()
        calendar.set(Calendar.HOUR_OF_DAY, hour)
        calendar.set(Calendar.MINUTE, minute)

        val dateFormat = SimpleDateFormat("HH:mm", Locale.getDefault())
        return dateFormat.format(calendar.time)
    }

    fun convertTimeFormat(timeString: String): String {
        val parts = timeString.split(":")
        return if (parts.size >= 2) {
            val hour = parts[0]
            val minute = parts[1]
            "$hour:$minute"
        } else {
            timeString
        }
    }
}