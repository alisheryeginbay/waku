import Foundation
@preconcurrency import FamilyControls

struct TimerSession: Codable, Sendable {
    var activitySelection: FamilyActivitySelection
    var durationMinutes: Int
    var startedAt: Date

    var endDate: Date {
        startedAt.addingTimeInterval(TimeInterval(durationMinutes * 60))
    }

    var isExpired: Bool {
        Date() >= endDate
    }

    var remainingSeconds: TimeInterval {
        max(0, endDate.timeIntervalSince(Date()))
    }
}
