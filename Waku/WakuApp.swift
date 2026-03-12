import SwiftUI

@main
struct WakuApp: App {
    @State private var store = WakuStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}
