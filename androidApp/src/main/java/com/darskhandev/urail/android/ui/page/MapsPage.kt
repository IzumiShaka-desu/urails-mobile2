package com.darskhandev.urail.android.ui.page

import android.location.Location
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Button
import androidx.compose.material.ButtonDefaults
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import com.darskhandev.urail.android.MainActivity
import com.darskhandev.urail.android.ui.theme.ColorTheme
import com.darskhandev.urail.android.ui.viewmodel.MapsViewModel
import com.google.android.gms.maps.model.CameraPosition
import com.google.android.gms.maps.model.LatLng
import com.google.maps.android.compose.GoogleMap
import com.google.maps.android.compose.MapProperties
import com.google.maps.android.compose.Marker
import com.google.maps.android.compose.rememberCameraPositionState
import com.google.maps.android.compose.rememberMarkerState

@Composable
fun MapsPage(
    type: String,
    onNavigateUp: (LatLng) -> Unit,
    mapsViewModel: MapsViewModel,
) {
    val context = LocalContext.current
    val lastKnownLocation = mapsViewModel.state.value
    val jakarta = LatLng(-6.200000, 106.816666)
    val cameraPositionState = rememberCameraPositionState {
            position = if (type == "BERANGKAT" && lastKnownLocation != null) {
            CameraPosition.fromLatLngZoom(
                LatLng(
                    lastKnownLocation.latitude,
                    lastKnownLocation.longitude
                ), 16f
            )
        } else {
            CameraPosition.fromLatLngZoom(
                LatLng(
                    jakarta.latitude,
                    jakarta.longitude
                ), 16f
            )
        }
    }
    var position: LatLng? = null
    position = if (type == "BERANGKAT" && lastKnownLocation != null) {
        LatLng(
            lastKnownLocation.latitude,
            lastKnownLocation.longitude
        )
    } else {
        LatLng(
            jakarta.latitude,
            jakarta.longitude
        )
    }
    val markerState = rememberMarkerState(
        position = position!!
    )
    val markerPosition = markerState.position
    Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.BottomCenter) {
        GoogleMap(
            modifier = Modifier.fillMaxSize(),
            cameraPositionState = cameraPositionState,
        ) {
            Marker(
                state = markerState,
                title = type,
                draggable = true,
            )
        }
        Column(horizontalAlignment = Alignment.CenterHorizontally, verticalArrangement = Arrangement.SpaceBetween, modifier = Modifier.fillMaxHeight()) {
            Surface(
                modifier = Modifier
                    .padding(horizontal = 12.dp, vertical = 8.dp)
                    .padding(top = 12.dp),
                color = Color.White.copy(alpha = 0.5F),
                shape = RoundedCornerShape(8.dp)
            ) {
                Text(
                    text = "Tahan dan Geser Marker Untuk Mengubah Lokasi",
                    color = Color.Black,
                    modifier = Modifier.padding(8.dp)
                )
            }
            Button(
                onClick = {
                    mapsViewModel.setLocationMarker(markerPosition, type = type)
                    mapsViewModel.getNearbyStation(currentLocation =  markerPosition, type = type, context = context)
                    onNavigateUp(markerPosition)
                },
                shape = RoundedCornerShape(8.dp),
                colors = ButtonDefaults.buttonColors(
                  backgroundColor = ColorTheme.mediumDarkBlueish,
                  contentColor = Color.White,
                ),
                modifier = Modifier
                    .padding(vertical = 8.dp, horizontal = 12.dp),
            ) {
                Text(text = "Oke")
            }
        }
    }
}