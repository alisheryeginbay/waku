import DeviceActivity
import ManagedSettings
import Foundation

final class WakuMonitorExtension: DeviceActivityMonitor {
    private let persistence = WakuPersistence.shared

    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
        applyShields()
    }

    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
        removeShields()
        persistence.saveSession(nil)
    }

    private func applyShields() {
        guard let session = persistence.loadSession(), !session.isExpired else {
            removeShields()
            return
        }

        let store = ManagedSettingsStore(named: .timer)

        store.shield.applications = session.activitySelection.applicationTokens.isEmpty
            ? nil
            : session.activitySelection.applicationTokens

        store.shield.applicationCategories = session.activitySelection.categoryTokens.isEmpty
            ? nil
            : .specific(session.activitySelection.categoryTokens)
    }

    private func removeShields() {
        let store = ManagedSettingsStore(named: .timer)
        store.clearAllSettings()
    }
}
