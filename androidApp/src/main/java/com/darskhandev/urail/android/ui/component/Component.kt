package com.darskhandev.urail.android.ui.component

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.Image
import androidx.compose.foundation.MutatePriority
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.combinedClickable
import androidx.compose.foundation.gestures.ScrollableState
import androidx.compose.foundation.gestures.awaitFirstDown
import androidx.compose.foundation.gestures.calculatePan
import androidx.compose.foundation.gestures.calculateRotation
import androidx.compose.foundation.gestures.calculateZoom
import androidx.compose.foundation.gestures.forEachGesture
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Icon
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.AccessTime
import androidx.compose.material.icons.filled.ArrowRightAlt
import androidx.compose.material.icons.filled.History
import androidx.compose.material.icons.filled.Train
import androidx.compose.runtime.Composable
import androidx.compose.runtime.currentCompositionLocalContext
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.graphics.Shape
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.painter.Painter
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.darskhandev.urail.android.ui.theme.ColorTheme
import com.darskhandev.urail.android.utils.Utils
import com.darskhandev.urail.domain.entities.Schedule
import kotlinx.coroutines.awaitCancellation
import kotlinx.coroutines.launch

@Composable
fun SearchPlaceRow(
    icon: @Composable () -> Unit,
    onClick: () -> Unit,
    textValue: String,
) {
    Row(
        modifier = Modifier.padding(start = 12.dp, bottom = 16.dp, top = 16.dp, end = 12.dp),
        verticalAlignment = Alignment.CenterVertically,
    ) {
        icon()
        Surface(
            color = ColorTheme.lightBlueWhitish,
            modifier = Modifier
                .padding(start = 8.dp, end = 8.dp)
                .fillMaxWidth(1f)
                .clip(RoundedCornerShape(20.dp))
                .clickable {
                    onClick()
                }
        ) {
            Text(
                maxLines = 1,
                softWrap = true,
                modifier = Modifier.padding(end = 16.dp, top = 12.dp, bottom = 12.dp, start = 16.dp ),
                text = textValue,
                overflow = TextOverflow.Ellipsis,
                style = TextStyle(
                    color = ColorTheme.mediumDarkBlueish,
                    fontSize = 16.sp,
                    fontWeight = FontWeight.SemiBold
                )
            )
        }
    }
}

@ExperimentalFoundationApi
@Composable
fun ZoomableImage(
    painter: Painter,
    modifier: Modifier = Modifier,
    backgroundColor: Color = Color.Transparent,
    imageAlign: Alignment = Alignment.Center,
    shape: Shape = RectangleShape,
    maxScale: Float = 1f,
    minScale: Float = 3f,
    contentScale: ContentScale = ContentScale.Fit,
    isRotation: Boolean = false,
    isZoomable: Boolean = true,
    scrollState: ScrollableState? = null
) {
    val coroutineScope = rememberCoroutineScope()

    val scale = remember { mutableStateOf(1f) }
    val rotationState = remember { mutableStateOf(1f) }
    val offsetX = remember { mutableStateOf(1f) }
    val offsetY = remember { mutableStateOf(1f) }

    Box(
        modifier = Modifier
            .clip(shape)
            .background(backgroundColor)
            .combinedClickable(
                interactionSource = remember { MutableInteractionSource() },
                indication = null,
                onClick = { /* NADA :) */ },
                onDoubleClick = {
                    if (scale.value >= 2f) {
                        scale.value = 1f
                        offsetX.value = 1f
                        offsetY.value = 1f
                    } else scale.value = 3f
                },
            )
            .pointerInput(Unit) {
                if (isZoomable) {
                    forEachGesture {
                        awaitPointerEventScope {
                            awaitFirstDown()
                            do {
                                val event = awaitPointerEvent()
                                scale.value *= event.calculateZoom()
                                if (scale.value > 1) {
                                    scrollState?.run {
                                        coroutineScope.launch {
                                            setScrolling(false)
                                        }
                                    }
                                    val offset = event.calculatePan()
                                    offsetX.value += offset.x
                                    offsetY.value += offset.y
                                    rotationState.value += event.calculateRotation()
                                    scrollState?.run {
                                        coroutineScope.launch {
                                            setScrolling(true)
                                        }
                                    }
                                } else {
                                    scale.value = 1f
                                    offsetX.value = 1f
                                    offsetY.value = 1f
                                }
                            } while (event.changes.any { it.pressed })
                        }
                    }
                }
            }

    ) {
        Image(
            painter = painter,
            contentDescription = null,
            contentScale = contentScale,
            modifier = modifier
                .align(imageAlign)
                .graphicsLayer {
                    if (isZoomable) {
                        scaleX = maxOf(maxScale, minOf(minScale, scale.value))
                        scaleY = maxOf(maxScale, minOf(minScale, scale.value))
                        if (isRotation) {
                            rotationZ = rotationState.value
                        }
                        translationX = offsetX.value
                        translationY = offsetY.value
                    }
                }
        )
    }
}

