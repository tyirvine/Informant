//
//  SettingsController.swift
//  Informant
//
//  Created by Ty Irvine on 2022-03-04.
//

import AppKit
import Foundation

/// Responsible for reassigning the settings instance.
class SettingsController: Controller, ControllerProtocol, ObservableObject {

	@Published var settings: Settings

	required init(appDelegate: AppDelegate) {

		self.settings = Settings(appDelegate: appDelegate)

		super.init(appDelegate: appDelegate)
	}

	// MARK: - Settings Management Functions

	/// Creates a new instance of the settings class and throws out the old one.
	/// https://stackoverflow.com/a/55496821/13142325
	func resetDefaults() {

		let alert = AlertController.alertWarning(
			title: ContentManager.Labels.alertWarningTitle,
			message: ContentManager.Labels.alertResetSettingsMessage
		)

		switch alert {

			// Confirm
			case .alertFirstButtonReturn:

				// Erases settings
				UserDefaults.standard.setValuesForKeys(Settings.defaultSettings)
				settings = Settings(appDelegate: appDelegate)

				// Confirmation
				AlertController.alertOK(
					title: ContentManager.Labels.alertResetSettingsSuccessTitle,
					message: ContentManager.Labels.alertResetSettingsMessageFinished
				)
				break

			// Cancel
			case .alertSecondButtonReturn:
				break

			default:
				break
		}
	}

	// MARK: - Settings Utility Functions

	/// Opens up the system preferences to the panel we're looking for.
	/// https://stackoverflow.com/a/59120311/13142325
	static func openSystemPrefsAccessibility() {
		let pref = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
		NSWorkspace.shared.open(pref)
	}

	static func openSystemPrefsAutomation() {
		let pref = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Automation")!
		NSWorkspace.shared.open(pref)
	}

	static func openSystemPrefsFullDiskAccess() {
		let pref = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_AllFiles")!
		NSWorkspace.shared.open(pref)
	}
}
