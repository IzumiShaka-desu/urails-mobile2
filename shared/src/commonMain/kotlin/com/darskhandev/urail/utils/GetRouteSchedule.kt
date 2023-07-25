package com.darskhandev.urail.utils

import com.darskhandev.urail.data.source.remote.models.MetaResponse
import com.darskhandev.urail.data.source.remote.models.schedule.DetailScheduleItemRaw
import com.darskhandev.urail.data.source.remote.models.schedule.ListRouteScheduleRaw
import com.darskhandev.urail.data.source.remote.models.schedule.RouteScheduleRaw
import kotlinx.serialization.json.Json

data class GetRouteSchedule(
    val routes: List<String>,
    val timeFrom: String,
)


//using kotlin serialization

fun GetRouteSchedule.getDummyData(): List<RouteScheduleRaw> {
//create dummy data based on jsonString manually

    return routeScheduleList
}
//val  routeSchedule = dummyData.data

