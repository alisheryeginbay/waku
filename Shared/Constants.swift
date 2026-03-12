import Foundation
@preconcurrency import DeviceActivity
@preconcurrency import ManagedSettings

enum WakuConstants {
    static let appGroupID = "group.com.alisher.waku"
    static let sessionKey = "waku_timer_session"
    static let authorizedKey = "waku_authorized"
}

extension DeviceActivityName {
    nonisolated(unsafe) static let timer = DeviceActivityName("waku.timer")
}

extension ManagedSettingsStore.Name {
    nonisolated(unsafe) static let timer = ManagedSettingsStore.Name("waku.store.timer")
}
