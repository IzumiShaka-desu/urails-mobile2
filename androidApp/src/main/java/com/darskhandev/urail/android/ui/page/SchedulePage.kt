package com.darskhandev.urail.android.ui.page

import android.app.TimePickerDialog
import androidx.activity.compose.BackHandler
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.ExperimentalFoundationApi
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
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.text.selection.LocalTextSelectionColors
import androidx.compose.foundation.text.selection.TextSelectionColors
import androidx.compose.material.Button
import androidx.compose.material.ButtonDefaults
import androidx.compose.material.CircularProgressIndicator
import androidx.compose.material.Divider
import androidx.compose.material.DropdownMenuItem
import androidx.compose.material.ExperimentalMaterialApi
import androidx.compose.material.ExposedDropdownMenuBox
import androidx.compose.material.ExposedDropdownMenuDefaults
import androidx.compose.material.Icon
import androidx.compose.material.ModalBottomSheetLayout
import androidx.compose.material.ModalBottomSheetValue
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.material.TextField
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.History
import androidx.compose.material.icons.filled.Train
import androidx.compose.material.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.collectAsState
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.Color.Companion.Transparent
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.constraintlayout.compose.ConstraintLayout
import androidx.constraintlayout.compose.Dimension
import com.darskhandev.urail.android.R
import com.darskhandev.urail.android.ui.component.ScheduleItem
import com.darskhandev.urail.android.ui.component.TimeLine
import com.darskhandev.urail.android.ui.theme.ColorTheme
import com.darskhandev.urail.android.utils.Utils
import com.darskhandev.urail.data.source.remote.models.schedule.DetailScheduleRaw
import com.darskhandev.urail.data.source.remote.models.station.StationType
import com.darskhandev.urail.domain.entities.Schedule
import com.darskhandev.urail.utils.AppState
import com.darskhandev.urail.viewmodel.HomeViewModel
import kotlinx.coroutines.launch
import me.sungbin.timelineview.TimeLineItem
import me.sungbin.timelineview.TimeLineOption
import me.sungbin.timelineview.TimeLinePadding
import org.koin.androidx.compose.getViewModel
import java.util.Calendar

