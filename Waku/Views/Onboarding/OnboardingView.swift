import SwiftUI

struct OnboardingView: View {
    @Environment(WakuStore.self) private var store

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 16) {
                Text("waku")
                    .font(.system(size: 56, weight: .thin))

                Text("Minimalistic app blocking")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(spacing: 16) {
                if let error = store.authorizationError {
                    Text(error)
                        .font(.system(size: 13))
                        .foregroundStyle(WakuTheme.destructive)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }

                Button {
                    Task {
                        await store.requestAuthorization()
                    }
                } label: {
                    Group {
                        if store.isRequestingAuthorization {
                            ProgressView()
                        } else {
                            Text("Enable Waku")
                        }
                    }
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                }
                .buttonStyle(.glassProminent)
                .disabled(store.isRequestingAuthorization)
                .padding(.horizontal, 32)

                Text("Waku uses Screen Time to block apps.\nYou can revoke access anytime in Settings.")
                    .font(.system(size: 12))
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 48)
            }
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
