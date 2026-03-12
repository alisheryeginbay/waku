# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Project Overview

Waku is a minimalistic iOS app blocker built with SwiftUI and Apple's Screen Time APIs (FamilyControls, ManagedSettings, DeviceActivity). Users select apps/categories, set a timer duration, and Waku shields those apps until the timer expires. The shield action always closes — it never allows unblocking.

## Build & Run

This project uses **XcodeGen** to generate the Xcode project from `project.yml`:

```bash
xcodegen generate        # Regenerate Waku.xcodeproj from project.yml
xed .                    # Open in Xcode
```

Build and run via Xcode (no CLI build — Family Controls entitlements require provisioning profiles and a physical device). There are no tests, no linter, and no package manager dependencies.

**Requirements**: Xcode 16+, iOS 26.0+, Swift 6.0, physical device (Screen Time APIs don't work in Simulator).

## Architecture

### Targets (4)

| Target | Type | Role |
|---|---|---|
| **Waku** | iOS app | Main app — UI, state management, session lifecycle |
| **WakuMonitor** | App extension | `DeviceActivityMonitor` — re-applies shields on interval start, clears on end |
| **WakuShield** | App extension | `ShieldConfigurationDataSource` — customizes the blocking overlay UI |
| **WakuShieldAction** | App extension | `ShieldActionDelegate` — always returns `.close`, never `.defer` |

All four targets link the `Shared/` directory for access to `TimerSession`, `WakuPersistence`, and `WakuConstants`.

### Shared State Across Processes

The main app and extensions run in separate processes. They communicate through **UserDefaults with app group** (`group.com.alisher.waku`). `WakuPersistence` encodes/decodes `TimerSession` as JSON in this shared store. This is the only cross-process data channel.

### Key Data Flow

1. User picks apps via `FamilyActivitySelection` and a duration
2. `WakuStore.startSession()` creates a `TimerSession`, persists it, applies shields via `BlockingService`, and starts device activity monitoring via `ScheduleService`
3. `WakuMonitor` extension independently reads the persisted session to apply/remove shields at schedule boundaries
4. `WakuShield` renders a custom "Stay focused" overlay on blocked apps
5. `WakuShieldAction` forces close on any shield interaction (no bypass)
6. On expiry (or manual stop), shields are cleared and the session is removed

### State Management

`WakuStore` is an `@Observable @MainActor` class injected into the SwiftUI environment at the root. It owns the session lifecycle, countdown timer, and authorization state. No third-party state management.

## Conventions

- **Swift 6 strict concurrency** is enabled across all targets — all types must be `Sendable`, UI code is `@MainActor`
- `@preconcurrency import` is used for Apple frameworks that haven't fully adopted Sendable yet (FamilyControls, DeviceActivity, ManagedSettings)
- `nonisolated(unsafe) static` is used for extension constants on Apple types (`DeviceActivityName`, `ManagedSettingsStore.Name`)
- Project config lives in `project.yml`, not the `.xcodeproj` — always edit `project.yml` then regenerate
- Entitlements are in `SupportFiles/` (one per target)
