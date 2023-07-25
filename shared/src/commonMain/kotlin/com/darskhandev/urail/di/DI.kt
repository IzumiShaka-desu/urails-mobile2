package com.darskhandev.urail.di

import com.darskhandev.urail.data.Repository
import com.darskhandev.urail.data.source.remote.ApiServices
import com.darskhandev.urail.data.source.remote.RemoteDataSource
import com.darskhandev.urail.domain.repositories.IRepository
import com.darskhandev.urail.domain.usecases.Interactor
import com.darskhandev.urail.domain.usecases.UseCases
import com.darskhandev.urail.getModule
import com.darskhandev.urail.getPlatform
import io.ktor.client.HttpClient
import io.ktor.client.plugins.contentnegotiation.ContentNegotiation
import io.ktor.client.plugins.logging.DEFAULT
import io.ktor.client.plugins.logging.LogLevel
import io.ktor.client.plugins.logging.Logger
import io.ktor.client.plugins.logging.Logging
import io.ktor.serialization.kotlinx.json.json
import kotlinx.serialization.json.Json
import org.koin.core.context.startKoin
import org.koin.dsl.KoinAppDeclaration
import org.koin.dsl.module
//const val baseUrl = "https://urailsapi-production.up.railway.app"

const val baseUrl = "https://urails-api-v2-production.up.railway.app"
fun initKoin(appDeclaration: KoinAppDeclaration = {}) =
    startKoin {
        appDeclaration()
        modules(
            networkModule,
            repositoryModule,
            useCaseModule,
            getModule(),
            getPlatform()
        )
    }
fun initKoin() = com.darskhandev.urail.di.initKoin {}

val networkModule = module {
    single<ApiServices> { RemoteDataSource(get(), baseUrl) }
    single {
        HttpClient {
            install(ContentNegotiation) {
                json(Json {
                    ignoreUnknownKeys = true
                    prettyPrint = true
                })
            }

//            install(Logging) {
//                logger = Logger.DEFAULT
//                level = LogLevel.ALL
//            }
        }
    }
}

val repositoryModule = module {
    single<IRepository> { Repository(get()) }
}

val useCaseModule = module {
    factory <UseCases> { Interactor(get()) }
}
//
//val viewModelModule = module {
//    single<HomeViewModel> { HomeViewModel(get()) }
//}
