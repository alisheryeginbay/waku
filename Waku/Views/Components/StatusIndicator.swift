import SwiftUI

struct StatusIndicator: View {
    let isActive: Bool

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(isActive ? WakuTheme.accent : .secondary)
                .frame(width: 10, height: 10)

            Text(isActive ? "Blocking active" : "Not blocking")
                .font(.system(size: 15, weight: .regular))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .glassEffect(.regular.tint(isActive ? WakuTheme.accent.opacity(0.2) : nil), in: .capsule)
        .animation(WakuTheme.calmAnimation, value: isActive)
    }
}
