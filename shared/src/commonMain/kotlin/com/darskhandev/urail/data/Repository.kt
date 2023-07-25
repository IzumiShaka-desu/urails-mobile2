package com.darskhandev.urail.data

import com.darskhandev.urail.data.source.remote.ApiServices
import com.darskhandev.urail.data.source.remote.RemoteDataSource
import com.darskhandev.urail.data.source.remote.models.pathfinder.Graph
import com.darskhandev.urail.data.source.remote.models.pathfinder.asEntity
import com.darskhandev.urail.data.source.remote.models.schedule.DetailScheduleRaw
import com.darskhandev.urail.data.source.remote.models.schedule.ListRouteScheduleRaw
import com.darskhandev.urail.data.source.remote.models.schedule.RouteScheduleRaw
import com.darskhandev.urail.data.source.remote.models.schedule.mapToListSchedule
import com.darskhandev.urail.domain.entities.Route
import com.darskhandev.urail.domain.entities.Schedule
import com.darskhandev.urail.domain.entities.ScheduleList
import com.darskhandev.urail.domain.entities.Station
import com.darskhandev.urail.domain.entities.StationList
import com.darskhandev.urail.domain.repositories.IRepository
import com.darskhandev.urail.utils.AppState
import com.darskhandev.urail.utils.mapToListStation
//import com.darskhandev.urail.utils.mapToListRoute
//import com.darskhandev.urail.utils.mapToListSchedule
//import com.darskhandev.urail.utils.mapToListStation
import kotlinx.coroutines.Dispatchers

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn

class Repository(
    private val remoteDataSource: ApiServices,
) : IRepository {
    override fun getKrlStations(): Flow<AppState<StationList>> {
        return flow<AppState<StationList>> {
            emit(AppState.Loading())
            val data = remoteDataSource.getKrlStations()

            data.onFailure {
                emit(AppState.Error(it.message!!))
            }
                .onSuccess {
                    if (it.statusCode != 200) {
                        emit(AppState.Error(it.message))
                    } else {
                        it.data?.let { data ->
                            emit(AppState.Success(StationList(data.mapToListStation())))
                        }
//                            .run {
//                            emit(AppState.Error("Data is null"))
//                        }

                    }
                }
        }.flowOn(Dispatchers.Default )
    }

    override fun getKrlSchedule(
        stationId: String,
        timeFrom: String,
        timeTo: String
    ): Flow<AppState<ScheduleList>> {
        return flow<AppState<ScheduleList>> {
            emit(AppState.Loading())
            val data = remoteDataSource.getKrlSchedule(stationId, timeFrom, timeTo)

            data.onFailure {
                emit(AppState.Error(it.message!!))
            }
                .onSuccess {
                    if (it.statusCode != 200) {
                        emit(AppState.Error(it.message))
                    } else {
                        it.data?.let { data ->
                            emit(AppState.Success(ScheduleList(data.mapToListSchedule())))
                        }
//                            .run {
//                            emit(AppState.Error("MONCROT"))
//                        }
                    }
                }
        }.flowOn(Dispatchers.Default)
    }

    override fun getKrlRoute(
        originStationId: String,
        destinationStationId: String,
        departureTime: String
    ): Flow<AppState<Route>> {
        return flow<AppState<Route>> {
            emit(AppState.Loading())
            val data =
                remoteDataSource.getKrlRoute(originStationId, destinationStationId, departureTime)

            data.onFailure {
                emit(AppState.Error(it.message!!))
            }
                .onSuccess {
                    if (it.statusCode != 200) {
                        emit(AppState.Error(it.message))
                    } else {
                        it.data?.let { data ->
                            emit(AppState.Success(data.asEntity()))
                        }
//                            .run {
//                            emit(AppState.Error("Data is null"))
//                        }
                    }
                }
        }.flowOn(Dispatchers.Default)
    }

    override fun getGraph(): Flow<AppState<Graph>> {
        return flow<AppState<Graph>> {
            emit(AppState.Loading())
            val data = remoteDataSource.getGraph()

            data.onFailure {
                emit(AppState.Error(it.message!!))
            }
                .onSuccess {
                    if (it.statusCode != 200) {
                        emit(AppState.Error(it.message))
                    } else {
                        it.data?.let { data ->
                            emit(AppState.Success(data))
                        }
//                            .run {
//                            emit(AppState.Error("Data is null"))
//                        }
                    }
                }
        }.flowOn(Dispatchers.Default)
    }

    override fun getDetailSchedule(kaId: String): Flow<AppState<DetailScheduleRaw>> {
        return flow<AppState<DetailScheduleRaw>> {
            emit(AppState.Loading())
            val data = remoteDataSource.getDetailSchedule(kaId)

            data.onFailure {
                emit(AppState.Error(it.message!!))
            }
                .onSuccess {
                    if (it.statusCode != 200) {
                        emit(AppState.Error(it.message))
                    } else {
                        it.data?.let { data ->
                            emit(AppState.Success(data))
                        }
//                            .run {
//                            emit(AppState.Error("Data TOTOL null"))
//                        }
                    }
                }
        }.flowOn(Dispatchers.Default)
    }

    override fun getRouteSchedule(
        routes: List<String>,
        timeFrom: String
    ): Flow<AppState<ListRouteScheduleRaw>> {
        return flow<AppState<ListRouteScheduleRaw>> {
            emit(AppState.Loading())
            val data = remoteDataSource.getRouteSchedule(routes, timeFrom)

            data.onFailure {
                emit(AppState.Error(it.message!!))
            }
                .onSuccess {
                    if (it.statusCode != 200) {
                        emit(AppState.Error(it.message))
                    } else {
                        it.data?.let { data ->
                            emit(AppState.Success(ListRouteScheduleRaw(data)))
                        }
//                            .run {
//                            emit(AppState.Error("Data is null"))
//                        }
                    }
                }
        }.flowOn(Dispatchers.Default)
    }
}