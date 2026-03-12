import SwiftUI

struct SettingsView: View {
    @Environment(WakuStore.self) private var store
    @State private var showingStopConfirm = false

    var body: some View {
        Form {
            if store.isBlocking {
                Section {
                    Button(role: .destructive) {
                        showingStopConfirm = true
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Stop Blocking")
                                .font(.system(size: 16, weight: .medium))
                            Text("Removes all shields and stops the timer")
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section {
                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Screen Time Settings")
                                .font(.system(size: 16, weight: .medium))
                            Text("Manage permissions in iOS Settings")
                                .font(.system(size: 13))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .foregroundStyle(.tertiary)
                    }
                }
                .tint(.primary)
            }

            Section {
                VStack(spacing: 8) {
                    Text("Waku")
                        .font(.system(size: 18, weight: .light))
                    Text("Version 1.0.0")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)
                    Text("Minimalistic app blocking")
                        .font(.system(size: 13))
                        .foregroundStyle(.tertiary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Stop Blocking?", isPresented: $showingStopConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Stop", role: .destructive) {
                store.stopSession()
            }
        } message: {
            Text("This will remove all shields and stop the timer.")
        }
    }
}
