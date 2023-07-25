package com.darskhandev.urail.viewmodel

import com.darskhandev.urail.data.source.remote.models.pathfinder.Graph
import com.darskhandev.urail.data.source.remote.models.pathfinder.findNearestStation
import com.darskhandev.urail.data.source.remote.models.schedule.DetailScheduleRaw
import com.darskhandev.urail.data.source.remote.models.schedule.RouteScheduleRaw
import com.darskhandev.urail.domain.entities.Route
import com.darskhandev.urail.domain.entities.Schedule
import com.darskhandev.urail.domain.entities.Station
import com.darskhandev.urail.domain.entities.StationList
import com.darskhandev.urail.domain.usecases.UseCases
import com.darskhandev.urail.utils.AppState
import com.darskhandev.urail.utils.GetRouteSchedule
import com.darskhandev.urail.utils.RouteSearch
import com.darskhandev.urail.utils.ScheduleSearch
import dev.icerock.moko.mvvm.viewmodel.ViewModel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharingStarted
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.stateIn
import kotlinx.coroutines.flow.transform
import kotlinx.coroutines.flow.transformLatest
import org.koin.core.component.KoinComponent

class HomeViewModel(
    private val useCases: UseCases,
) : ViewModel(), KoinComponent {
    private val _routeState = MutableStateFlow<AppState<Route>>(AppState.NoState())
    val routeState = _routeState.asStateFlow()
    private val _routeScheduleState =
        MutableStateFlow<AppState<List<RouteScheduleRaw>>>(AppState.NoState())
    val routeScheduleState = _routeScheduleState.asStateFlow()

    private val initialScheduleSearch = ScheduleSearch("", "", "")
    private val scheduleSearch = MutableStateFlow(initialScheduleSearch)

    private val initialGetRoute = RouteSearch("", "", "")
    private val getRouteState = MutableStateFlow(initialGetRoute)
    fun getScheduleSearch(stationId: String, timeFrom: String, timeTo: String) {
        scheduleSearch.value = ScheduleSearch(stationId, timeFrom, timeTo)
    }

    private val kaIdforDetailSchedule = MutableStateFlow("")
    fun setKaIdforDetailSchedule(kaId: String) {
        kaIdforDetailSchedule.value = kaId
    }

    @OptIn(ExperimentalCoroutinesApi::class)
    val getDetailSchedule = kaIdforDetailSchedule.distinctUntilChanged { old, new -> old == new }
        .transformLatest { it ->
            if (it == "") {
                emit(AppState.Error("Please select station and time"))
            } else {
                useCases.getDetailSchedule(it).collect {
                    this.emit(it)
                }
            }
        }

    @OptIn(ExperimentalCoroutinesApi::class)
    val getSchedule = scheduleSearch.distinctUntilChanged { old, new -> old == new }
        .transformLatest { it ->
            if (it == initialScheduleSearch) {
                emit(AppState.Error("Pilih Stasiun dan waktu terlebih dahulu"))
            } else {
                useCases.getKrlSchedule(it.stationId, it.timeFrom, it.timeTo).collect {
                    this.emit(it)
                }
            }
        }

    fun setRouteSearch(originStationId: String, destinationStationId: String, departureTime: String) {
        getRouteState.value = RouteSearch(originStationId, destinationStationId, departureTime)
    }

    fun findRoute(originLat: Double, originLng: Double, destinationLat: Double, destinationLng: Double, departureTime: String) {
        val originStationId = getGraph.value.data?.findNearestStation(originLat, originLng)?.stationId
        val destinationStationId = getGraph.value.data?.findNearestStation(destinationLat, destinationLng)?.stationId
        if (originStationId == null || destinationStationId == null) {
            _routeState.value = AppState.Error("Anda Sepertinya berada di luar area KRL")
            return
        }
        getRouteState.value = RouteSearch(originStationId, destinationStationId, departureTime)
    }

    @OptIn(ExperimentalCoroutinesApi::class)
    val getRoute = getRouteState.distinctUntilChanged { old, new -> old == new }
        .transformLatest { it ->
            if (it == initialGetRoute) {
                emit(AppState.Error("Ayo Berangkat"))
            } else {
                useCases.getKrlRoute(it.originStationId, it.destinationStationId, it.departureTime)
                    .collect {
                        this.emit(it)
                    }
            }
        }

    val getStationList: StateFlow<AppState<StationList>> =
        useCases.getKrlStations().stateIn(
            viewModelScope,
            SharingStarted.Lazily,
            AppState.NoState()
        )

    val getGraph: StateFlow<AppState<Graph>> =
        useCases.getGraph().stateIn(
            viewModelScope,
            SharingStarted.Lazily,
            AppState.NoState()
        )

    private val initialGetRouteSchedule = GetRouteSchedule(emptyList(), "")
    private val getRouteScheduleState = MutableStateFlow(initialGetRouteSchedule)
    fun setRouteSchedule(routesId: List<String>, timeFrom: String) {
        getRouteScheduleState.value = GetRouteSchedule(routesId, timeFrom)
    }
    @OptIn(ExperimentalCoroutinesApi::class)
    val getRouteSchedule = getRouteScheduleState.distinctUntilChanged{ old, new -> old == new }
        .transformLatest { it ->
            if (it == initialGetRouteSchedule) {
                emit(AppState.Error("Ayo Berangkat"))
            } else {
                useCases.getRouteSchedule(it.routes, it.timeFrom).collect {
                    this.emit(it)
                }
            }
        }
}