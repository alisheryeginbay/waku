import SwiftUI
import FamilyControls

struct HomeView: View {
    @Environment(WakuStore.self) private var store
    @State private var selectedMinutes = 30
    @State private var activitySelection = FamilyActivitySelection()
    @State private var showingActivityPicker = false

    private let minuteOptions = Array(stride(from: 5, through: 480, by: 5))

    var body: some View {
        NavigationStack {
            List {
                if store.isBlocking {
                    activeSessionView
                } else {
                    setupView
                }
            }
            .navigationTitle("waku")
            .familyActivityPicker(
                isPresented: $showingActivityPicker,
                selection: $activitySelection
            )
        }
    }

    // MARK: - Active Session

    private var activeSessionView: some View {
        Group {
            Section {
                StatusIndicator(isActive: true)
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
            }

            Section {
                VStack(spacing: 8) {
                    Text(timeString(from: store.remainingSeconds))
                        .font(.system(size: 48, weight: .light, design: .monospaced))
                        .contentTransition(.numericText())
                    Text("remaining")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .listRowBackground(Color.clear)
            }

            Section {
                Button(role: .destructive) {
                    store.stopSession()
                } label: {
                    Text("Stop Blocking")
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    // MARK: - Setup

    private var setupView: some View {
        Group {
            Section {
                StatusIndicator(isActive: false)
                    .frame(maxWidth: .infinity)
                    .listRowBackground(Color.clear)
            }

            Section {
                Button {
                    showingActivityPicker = true
                } label: {
                    HStack {
                        Text(selectionTitle)
                            .foregroundStyle(selectionCount == 0 ? .secondary : .primary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.tertiary)
                    }
                }
            } header: {
                Text("Apps to block")
            }

            Section {
                Picker("Duration", selection: $selectedMinutes) {
                    ForEach(minuteOptions, id: \.self) { minutes in
                        Text(durationLabel(minutes)).tag(minutes)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 120)
                .listRowBackground(Color.clear)
            } header: {
                Text("Duration")
            }

            Section {
                Button {
                    store.startSession(selection: activitySelection, minutes: selectedMinutes)
                } label: {
                    Text("Start Blocking")
                        .font(.system(size: 16, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.glassProminent)
                .disabled(selectionCount == 0)
                .listRowBackground(Color.clear)
            }
        }
    }

    // MARK: - Helpers

    private var selectionCount: Int {
        activitySelection.applicationTokens.count + activitySelection.categoryTokens.count
    }

    private var selectionTitle: String {
        selectionCount == 0 ? "Select apps & categories" : "\(selectionCount) selected"
    }

    private func durationLabel(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes) min"
        } else {
            let h = minutes / 60
            let m = minutes % 60
            return m == 0 ? "\(h) hr" : "\(h) hr \(m) min"
        }
    }

    private func timeString(from seconds: TimeInterval) -> String {
        let total = Int(seconds)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        if h > 0 {
            return String(format: "%d:%02d:%02d", h, m, s)
        }
        return String(format: "%02d:%02d", m, s)
    }
}
