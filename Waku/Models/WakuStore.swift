import Foundation
import FamilyControls
import Observation

@Observable
@MainActor
final class WakuStore {
    var activeSession: TimerSession?
    var isAuthorized: Bool
    var authorizationError: String?

    private let persistence = WakuPersistence.shared
    private let blockingService = BlockingService()
    private let scheduleService = ScheduleService()
    private let defaults = UserDefaults(suiteName: WakuConstants.appGroupID) ?? .standard
    private var timer: Timer?

    var isBlocking: Bool {
        activeSession != nil
    }

    var remainingSeconds: TimeInterval = 0

    init() {
        let cached = defaults.bool(forKey: WakuConstants.authorizedKey)
        let current = AuthorizationCenter.shared.authorizationStatus == .approved
        isAuthorized = cached || current
        if current != cached {
            defaults.set(current, forKey: WakuConstants.authorizedKey)
        }

        if let session = persistence.loadSession() {
            if session.isExpired {
                persistence.saveSession(nil)
            } else {
                activeSession = session
                remainingSeconds = session.remainingSeconds
                startCountdown()
            }
        }
    }

    func checkAuthorization() {
        let approved = AuthorizationCenter.shared.authorizationStatus == .approved
        isAuthorized = approved
        defaults.set(approved, forKey: WakuConstants.authorizedKey)
    }

    // MARK: - Authorization

    func requestAuthorization() async {
        do {
            try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            isAuthorized = true
            defaults.set(true, forKey: WakuConstants.authorizedKey)
            authorizationError = nil
        } catch {
            isAuthorized = false
            defaults.set(false, forKey: WakuConstants.authorizedKey)
            authorizationError = error.localizedDescription
        }
    }

    // MARK: - Timer

    func startSession(selection: FamilyActivitySelection, minutes: Int) {
        let session = TimerSession(
            activitySelection: selection,
            durationMinutes: minutes,
            startedAt: Date()
        )
        activeSession = session
        persistence.saveSession(session)

        blockingService.applyShields(for: session)
        do {
            try scheduleService.startMonitoring(until: session.endDate)
        } catch {
            print("Failed to start monitoring: \(error)")
        }

        remainingSeconds = session.remainingSeconds
        startCountdown()
    }

    func stopSession() {
        blockingService.removeShields()
        scheduleService.stopMonitoring()
        activeSession = nil
        remainingSeconds = 0
        persistence.saveSession(nil)
        stopCountdown()
    }

    // MARK: - Countdown

    private func startCountdown() {
        stopCountdown()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                if self.activeSession?.isExpired == true {
                    self.stopSession()
                } else {
                    self.remainingSeconds = self.activeSession?.remainingSeconds ?? 0
                }
            }
        }
    }

    private func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }
}
