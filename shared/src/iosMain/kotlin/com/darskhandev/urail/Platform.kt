package com.darskhandev.urail


import com.darskhandev.urail.viewmodel.HomeViewModel
import org.koin.core.component.KoinComponent
import org.koin.core.component.get
import org.koin.core.module.Module
import org.koin.dsl.module
import com.darskhandev.urail.domain.usecases.UseCases
import org.koin.core.component.inject
import platform.UIKit.UIDevice

class IOSPlatform: Platform {
    override val name: String = UIDevice.currentDevice.systemName() + " " + UIDevice.currentDevice.systemVersion
}

actual fun getPlatform(): Module {
    return module {
//        single { IOSPlatform() }
 single{
        HomeViewModel(get())
    }
    }
}
//= IOSPlatform()
actual fun getModule() = module {
    single{
        HomeViewModel(get())
    }
}
object GetComponents: KoinComponent {
    fun getHomeViewModel() = get<HomeViewModel>()
   val useCases : UseCases by inject()
    
}
