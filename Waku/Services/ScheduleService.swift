import Foundation
import DeviceActivity

@MainActor
final class ScheduleService {
    private let center = DeviceActivityCenter()

    func startMonitoring(until endDate: Date) throws {
        let now = Date()
        let calendar = Calendar.current
        let start = calendar.dateComponents([.hour, .minute, .second], from: now)
        let end = calendar.dateComponents([.hour, .minute, .second], from: endDate)

        let schedule = DeviceActivitySchedule(
            intervalStart: start,
            intervalEnd: end,
            repeats: false
        )
        try center.startMonitoring(.timer, during: schedule)
    }

    func stopMonitoring() {
        center.stopMonitoring([.timer])
    }
}