@OptIn(ExperimentalMaterialApi::class)
@Composable
fun SchedulePage(
    homeViewModel: HomeViewModel = getViewModel(),
) {
    val context = LocalContext.current
    val calendar = Calendar.getInstance()
    val hour = calendar.get(Calendar.HOUR_OF_DAY)
    val minute = calendar.get(Calendar.MINUTE)

    val timeFrom = remember {
        mutableStateOf("Dari")
    }
    val timeTo = remember {
        mutableStateOf("Sampai")
    }

    val timePickerFrom = TimePickerDialog(
        context,
        { _, hourOfDay, minutes ->
            timeFrom.value = Utils.formatTime(hour = hourOfDay, minute = minutes)
        },
        hour,
        minute,
        true
    )
    val timePickerTo = TimePickerDialog(
        context,
        { _, hourOfDay, minutes ->
            timeTo.value = Utils.formatTime(hour = hourOfDay, minute = minutes)
        },
        hour,
        minute,
        true
    )

    var expanded by remember { mutableStateOf(false) }
    var selectedStation by remember { mutableStateOf("") }
    var filterStation by remember { mutableStateOf("") }


    val customTextSelectionColors = TextSelectionColors(
        handleColor = ColorTheme.darkBlueish,
        backgroundColor = ColorTheme.darkBlueish.copy(alpha = 0.4f)
    )

    Surface(
        color = ColorTheme.darkBlueish,
        modifier = Modifier.fillMaxSize()
    ) {
//        val stations = homeViewModel.getStationList.value.let{
//            when (it) {
//                is AppState.Success -> {
//                    it.data
//                }
//                is AppState.Error -> {
//                    listOf()
//                }
//                else -> {
//                    listOf()
//                }
//            }
//        }!!
        val stations = Utils.getStation(context)
        var filteredItems = remember { stations }
        Column {
            Row(
                modifier = Modifier
                    .padding(horizontal = 12.dp, vertical = 16.dp)
                    .padding(top = 12.dp),
                verticalAlignment = Alignment.CenterVertically,
            ) {
                Icon(
                    imageVector = Icons.Default.Train,
                    contentDescription = null,
                    tint = ColorTheme.lightBlueish,
                    modifier = Modifier
                        .size(42.dp)
                        .padding(start = 4.dp)
                )
                Surface(
                    color = ColorTheme.lightBlueWhitish,
                    modifier = Modifier
                        .padding(start = 8.dp)
                        .fillMaxWidth(0.9f)
                        .clip(RoundedCornerShape(20.dp))
                ) {
                    ExposedDropdownMenuBox(
                        expanded = expanded,
                        onExpandedChange = { expanded = !expanded }) {
                        CompositionLocalProvider(LocalTextSelectionColors provides customTextSelectionColors) {
                            TextField(
                                singleLine = true,
                                value = filterStation,
                                onValueChange = { value ->
                                    filterStation = value
                                    expanded = true
                                    filteredItems = stations.filter {
                                        it.stationName.contains(
                                            filterStation,
                                            ignoreCase = true
                                        )
                                    }
                                },
                                placeholder = {
                                    Text(
                                        text = "Cari Stasiun", style = TextStyle(
                                            color = ColorTheme.darkBlueish.copy(alpha = 0.6f),
                                            fontWeight = FontWeight.Bold,
                                            fontSize = 16.sp
                                        )
                                    )
                                },
                                maxLines = 1,
                                enabled = true,
                                keyboardOptions = KeyboardOptions(
                                    keyboardType = KeyboardType.Text
                                ),
                                textStyle = TextStyle(
                                    color = ColorTheme.darkBlueish,
                                    fontWeight = FontWeight.Bold,
                                    fontSize = 16.sp
                                ),
                                trailingIcon = {
                                    ExposedDropdownMenuDefaults.TrailingIcon(
                                        expanded = expanded
                                    )
                                },
                                colors = ExposedDropdownMenuDefaults.textFieldColors(
                                    cursorColor = ColorTheme.darkBlueish,
                                    focusedIndicatorColor = Transparent,
                                    unfocusedIndicatorColor = Transparent,
                                    focusedTrailingIconColor = ColorTheme.darkBlueish,
                                    trailingIconColor = ColorTheme.darkBlueish,
                                ),

                                )
                        }
                        ExposedDropdownMenu(
                            expanded = expanded,
                            onDismissRequest = { expanded = false },
                        ) {
                            filteredItems.forEach {
                                DropdownMenuItem(
                                    onClick = {
                                        selectedStation = it.stationName
                                        filterStation = it.stationName
                                        expanded = false
                                    }
                                ) {
                                    Text(text = it.stationName)
                                }
                            }
                        }
                    }
                }
            }
            Row(
                modifier = Modifier
                    .padding(12.dp)
                    .fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceEvenly
            ) {
                TimePickField(text = timeFrom.value, onClick = { timePickerFrom.show() })
                TimePickField(text = timeTo.value, onClick = { timePickerTo.show() })
                Button(
                    shape = RoundedCornerShape(20.dp),
                    onClick = {
                        val selectedObject = stations.find { it.stationName == selectedStation }
                        homeViewModel.getScheduleSearch(
                            stationId = selectedObject?.stationId.toString(),
                            timeFrom = timeFrom.value,
                            timeTo = timeTo.value
                        )
                    },
                    colors = ButtonDefaults.buttonColors(
                        backgroundColor = Color(0xFF009688),
                        contentColor = Color.White
                    )
                ) {
                    Text(text = "Cari", style = TextStyle(color = Color.White))
                }
            }
            Surface(
                modifier = Modifier
                    .fillMaxSize(),
                shape = RoundedCornerShape(topStart = 25.dp, topEnd = 25.dp),
                color = ColorTheme.lightBlueish,
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
                        homeViewModel.getDetailSchedule.collectAsState(initial = AppState.Loading()).value.let {
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
                                    ScheduleBottomSheetContent(schedule = it.data!!, currentStation = selectedStation)
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
                    },
                ) {
                    Column {
                        homeViewModel.getSchedule.collectAsState(initial = AppState.NoState()).value.let {
                            when (it) {
                                is AppState.Loading -> {
                                    Box(
                                        contentAlignment = Alignment.Center,
                                        modifier = Modifier.fillMaxSize()
                                    ) {
                                        CircularProgressIndicator(
                                            color = ColorTheme.darkBlueish
                                        )
                                    }
                                }

                                is AppState.Success -> {
                                    ScheduleItemPage(
                                        listScheduleModel = it.data!!,
                                        itemOnClick = { schedule ->
                                            homeViewModel.setKaIdforDetailSchedule(schedule.kaId)
                                            coroutineScope.launch {
                                                modalBottomSheetState.show()
                                            }
                                        })
                                }

                                is AppState.Error -> {
                                    Box(
                                        contentAlignment = Alignment.Center,
                                        modifier = Modifier.fillMaxSize()
                                    ) {
                                        Text(text = it.message.toString())
                                    }
                                }

                                is AppState.NoState -> {
                                    Box(
                                        contentAlignment = Alignment.Center,
                                        modifier = Modifier.fillMaxSize()
                                    ) {
                                        Text(text = "Silahkan Cari Jadwal")
                                    }
                                }

                                else -> {
                                    Text(text = "No Data")
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
fun ScheduleItemPage(
    listScheduleModel: List<Schedule>,
    itemOnClick: (Schedule) -> Unit
) {
    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .clip(RoundedCornerShape(topStart = 25.dp, topEnd = 25.dp))
            .padding(top = 16.dp, start = 16.dp, end = 16.dp, bottom = 52.dp)
    ) {
        val sortedList = listScheduleModel.sortedBy { it.departureTime }
        items(sortedList.size) {
            val scheduleModel = sortedList[it]
            ScheduleItem(scheduleItem = scheduleModel, onItemClick = { itemOnClick(scheduleModel) })
        }
    }
}
@Composable
fun ScheduleBottomSheetContent(
    schedule: DetailScheduleRaw,
    currentStation: String
) {
    Surface(
        color = ColorTheme.darkBlueish,
    ) {
        Column(
            modifier = Modifier.fillMaxSize()
        ) {
            val scheduleDetail = schedule.detailScheduleItem
            data class LineItem(
                override val key: String,
                val stationName: String,
                val stationType: StationType,
                val timeAtStation: String,
            ) : TimeLineItem<String>

            val scheduleDetailList = mutableListOf<LineItem>()
            for (i in scheduleDetail) {
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
                    .padding(horizontal = 24.dp, vertical = 12.dp).padding(start = 0.dp),
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
                                Text(text = schedule.kaID, style = rowTextStyle(), maxLines = 1, overflow = TextOverflow.Ellipsis)
                                Text(text = schedule.kaName, style = rowTextStyle(), maxLines = 1, overflow = TextOverflow.Ellipsis)
                            }
                            Row {
                                Column {
                                    Text(text = Utils.convertTimeFormat(schedule.departureTime), style = rowTextStyle())
                                    Text(text = Utils.convertTimeFormat(schedule.arrivalTime), style = rowTextStyle())
                                }
                                Column(
                                    horizontalAlignment = Alignment.End,
                                    modifier = Modifier.padding(start = 8.dp)
                                ) {
                                    Text(text = Utils.getStationNameById(schedule.originID, context = LocalContext.current) ?: schedule.originID, style = rowTextStyle(), maxLines = 1, overflow = TextOverflow.Ellipsis)
                                    Text(text = Utils.getStationNameById(schedule.destinationID, context = LocalContext.current) ?: schedule.destinationID, style = rowTextStyle(), maxLines = 1, overflow = TextOverflow.Ellipsis)
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
                    if (it.stationName == currentStation) {
                        Row {
                            Text(text = it.stationName, fontWeight = FontWeight.Bold, style = rowTextStyle().copy(fontSize = 16.sp), maxLines = 1, overflow = TextOverflow.Ellipsis)
                            Text(text = " (Saat ini)", color = ColorTheme.darkBlueish, style = rowTextStyle().copy(fontSize = 16.sp))
                        }
                    } else {
                        Text(text = it.stationName, style = rowTextStyle())
                    }
                    Text(text = Utils.convertTimeFormat(it.timeAtStation), style = rowTextStyle())
                }
            }
            Box(modifier = Modifier.height(8.dp))
        }
    }
}

fun rowTextStyle() = TextStyle(
    color = Color.White,
    fontSize = 14.sp,
    fontWeight = FontWeight.Bold
)

@Composable
fun TimePickField(text: String, onClick: () -> Unit) {
    Surface(
        color = Transparent,
        shape = RoundedCornerShape(20.dp),
        modifier = Modifier
            .clip(RoundedCornerShape(20.dp))
            .clickable { onClick() },
        border = BorderStroke(width = 0.5.dp, color = ColorTheme.lightBlueWhitish)
    ) {
        Row(
            verticalAlignment = Alignment.CenterVertically,
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
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
                text = text,
                style = TextStyle(
                    color = ColorTheme.lightBlueWhitish,
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold
                )
            )
        }
    }
}
