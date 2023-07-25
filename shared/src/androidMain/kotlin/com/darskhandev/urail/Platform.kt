package com.darskhandev.urail

import com.darskhandev.urail.viewmodel.HomeViewModel
import org.koin.androidx.viewmodel.dsl.viewModel
import org.koin.core.module.Module
import org.koin.dsl.module

class AndroidPlatform : Platform {
    override val name: String = "Android ${android.os.Build.VERSION.SDK_INT}"
}

actual fun getPlatform(): Module = module {

}
//: Platform = AndroidPlatform()
actual fun getModule() = module {
    viewModel { HomeViewModel(get())}
}