suspend fun ScrollableState.setScrolling(value: Boolean) {
    scroll(scrollPriority = MutatePriority.PreventUserInput) {
        when (value) {
            true -> Unit
            else -> awaitCancellation()
        }
    }
}

@Composable
fun RouteMainItem(
    stationFrom: String,
    stationTo: String,
    elapsedTime: String,
    onItemClick: () -> Unit
) {
    Surface(
        color = ColorTheme.darkBlueish,
        modifier = Modifier
            .padding(bottom = 8.dp)
            .clip(RoundedCornerShape(20.dp))
            .clickable { onItemClick() }
    ) {
        Row(
            modifier = Modifier
                .padding(horizontal = 12.dp, vertical = 16.dp)
                .fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Icon(
                imageVector = Icons.Default.Train,
                contentDescription = null,
                tint = ColorTheme.lightBlueWhitish,
                modifier = Modifier
                    .padding(end = 8.dp)
                    .size(48.dp)
            )
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                Text(
                    maxLines = 1,
                    softWrap = true,
                    text = stationFrom,
                    overflow = TextOverflow.Ellipsis,
                    style = TextStyle(
                        color = Color.White,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                )
                Icon(
                    imageVector = Icons.Default.ArrowRightAlt,
                    contentDescription = null,
                    tint = ColorTheme.lightBlueWhitish,
                    modifier = Modifier
                        //.padding(end = 8.dp)
                        .size(32.dp)
                )
                Text(
                    maxLines = 1,
                    softWrap = true,
                    text = stationTo,
                    overflow = TextOverflow.Ellipsis,
                    style = TextStyle(
                        color = Color.White,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                )
            }
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                Icon(
                    imageVector = Icons.Default.History,
                    contentDescription = null,
                    tint = ColorTheme.lightBlueWhitish,
                    modifier = Modifier
                        //.padding(end = 8.dp)
                        .size(32.dp)
                )
                Text(
                    maxLines = 1,
                    softWrap = true,
                    modifier = Modifier.padding(top = 4.dp),
                    text = elapsedTime,
                    overflow = TextOverflow.Ellipsis,
                    style = TextStyle(
                        color = Color.White,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                )
            }
        }
    }
}

@Composable
fun ScheduleItem(
    scheduleItem: Schedule,
    onItemClick: () -> Unit
) {
    Surface(
        color = ColorTheme.darkBlueish,
        modifier = Modifier
            .padding(bottom = 8.dp)
            .clip(RoundedCornerShape(20.dp))
            .clickable { onItemClick() }
    ) {
        Row(
            modifier = Modifier
                .padding(horizontal = 12.dp, vertical = 16.dp)
                .fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                Icon(
                    imageVector = Icons.Default.Train,
                    contentDescription = null,
                    tint = ColorTheme.lightBlueWhitish,
                    modifier = Modifier
                        .padding(end = 8.dp)
                        .size(48.dp)
                )
                Text(
                    maxLines = 1,
                    softWrap = true,
                    text = scheduleItem.kaId,
                    overflow = TextOverflow.Ellipsis,
                    style = TextStyle(
                        color = ColorTheme.lightBlueWhitish,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                )
            }
            Column(
                modifier = Modifier.weight(1f),
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                Text(
                    maxLines = 1,
                    softWrap = true,
                    text = Utils.getStationNameById(stationId = scheduleItem.destinationId, context = LocalContext.current).toString(),
                    overflow = TextOverflow.Ellipsis,
                    style = TextStyle(
                        color = Color.White,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                )
                Text(
                    modifier = Modifier.padding(top = 8.dp),
                    maxLines = 3,
                    minLines = 2,
                    softWrap = true,
                    text = scheduleItem.kaName,
                    overflow = TextOverflow.Ellipsis,
                    style = TextStyle(
                        color = ColorTheme.lightBlueWhitish,
                        fontSize = 12.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                )
            }
            Column(
                horizontalAlignment = Alignment.CenterHorizontally,
            ) {
                Icon(
                    imageVector = Icons.Default.AccessTime,
                    contentDescription = null,
                    tint = ColorTheme.lightBlueWhitish,
                    modifier = Modifier
                        .size(32.dp)
                )
                Text(
                    maxLines = 1,
                    softWrap = true,
                    modifier = Modifier.padding(top = 4.dp),
                    text = scheduleItem.departureTime,
                    overflow = TextOverflow.Ellipsis,
                    style = TextStyle(
                        color = Color.White,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.SemiBold
                    )
                )
            }
        }
    }
}

@Preview(backgroundColor = 0xFFFFF, showBackground = true)
@Composable
fun PreviewItem() {
    RouteMainItem(
        stationFrom = "Station 1",
        stationTo = "Station 2",
        elapsedTime = "1h 30m",
        onItemClick = {}
    )
}


