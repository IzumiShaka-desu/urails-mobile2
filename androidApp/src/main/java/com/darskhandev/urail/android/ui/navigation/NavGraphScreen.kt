package com.darskhandev.urail.android.ui.navigation

import android.annotation.SuppressLint
import androidx.compose.material.BottomNavigation
import androidx.compose.material.BottomNavigationItem
import androidx.compose.material.Icon
import androidx.compose.material.MaterialTheme
import androidx.compose.material.Text
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Map
import androidx.compose.material.icons.filled.TableView
import androidx.compose.material.icons.filled.Train
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.text.style.TextOverflow
import androidx.navigation.NavController
import androidx.navigation.NavDestination.Companion.hierarchy
import androidx.navigation.NavGraphBuilder
import androidx.navigation.compose.NavHost
import androidx.navigation.NavHostController
import androidx.navigation.NavType
import androidx.navigation.compose.composable
import androidx.navigation.compose.currentBackStackEntryAsState
import androidx.navigation.navArgument
import androidx.navigation.navigation
import com.darskhandev.urail.android.ui.page.HomePage
import com.darskhandev.urail.android.ui.page.MapsPage
import com.darskhandev.urail.android.ui.page.RouteMapPage
import com.darskhandev.urail.android.ui.page.SchedulePage
import com.darskhandev.urail.android.ui.theme.ColorTheme
import com.darskhandev.urail.android.ui.viewmodel.MapsViewModel
import com.darskhandev.urail.viewmodel.HomeViewModel

@Composable
fun NavGraphScreen(navController: NavHostController, mapsViewModel: MapsViewModel) {
    NavHost(
        navController = navController,
        route = GraphNavigation.HOME,
        startDestination = BottomNavBarScreen.Home.route
    )
    {
        composable(route = BottomNavBarScreen.Home.route) {
            HomePage(
                navigateToMap = { type ->
                    navController.navigate(Screen.Maps.createRoute(type))
                },
                mapsViewModel = mapsViewModel,
            )
        }
        composable(route = BottomNavBarScreen.RouteMap.route) {
            RouteMapPage()
        }
        composable(route = BottomNavBarScreen.Schedule.route) {
            SchedulePage()
        }
        details(navController = navController, mapsViewModel = mapsViewModel)
    }
}

fun NavGraphBuilder.details(navController: NavController, mapsViewModel: MapsViewModel) {
    navigation(
        route = GraphNavigation.DETAIL,
        startDestination = Screen.Detail.route
    ) {
        composable(
            route = Screen.Maps.route,
            arguments = listOf(navArgument(name = "type") { type = NavType.StringType })
        ) {
            val type = it.arguments?.getString("type") ?: "TUJUAN"
            MapsPage(
                onNavigateUp = {
                    navController.popBackStack()
                },
                type = type,
                mapsViewModel = mapsViewModel,
            )
        }
        composable(route = Screen.Detail.route) {
        }
        composable(route = Screen.Route.route) {
        }
    }
}

object GraphNavigation {
    const val HOME = "home"
    const val DETAIL = "detail"
}

@Composable
fun BottomNavBar(navController: NavController) {
    val navBackStackEntry by navController.currentBackStackEntryAsState()
    val currentRoute = navBackStackEntry?.destination

    val bottomBarNavRoute = listOf(
        BottomNavBarScreen.Home,
        BottomNavBarScreen.Schedule,
        BottomNavBarScreen.RouteMap,
    )
    val bottomDestination = bottomBarNavRoute.any { it.route == currentRoute?.route }
    if (bottomDestination) {
        BottomNavigation(
            backgroundColor = ColorTheme.darkBlueish,
            contentColor = ColorTheme.mediumDarkBlueish,
        ) {
            bottomBarNavRoute.forEach {
                BottomNavigationItem(
                    icon = { Icon(imageVector = it.icon, contentDescription = null) },
                    selected = currentRoute?.hierarchy?.any { navDes ->
                        navDes.route == it.route
                    } == true,
                    selectedContentColor = ColorTheme.lightBlueWhitish,
                    unselectedContentColor = ColorTheme.mediumDarkBlueish,
                    alwaysShowLabel = true,
                    label = { Text(text = it.title) },
                    onClick = {
                        navController.navigate(it.route) {
                            navController.graph.startDestinationRoute?.let {
                                popUpTo(it) { saveState = true }
                            }
                            launchSingleTop = true
                            restoreState = true
                        }
                    },
                )
            }
        }
    }
}