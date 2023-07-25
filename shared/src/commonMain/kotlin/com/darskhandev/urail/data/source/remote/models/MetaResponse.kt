package com.darskhandev.urail.data.source.remote.models

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

//this class is used to contain data with status code and message data is type of T
@Serializable
data class MetaResponse<T>(
    @SerialName("status_code") val statusCode: Int,
    val message: String,
    val data: T? = null
)