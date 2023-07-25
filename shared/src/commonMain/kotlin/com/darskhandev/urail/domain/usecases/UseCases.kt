package com.darskhandev.urail.domain.usecases

import com.darskhandev.urail.data.source.remote.models.pathfinder.Graph
import com.darskhandev.urail.data.source.remote.models.schedule.DetailScheduleRaw
import com.darskhandev.urail.data.source.remote.models.schedule.ListRouteScheduleRaw
import com.darskhandev.urail.data.source.remote.models.schedule.RouteScheduleRaw
import com.darskhandev.urail.domain.entities.Route
import com.darskhandev.urail.domain.entities.Schedule
import com.darskhandev.urail.domain.entities.ScheduleList
import com.darskhandev.urail.domain.entities.Station
import com.darskhandev.urail.domain.entities.StationList
import com.darskhandev.urail.utils.AppState
import kotlinx.coroutines.flow.Flow

interface UseCases {
    fun getKrlStations(): Flow<AppState<StationList>>
    fun getKrlSchedule(stationId: String, timeFrom: String, timeTo: String): Flow<AppState<ScheduleList>>
    fun getKrlRoute(originStationId: String, destinationStationId: String, departureTime: String): Flow<AppState<Route>>
    fun getGraph(): Flow<AppState<Graph>>
    fun getDetailSchedule(kaId:String): Flow<AppState<DetailScheduleRaw>>
    fun getRouteSchedule(routes:List<String>,timeFrom: String): Flow<AppState<ListRouteScheduleRaw>>
}