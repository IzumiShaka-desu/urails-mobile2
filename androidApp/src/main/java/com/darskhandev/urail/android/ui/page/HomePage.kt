package com.darskhandev.urail.android.ui.page

import android.app.TimePickerDialog
import androidx.activity.compose.BackHandler
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Button
import androidx.compose.material.ButtonDefaults
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.material.ExperimentalMaterialApi
import androidx.compose.material.Icon
import androidx.compose.material.ModalBottomSheetLayout
import androidx.compose.material.ModalBottomSheetValue
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AddLocation
import androidx.compose.material.icons.filled.History
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.material.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Color.Companion.Transparent
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.darskhandev.urail.android.R
import com.darskhandev.urail.android.ui.component.RouteMainItem
import com.darskhandev.urail.android.ui.component.SearchPlaceRow
import com.darskhandev.urail.android.ui.component.TimeLine
import com.darskhandev.urail.android.ui.theme.ColorTheme
import com.darskhandev.urail.android.ui.viewmodel.MapsViewModel
import com.darskhandev.urail.android.utils.Utils
import com.darskhandev.urail.data.source.remote.models.schedule.RouteScheduleRaw
import com.darskhandev.urail.data.source.remote.models.station.StationType
import com.darskhandev.urail.domain.entities.Route
import com.darskhandev.urail.utils.AppState
import com.darskhandev.urail.viewmodel.HomeViewModel
import kotlinx.coroutines.launch
import me.sungbin.timelineview.TimeLineItem
import me.sungbin.timelineview.TimeLineOption
import org.koin.androidx.compose.getViewModel
import java.util.Calendar

