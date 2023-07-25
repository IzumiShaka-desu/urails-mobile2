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
import com.darskhandev.urail.domain.repositories.IRepository
import com.darskhandev.urail.utils.AppState
import kotlinx.coroutines.flow.Flow

class Interactor(
    private val repository: IRepository
) : UseCases {
    override fun getKrlStations(): Flow<AppState<StationList>> {
        return repository.getKrlStations()
    }

    override fun getKrlSchedule(stationId: String, timeFrom: String, timeTo: String): Flow<AppState<ScheduleList>> {
        return repository.getKrlSchedule(stationId, timeFrom, timeTo)
    }

    override fun getKrlRoute(originStationId: String, destinationStationId: String, departureTime: String): Flow<AppState<Route>> {
        return repository.getKrlRoute(originStationId, destinationStationId, departureTime)
    }

    override fun getGraph(): Flow<AppState<Graph>> {
        return repository.getGraph()
    }

    override fun getDetailSchedule(kaId: String): Flow<AppState<DetailScheduleRaw>> {
        return repository.getDetailSchedule(kaId)
    }

    override fun getRouteSchedule(
        routes: List<String>,
        timeFrom: String
    ): Flow<AppState<ListRouteScheduleRaw>> {
        return repository.getRouteSchedule(routes, timeFrom)
    }
}