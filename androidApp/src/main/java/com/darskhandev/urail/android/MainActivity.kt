package com.darskhandev.urail.android

import android.Manifest
import android.annotation.SuppressLint
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.*
import androidx.compose.ui.Modifier
import androidx.core.content.ContextCompat
import androidx.navigation.compose.rememberNavController
import com.darskhandev.urail.android.ui.navigation.BottomNavBar
import com.darskhandev.urail.android.ui.navigation.NavGraphScreen
import com.darskhandev.urail.android.ui.theme.ColorTheme
import com.darskhandev.urail.android.ui.theme.UrailTheme
import com.darskhandev.urail.android.ui.viewmodel.MapsViewModel
import com.darskhandev.urail.viewmodel.HomeViewModel
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import dev.icerock.moko.mvvm.getViewModel
import org.koin.android.ext.android.inject

class MainActivity : ComponentActivity() {

    private val mapsViewModel : MapsViewModel by inject()
    private val requestPermissionLauncher =
        registerForActivityResult(
            ActivityResultContracts.RequestPermission()
        ) { isGranted: Boolean ->
            if (isGranted) {
                mapsViewModel.getDeviceLocation(fusedLocationProviderClient)
            }
        }

    private fun askPermissions() = when {
        ContextCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED -> {
            mapsViewModel.getDeviceLocation(fusedLocationProviderClient)
        }

        else -> {
            requestPermissionLauncher.launch(Manifest.permission.ACCESS_FINE_LOCATION)
        }
    }



    private lateinit var fusedLocationProviderClient: FusedLocationProviderClient

    @SuppressLint("UnusedMaterialScaffoldPaddingParameter", "StateFlowValueCalledInComposition")
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        fusedLocationProviderClient = LocationServices.getFusedLocationProviderClient(this)
        askPermissions()
        setContent {
            UrailTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = ColorTheme.darkBlueish
                ) {
                    val navController = rememberNavController()
                    Scaffold(
                        bottomBar = { BottomNavBar(navController = navController) }
                    ) {
                        NavGraphScreen(navController = navController, mapsViewModel = mapsViewModel)
                    }
                }
            }
        }
    }
}
