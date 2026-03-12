import SwiftUI

struct ContentView: View {
    @Environment(WakuStore.self) private var store
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        Group {
            if store.isAuthorized {
                TabView {
                    Tab("Home", systemImage: "house") {
                        HomeView()
                    }
                    Tab("Settings", systemImage: "gear") {
                        NavigationStack {
                            SettingsView()
                        }
                    }
                }
                .tint(WakuTheme.accent)
            } else {
                OnboardingView()
            }
        }
        .animation(WakuTheme.calmAnimation, value: store.isAuthorized)
        .onChange(of: scenePhase) {
            if scenePhase == .active {
                store.checkAuthorization()
            }
        }
    }
}