@OptIn(ExperimentalMaterialApi::class)
@Composable
fun HomePage(
    navigateToMap: (String) -> Unit,
    mapsViewModel: MapsViewModel,
    homeViewModel: HomeViewModel = getViewModel()
) {
    val context = LocalContext.current
    val calendar = Calendar.getInstance()
    val hour = calendar.get(Calendar.HOUR_OF_DAY)
    val minute = calendar.get(Calendar.MINUTE)

    val time = remember {
        mutableStateOf("Tentukan Waktu")
    }

    val fare = remember {
        mutableStateOf("Biaya")
    }

    val berangkat = "BERANGKAT"
    val tujuan = "TUJUAN"

    val timePicker = TimePickerDialog(
        context,
        { _, hourOfDay, minutes ->
            time.value = Utils.formatTime(hour = hourOfDay, minute = minutes)
        },
        hour,
        minute,
        true
    )
    Surface(
        color = ColorTheme.darkBlueish,
        modifier = Modifier.fillMaxSize()
    ) {
        val berangkatField = remember {
            mutableStateOf("Tentukan Titik Berangkat")
        }
        val tujuanField = remember {
            mutableStateOf("Tentukan Titik Tujuan")
        }

        val nearestStationArrive = remember {
            mutableStateOf("")
        }
        val nearestStationDepart = remember {
            mutableStateOf("")
        }
        mapsViewModel.locationState.collectAsState(initial = AppState.NoState()).value.let {
            when (it) {
                is AppState.Success -> {
                    val address =
                        it.data?.let { it1 ->
                            mapsViewModel.getAddress(
                                context,
                                it1
                            )
                        }

                    if (address != null) {
                        berangkatField.value = address
                    }
                }

                else -> {}
            }
        }
        mapsViewModel.locationArriveState.collectAsState(initial = AppState.NoState()).value.let {
            when (it) {
                is AppState.Success -> {
                    val address =
                        it.data?.let { it1 ->
                            mapsViewModel.getAddress(
                                context,
                                it1
                            )
                        }

                    if (address != null) {
                        tujuanField.value = address
                    }
                }

                else -> {}
            }
        }

        mapsViewModel.stationNearestDepartState.collectAsState(initial = AppState.NoState()).value.let {
            when (it) {
                is AppState.Success -> {
                    nearestStationDepart.value = it.data?.stationId.toString()
                }

                else -> {}
            }
        }
        mapsViewModel.stationNearestArriveState.collectAsState(initial = AppState.NoState()).value.let {
            when (it) {
                is AppState.Success -> {
                    nearestStationArrive.value = it.data?.stationId.toString()
                }

                else -> {}
            }
        }
        Surface(
            modifier = Modifier
                .fillMaxSize(),
//            shape = RoundedCornerShape(topStart = 25.dp, topEnd = 25.dp),
            color = Transparent

        ) {
            val coroutineScope = rememberCoroutineScope()
            val modalBottomSheetState = rememberModalBottomSheetState(
                initialValue = ModalBottomSheetValue.Hidden,
                confirmValueChange = {
                    it != ModalBottomSheetValue.HalfExpanded
                },
                skipHalfExpanded = true
            )
            BackHandler(
                enabled = modalBottomSheetState.isVisible,
                onBack = {
                    coroutineScope.launch {
                        modalBottomSheetState.hide()
                    }
                }
            )
            ModalBottomSheetLayout(
                sheetBackgroundColor = ColorTheme.mediumDarkBlueish,
                sheetState = modalBottomSheetState,
                sheetShape = RoundedCornerShape(topStart = 16.dp, topEnd = 16.dp),
                sheetContent = {
                    homeViewModel.getRouteSchedule.collectAsState(initial = AppState.NoState()).value.let {
                        when (it) {
                            is AppState.Loading -> {
                                Surface(
                                    color = ColorTheme.mediumDarkBlueish,
                                ) {
                                    Box(
                                        contentAlignment = Alignment.Center,

                                        modifier = Modifier.fillMaxSize()
                                    ) {
                                        CircularProgressIndicator(
                                            color = ColorTheme.darkBlueish
                                        )
                                    }
                                }
                            }
                            is AppState.Success -> {
                                it.data?.let { it1 -> RouteDetailSheetContent(routeScheduleRaw = it1) }
                            }

                            is AppState.Error -> {
                                Surface(color = ColorTheme.mediumDarkBlueish) {
                                    Box(
                                        contentAlignment = Alignment.Center,
                                        modifier = Modifier.fillMaxSize()
                                    ) {
                                        Text(text = it.message.toString())
                                    }
                                }
                            }

                            is AppState.NoState -> {
                                Box(
                                    contentAlignment = Alignment.Center,
                                    modifier = Modifier.fillMaxSize()
                                ) {
                                    Text(text = "No State")
                                }
                            }
                        }
                    }
                }
            ) {
                Column {
                    Row(
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        Column() {
                            SearchPlaceRow(
                                icon = {
                                    Icon(
                                        imageVector = Icons.Default.LocationOn,
                                        contentDescription = null,
                                        tint = ColorTheme.lightBlueish,
                                        modifier = Modifier.size(32.dp)
                                    )
                                },
                                onClick = { navigateToMap(berangkat) },
                                textValue = berangkatField.value
                            )
                            SearchPlaceRow(
                                icon = {
                                    Icon(
                                        imageVector = Icons.Default.AddLocation,
                                        contentDescription = null,
                                        tint = ColorTheme.lightBlueish,
                                        modifier = Modifier.size(32.dp)
                                    )
                                },
                                onClick = { navigateToMap(tujuan) },
                                textValue = tujuanField.value
                            )
                            Row(
                                modifier = Modifier
                                    .padding(end = 12.dp)
                                    .fillMaxWidth(),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically,
                            ) {
                                Surface(
                                    color = Color.Transparent,
                                    modifier = Modifier
                                        .padding(top = 12.dp, start = 12.dp)
                                        .clip(RoundedCornerShape(size = 20.dp))
                                        .clickable { timePicker.show() },
                                ) {
                                    Row(
                                        verticalAlignment = Alignment.CenterVertically,
                                    ) {
                                        Icon(
                                            Icons.Default.History,
                                            contentDescription = null,
                                            tint = ColorTheme.lightBlueish,
                                            modifier = Modifier.size(32.dp)
                                        )
                                        Text(
                                            modifier = Modifier.padding(
                                                horizontal = 12.dp,
                                                vertical = 8.dp,
                                            ),
                                            text = time.value,
                                            style = TextStyle(
                                                color = ColorTheme.lightBlueWhitish,
                                                fontSize = 16.sp,
                                                fontWeight = FontWeight.SemiBold
                                            )
                                        )
                                    }
                                }
                                Button(
                                    shape = RoundedCornerShape(20.dp),
                                    onClick = {
                                        homeViewModel.setRouteSearch(
                                            originStationId = nearestStationDepart.value,
                                            destinationStationId = nearestStationArrive.value,
                                            departureTime = time.value
                                        )
                                    },
                                    colors = ButtonDefaults.buttonColors(
                                        backgroundColor = Color(0xFF009688),
                                        contentColor = Color.White
                                    )
                                ) {
                                    Text(
                                        text = "Berangkat",
                                        style = TextStyle(
                                            color = Color.White,
                                            fontSize = 16.sp,
                                            fontWeight = FontWeight.Bold
                                        )
                                    )
                                }
                            }
                        }
                    }
                    homeViewModel.getRoute.collectAsState(initial = AppState.NoState()).value.let {
                        when (it) {
                            is AppState.NoState -> {
                                Box(
                                    contentAlignment = Alignment.Center,
                                    modifier = Modifier.fillMaxSize()
                                ) {
                                    CircularProgressIndicator(
                                        color = ColorTheme.darkBlueish
                                    )
                                }
                            }

                            is AppState.Loading -> {
                                Surface(
                                    modifier = Modifier
                                        .padding(top = 16.dp)
                                        .fillMaxSize(),
                                    shape = RoundedCornerShape(topStart = 25.dp, topEnd = 25.dp),
                                    color = ColorTheme.mediumDarkBlueish
                                ) {
                                    Column {
                                        Row(
                                            modifier = Modifier.fillMaxWidth(),
                                            horizontalArrangement = Arrangement.SpaceBetween
                                        ) {
                                            Surface(
                                                color = Color.Transparent,
                                                modifier = Modifier
                                                    .padding(
                                                        top = 12.dp,
                                                        end = 12.dp,
                                                        start = 12.dp
                                                    )
                                            ) {
                                                Row(
                                                    verticalAlignment = Alignment.CenterVertically,
                                                ) {
                                                    Image(
                                                        painter = painterResource(id = R.drawable.ic_cost_coin),
                                                        contentDescription = null,
                                                        modifier = Modifier.size(30.dp)
                                                    )
                                                    Text(
                                                        modifier = Modifier.padding(
                                                            horizontal = 12.dp,
                                                            vertical = 8.dp,
                                                        ),
                                                        text = fare.value,
                                                        style = TextStyle(
                                                            color = ColorTheme.lightBlueWhitish,
                                                            fontSize = 16.sp,
                                                            fontWeight = FontWeight.SemiBold
                                                        )
                                                    )
                                                }
                                            }
                                        }
                                        Surface(
                                            modifier = Modifier
                                                .padding(top = 16.dp)
                                                .fillMaxSize(),
                                            shape = RoundedCornerShape(
                                                topStart = 25.dp,
                                                topEnd = 25.dp
                                            ),
                                            color = ColorTheme.lightBlueish
                                        ) {
                                            Box(
                                                contentAlignment = Alignment.Center,
                                                modifier = Modifier.fillMaxSize()
                                            ) {
                                                CircularProgressIndicator(
                                                    color = ColorTheme.darkBlueish
                                                )
                                            }
                                        }
                                    }
                                }
                            }

                            is AppState.Success -> {
                                fare.value = it.data!!.fare.toString()
                                Surface(
                                    modifier = Modifier
                                        .padding(top = 16.dp)
                                        .fillMaxSize(),
                                    shape = RoundedCornerShape(topStart = 25.dp, topEnd = 25.dp),
                                    color = ColorTheme.mediumDarkBlueish
                                ) {
                                    Column {
                                        Row(
                                            modifier = Modifier.fillMaxWidth(),
                                            horizontalArrangement = Arrangement.SpaceBetween
                                        ) {
                                            Surface(
                                                color = Color.Transparent,
                                                modifier = Modifier
                                                    .padding(
                                                        top = 12.dp,
                                                        end = 12.dp,
                                                        start = 12.dp
                                                    )
                                            ) {
                                                Row(
                                                    verticalAlignment = Alignment.CenterVertically,
                                                ) {
                                                    Image(
                                                        painter = painterResource(id = R.drawable.ic_cost_coin),
                                                        contentDescription = null,
                                                        modifier = Modifier.size(30.dp)
                                                    )
                                                    Text(
                                                        modifier = Modifier.padding(
                                                            horizontal = 12.dp,
                                                            vertical = 8.dp,
                                                        ),
                                                        text = fare.value,
                                                        style = TextStyle(
                                                            color = ColorTheme.lightBlueWhitish,
                                                            fontSize = 16.sp,
                                                            fontWeight = FontWeight.SemiBold
                                                        )
                                                    )
                                                }
                                            }
                                        }
                                        Surface(
                                            modifier = Modifier
                                                .padding(top = 16.dp)
                                                .fillMaxSize(),
                                            shape = RoundedCornerShape(
                                                topStart = 25.dp,
                                                topEnd = 25.dp
                                            ),
                                            color = ColorTheme.lightBlueish
                                        ) {
                                            Column {
                                                RouteListPage(listRoute = it.data!!,homeViewModel = homeViewModel, timeFrom = time.value, onItemClick = {
                                                    coroutineScope.launch {
                                                        modalBottomSheetState.show()
                                                    }
                                                })
                                            }
                                        }
                                    }
                                }
                            }

                            is AppState.Error -> {
                                Box(
                                    contentAlignment = Alignment.Center,
                                    modifier = Modifier.fillMaxSize()
                                ) {
                                    Text(text = it.message.toString())
                                }
                            }

                            else -> {
                                Box(
                                    contentAlignment = Alignment.Center,
                                    modifier = Modifier.fillMaxSize()
                                ) {
                                    Text(text = "Terjadi eksalahan")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun RouteListPage(
    listRoute: Route,
    homeViewModel: HomeViewModel,
    timeFrom: String,
    onItemClick: () -> Unit
) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .clip(RoundedCornerShape(topStart = 25.dp, topEnd = 25.dp))
            .padding(top = 8.dp, start = 16.dp, end = 16.dp, bottom = 52.dp)
    ) {
        val recommendedRoute = listRoute.routes[0]
        val altRoute = listRoute.routes.subList(1, listRoute.routes.size)
        item {
            Text(
                text = "Rute Terdekat",
                modifier = Modifier.padding(8.dp),
                style = TextStyle(
                    color = Color.White,
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Bold
                )
            )
        }
        item {
            RouteMainItem(
                stationFrom = recommendedRoute.first().stationName,
                stationTo = recommendedRoute.last().stationName,
                elapsedTime = "1 Hour 30 Minutes",
                onItemClick = {
                    val stationsId = recommendedRoute.map { it.stationId }
                    homeViewModel.setRouteSchedule(
                        routesId = stationsId,
                        timeFrom = timeFrom
                    )
                    onItemClick()
                }
            )
        }
        item {
            Text(
                text = "Rute Alternatif",
                modifier = Modifier.padding(8.dp),
                style = TextStyle(
                    color = Color.White,
                    fontSize = 20.sp,
                    fontWeight = FontWeight.Bold
                )
            )
        }
        items(altRoute.size) { thisRoute ->
            val route = altRoute[thisRoute]
            RouteMainItem(
                stationFrom = route.first().stationName,
                stationTo = route.last().stationName,
                elapsedTime = "",
                onItemClick =  {
                    val stationsId = route.map { it.stationId }
                    homeViewModel.setRouteSchedule(
                        routesId = stationsId,
                        timeFrom = timeFrom
                    )
                    onItemClick()
                }
            )
        }
    }
}

@Composable
fun RouteDetailSheetContent(
    routeScheduleRaw: List<RouteScheduleRaw>
) {
    Surface(
        color = ColorTheme.darkBlueish,
    ) {
        Column(
            modifier = Modifier.fillMaxSize()
        ) {
            val routeScheduleRecommendation = routeScheduleRaw[0]

            data class LineItem(
                override val key: String,
                val stationName: String,
                val stationType: StationType,
                val timeAtStation: String,
            ) : TimeLineItem<String>

            val scheduleDetailList = mutableListOf<LineItem>()
            for (i in routeScheduleRecommendation.childsRoute) {
                scheduleDetailList.add(
                    LineItem(
                        key = i.kaName,
                        stationName = i.stationName,
                        stationType = i.stationType,
                        timeAtStation = i.timeAtStation
                    )
                )
            }
            TimeLine(
                timeLineOption = TimeLineOption(
                    circleIcon = R.drawable.ic_cost_coin,
                    lineColor = ColorTheme.darkBlueish,
                    circleColor = ColorTheme.darkBlueish
                ),
                modifier = Modifier
                    .background(ColorTheme.mediumDarkBlueish)
                    .padding(horizontal = 24.dp, vertical = 12.dp)
                    .padding(start = 0.dp),
                items = scheduleDetailList,
                header = {
                    Surface(
                        modifier = Modifier
                            .clip(RoundedCornerShape(10.dp)),
                        color = ColorTheme.darkBlueish,
                        contentColor = Color.White,
                    ) {
                        Row(
                            modifier = Modifier
                                .padding(12.dp)
                                .fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                        ) {
                            Column(
                                horizontalAlignment = Alignment.Start,
                            ) {
                                Text(
                                    text = routeScheduleRecommendation.kaId,
                                    style = rowTextStyle(),
                                    maxLines = 1,
                                    overflow = TextOverflow.Ellipsis
                                )
                                Text(
                                    text = routeScheduleRecommendation.routeName,
                                    style = rowTextStyle(),
                                    maxLines = 1,
                                    overflow = TextOverflow.Ellipsis
                                )
                            }
                            Row {
                                Column {
                                    Text(
                                        text = Utils.convertTimeFormat(routeScheduleRecommendation.departureTime),
                                        style = rowTextStyle()
                                    )
                                    Text(
                                        text = Utils.convertTimeFormat(routeScheduleRecommendation.arrivalTime),
                                        style = rowTextStyle()
                                    )
                                }
                                Column(
                                    horizontalAlignment = Alignment.End,
                                    modifier = Modifier.padding(start = 8.dp)
                                ) {
                                    Text(
                                        text = Utils.getStationNameById(
                                            routeScheduleRecommendation.originId,
                                            context = LocalContext.current
                                        ) ?: routeScheduleRecommendation.originId,
                                        style = rowTextStyle(),
                                        maxLines = 1,
                                        overflow = TextOverflow.Ellipsis
                                    )
                                    Text(
                                        text = Utils.getStationNameById(
                                            routeScheduleRecommendation.destinationId,
                                            context = LocalContext.current
                                        ) ?: routeScheduleRecommendation.destinationId,
                                        style = rowTextStyle(),
                                        maxLines = 1,
                                        overflow = TextOverflow.Ellipsis
                                    )
                                }
                            }
                        }
                    }
                }
            ) {
                Row(
                    horizontalArrangement = Arrangement.SpaceBetween,
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text(text = it.stationName, style = rowTextStyle())
                    Text(text = Utils.convertTimeFormat(it.timeAtStation), style = rowTextStyle())
                }
            }
            Box(modifier = Modifier.height(8.dp))
        }
    }
}