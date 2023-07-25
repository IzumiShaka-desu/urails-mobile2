package com.darskhandev.urail.android.ui.navigation

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Map
import androidx.compose.material.icons.filled.TableView
import androidx.compose.material.icons.filled.Train
import androidx.compose.ui.graphics.vector.ImageVector

sealed class Screen(val route: String) {

    object Route : Screen("/route")

    object Maps : Screen("home/maps/{type}") {
        fun createRoute(type: String) = "home/maps/$type"
    }

    object Detail : Screen("/home/{route}") {
        fun createRoute(route: String) = "/home/$route"
    }
}

sealed class BottomNavBarScreen(val route: String, val title: String, val icon: ImageVector) {
    object Home : BottomNavBarScreen(
        route = "/home",
        title = "Utama",
        icon = Icons.Default.Train
    )

    object RouteMap : BottomNavBarScreen(
        route = "/route_map",
        title = "Peta Rute",
        icon = Icons.Default.Map
    )

    object Schedule : BottomNavBarScreen(
        route = "/schedule",
        title = "Jadwal",
        icon = Icons.Default.TableView
    )

}