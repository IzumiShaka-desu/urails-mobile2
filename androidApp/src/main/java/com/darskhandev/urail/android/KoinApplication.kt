package com.darskhandev.urail.android

import android.app.Application
import com.darskhandev.urail.android.ui.viewmodel.MapsViewModel
import com.darskhandev.urail.di.initKoin
import com.darskhandev.urail.di.networkModule
import com.darskhandev.urail.di.repositoryModule
import com.darskhandev.urail.di.useCaseModule
import com.darskhandev.urail.getModule
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidLogger
import org.koin.androidx.viewmodel.dsl.viewModel
import org.koin.core.context.startKoin
import org.koin.dsl.module


class KoinApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        startKoin {
//            appDeclaration()
            androidContext(this@KoinApplication)
            androidLogger()
            modules(
                networkModule,
                repositoryModule,
                useCaseModule,
                //getPlatform(),
                getModule(),
                viewModelModule
            )
        }

//        initKoin {
//
//            modules(
//                viewModelModule
//            )
//        }
    }
}

val viewModelModule = module {
    viewModel { MapsViewModel(get()) }
}