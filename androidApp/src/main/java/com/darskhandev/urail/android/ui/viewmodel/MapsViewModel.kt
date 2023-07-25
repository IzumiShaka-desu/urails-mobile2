package com.darskhandev.urail.android.ui.viewmodel

import android.annotation.SuppressLint
import android.content.Context
import android.location.Geocoder
import android.location.Location
import androidx.compose.runtime.MutableState
import androidx.compose.runtime.mutableStateOf
import androidx.lifecycle.ViewModel
import com.darskhandev.urail.android.utils.Utils
import com.darskhandev.urail.domain.entities.Peron
import com.darskhandev.urail.domain.entities.Station

import com.darskhandev.urail.domain.usecases.UseCases
import com.darskhandev.urail.utils.AppState
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.maps.model.LatLng
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.distinctUntilChanged
import kotlinx.coroutines.flow.transformLatest
import org.koin.core.component.KoinComponent
import java.util.Locale

class MapsViewModel(useCases: UseCases) : ViewModel(), KoinComponent {

    private val initialStation = Station(
        "0",
        "0",
        0.0,
        "0",
        0.0,
    )

    val state: MutableState<Location?> = mutableStateOf(null)
    private val locationMarker = MutableStateFlow(LatLng(0.0, 0.0))
    private val locationArriveMarker = MutableStateFlow(LatLng(0.0, 0.0))

    private val stationNearestDepart = MutableStateFlow(initialStation)
    private val stationNearestArrive = MutableStateFlow(initialStation)

    @OptIn(ExperimentalCoroutinesApi::class)
    val stationNearestDepartState = stationNearestDepart.distinctUntilChanged { old, new -> old == new }
        .transformLatest {
            if (it == initialStation) {
                emit(AppState.NoState())
            } else {
                emit(AppState.Success(it))
            }
        }

    @OptIn(ExperimentalCoroutinesApi::class)
    val stationNearestArriveState = stationNearestArrive.distinctUntilChanged { old, new -> old == new }
        .transformLatest {
            if (it == initialStation) {
                emit(AppState.NoState())
            } else {
                emit(AppState.Success(it))
            }
        }

    @SuppressLint("MissingPermission")
    fun getDeviceLocation(
        fusedLocationProviderClient: FusedLocationProviderClient
    ) {
        try {
            val locationResult = fusedLocationProviderClient.lastLocation
            locationResult.addOnCompleteListener { task ->
                if (task.isSuccessful) {
                    state.value = task.result
                }
            }
        } catch (_: SecurityException) {

        }
    }

    @OptIn(ExperimentalCoroutinesApi::class)
    val locationState = locationMarker.distinctUntilChanged { old, new -> old == new }
        .transformLatest {
            if (it == LatLng(0.0, 0.0)) {
                emit(AppState.NoState())
            } else {
                emit(AppState.Success(it))
            }
        }

    @OptIn(ExperimentalCoroutinesApi::class)
    val locationArriveState = locationArriveMarker.distinctUntilChanged { old, new -> old == new }
        .transformLatest {
            if (it == LatLng(0.0, 0.0)) {
                emit(AppState.NoState())
            } else {
                emit(AppState.Success(it))
            }
        }

    fun setLocationMarker(latLng: LatLng, type: String) {
        if (type == "BERANGKAT") {
            locationMarker.value = latLng
        } else {
            locationArriveMarker.value = latLng
        }
    }

    fun getAddress(context: Context, latLng: LatLng): String {
        val geoCoder = Geocoder(context, Locale.getDefault())
        val address = geoCoder.getFromLocation(latLng.latitude, latLng.longitude, 1)
        return if (!address.isNullOrEmpty()) {
            val addressLine = address[0].getAddressLine(0)
            " $addressLine"
        } else {
            "${latLng.latitude}, ${latLng.longitude}"
        }
    }

    fun getNearbyStation(context: Context, currentLocation: LatLng, type: String) {
        val stations = Utils.getStation(context)
        var nearestStation: Station? = null
        var minDistance = Double.MAX_VALUE

        for (station in stations) {
            val distance = Utils.haversineCalculateDistance(
                currentLocation.latitude,
                currentLocation.longitude,
                station.latitude,
                station.longitude
            )
            if (distance < minDistance) {
                minDistance = distance
                nearestStation = station
            }
        }
        if (type == "BERANGKAT") {
            stationNearestDepart.value = nearestStation!!
        } else {
            stationNearestArrive.value = nearestStation!!
        }
    }
}