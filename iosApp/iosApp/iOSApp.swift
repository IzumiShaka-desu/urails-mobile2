import shared
import SwiftUI

@main
struct iOSApp: App {
    init() {
        DIKt.doInitKoin()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
//      TLocationSearchView()
        }
    }
}
