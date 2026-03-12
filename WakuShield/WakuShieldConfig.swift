import ManagedSettings
import ManagedSettingsUI
import UIKit

final class WakuShieldConfig: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        makeWakuShield()
    }

    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        makeWakuShield()
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        makeWakuShield()
    }

    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        makeWakuShield()
    }

    private func makeWakuShield() -> ShieldConfiguration {
        let backgroundColor = UIColor(red: 0.102, green: 0.102, blue: 0.102, alpha: 1.0)
        let foregroundColor = UIColor(red: 0.91, green: 0.894, blue: 0.875, alpha: 1.0)
        let accentColor = UIColor(red: 0.545, green: 0.659, blue: 0.533, alpha: 1.0)

        return ShieldConfiguration(
            backgroundBlurStyle: .systemUltraThinMaterialDark,
            backgroundColor: backgroundColor,
            icon: nil,
            title: ShieldConfiguration.Label(
                text: "Stay focused",
                color: foregroundColor
            ),
            subtitle: ShieldConfiguration.Label(
                text: "This app is blocked by Waku",
                color: accentColor
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "Close",
                color: foregroundColor
            ),
            primaryButtonBackgroundColor: accentColor,
            secondaryButtonLabel: nil
        )
    }
}
