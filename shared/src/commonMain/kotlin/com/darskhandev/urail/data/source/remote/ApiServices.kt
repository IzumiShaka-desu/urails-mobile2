package com.darskhandev.urail.data.source.remote

import com.darskhandev.urail.data.source.remote.models.MetaResponse
import com.darskhandev.urail.data.source.remote.models.pathfinder.Graph
import com.darskhandev.urail.data.source.remote.models.pathfinder.PathFindingResult
import com.darskhandev.urail.data.source.remote.models.schedule.DetailScheduleRaw
import com.darskhandev.urail.data.source.remote.models.schedule.RouteScheduleRaw
import com.darskhandev.urail.data.source.remote.models.schedule.ScheduleRaw
import com.darskhandev.urail.data.source.remote.models.station.StationModel

interface ApiServices {
    suspend fun getKrlStations() : Result<MetaResponse<List<StationModel>>>
    suspend fun getKrlSchedule(stationId: String, timeFrom: String, timeTo: String) : Result<MetaResponse<List<ScheduleRaw>>>
    suspend fun  getKrlRoute(originStationId: String, destinationStationId: String, departureTime: String) : Result<MetaResponse<PathFindingResult>>
    suspend fun getGraph():Result<MetaResponse<Graph>>
    suspend fun getDetailSchedule(kaId:String):Result<MetaResponse<DetailScheduleRaw>>
    suspend fun getRouteSchedule(routes:List<String>,timeFrom: String):Result<MetaResponse<List<RouteScheduleRaw>>>

}