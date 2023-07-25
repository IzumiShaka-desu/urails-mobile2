package com.darskhandev.urail

import org.koin.core.module.Module

interface Platform {
    val name: String
}

expect fun getPlatform(): Module

expect fun getModule(): Module