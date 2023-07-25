package com.darskhandev.urail.utils

sealed class AppState<R> (
    open val data: R? = null,
    open val message: String? = null
){
    data class Success<R>(override val data: R): AppState<R>(data)
    data class Error<R>(val error: String, override val data: R? = null): AppState<R>(message = error, data =  data)
    data class Loading<R>(override val message:String ="loading..."): AppState<R>()
   data class NoState<R>(override val message:String ="no state"): AppState<R>()
}

//data class AppState(val state: String, val data: Data? = null, val message: String? = null)
