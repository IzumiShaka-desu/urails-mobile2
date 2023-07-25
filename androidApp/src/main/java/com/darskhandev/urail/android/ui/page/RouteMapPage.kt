package com.darskhandev.urail.android.ui.page

import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.Image
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.draggable
import androidx.compose.foundation.gestures.transformable
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.Icon
import androidx.compose.material.Surface
import androidx.compose.material.Text
import androidx.compose.material.TextField
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.LocationOn
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.RectangleShape
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.darskhandev.urail.android.R
import com.darskhandev.urail.android.ui.component.ZoomableImage
import com.darskhandev.urail.android.ui.theme.ColorTheme

@OptIn(ExperimentalFoundationApi::class)
@Composable
fun RouteMapPage() {
    Surface(
        color = ColorTheme.darkBlueish,
        modifier = Modifier.fillMaxSize()
    ) {
        Column {
            Text(
                modifier = Modifier.padding(top = 16.dp, start = 16.dp),
                text = "Peta Rute KRL Jabodetabek", style = TextStyle(
                    color = Color.White,
                    fontSize = 32.sp,
                    fontWeight = FontWeight.Bold,
                )
            )

            Surface(
                modifier = Modifier
                    .padding(top = 48.dp)
                    .fillMaxSize(),
                shape = RoundedCornerShape(topStart = 25.dp, topEnd = 25.dp),
                color = ColorTheme.lightBlueish,
            ) {
                ZoomableImage(
                    painter = painterResource(id = R.drawable.img_map_jabodetabek),
                    modifier = Modifier.padding(bottom = 48.dp, top = 0.dp, start = 16.dp, end = 16.dp).fillMaxSize(),

                )
            }
        }
    }
}