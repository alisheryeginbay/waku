import Foundation

final class WakuPersistence: @unchecked Sendable {
    static let shared = WakuPersistence()

    private let defaults: UserDefaults

    init() {
        self.defaults = UserDefaults(suiteName: WakuConstants.appGroupID) ?? .standard
    }

    func saveSession(_ session: TimerSession?) {
        guard let session, let data = try? JSONEncoder().encode(session) else {
            defaults.removeObject(forKey: WakuConstants.sessionKey)
            return
        }
        defaults.set(data, forKey: WakuConstants.sessionKey)
    }

    func loadSession() -> TimerSession? {
        guard let data = defaults.data(forKey: WakuConstants.sessionKey),
              let session = try? JSONDecoder().decode(TimerSession.self, from: data)
        else { return nil }
        return session
    }
}
