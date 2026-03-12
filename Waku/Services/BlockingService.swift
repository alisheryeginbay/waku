import Foundation
import ManagedSettings
import FamilyControls

@MainActor
final class BlockingService {
    func applyShields(for session: TimerSession) {
        let store = ManagedSettingsStore(named: .timer)
        let selection = session.activitySelection

        if !selection.applicationTokens.isEmpty {
            store.shield.applications = selection.applicationTokens
        }

        if !selection.categoryTokens.isEmpty {
            store.shield.applicationCategories = .specific(selection.categoryTokens)
        }

        if !selection.webDomainTokens.isEmpty {
            store.shield.webDomains = selection.webDomainTokens
        }
    }

    func removeShields() {
        let store = ManagedSettingsStore(named: .timer)
        store.clearAllSettings()
    }
}
