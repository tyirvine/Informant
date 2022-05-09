//
//  DisplayController.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-21.
//

import Foundation
import SwiftUI

/// Controls all interfaces in the app and is responsible for issuing app wide updates.
/// Used to check all system settings as well.
class InterfaceController: Controller, ControllerProtocol {

	required init(appDelegate: AppDelegate) {
		super.init(appDelegate: appDelegate)
	}

	// MARK: - Update Functions

	/// Updates all interfaces.
	func updateAllInterfaces(reset: Bool = false) {
		if reset { resetAppState() }
		updateDisplays()
		appDelegate.menuController.updateMenu()
	}

	/// Updates active displays while checking for settings that need updates.
	func updateDisplays() {

		// Is app paused?
		if appDelegate.settings.settingPauseApp == true {
			return hideDisplays()
		}

		// Is the display still shown when not using Finder?
		else if appDelegate.settings.settingHideWhenViewingOtherApps == true {

			// If active app is not finder then abort execution
			if utilityIsActiveAppFinder() == false {
				return hideDisplays()
			}
		}

		// Exit
		appDelegate.displayController.updateDisplays()
	}

	/// Changes the status bar icon.
	func updateIcon() {
		StatusController.updateIcon()
		updateAllInterfaces(reset: true)
	}

	/// Checks on the pause state of the app.
	func updatePause() {

		// See if the app is still paused
		if appDelegate.settings.settingPauseApp == true {
			hideAllInterfaces()
			StatusController.pauseIcon(paused: true)
		}

		// Otherwise resume the app
		else {
			updateAllInterfaces(reset: true)
			StatusController.pauseIcon(paused: false)
		}
	}

	// MARK: - Hide Functions

	/// Hides all interfaces.
	func hideAllInterfaces() {
		hideDisplays()
		appDelegate.menuController.updateMenu()
	}

	/// Hides active displays.
	func hideDisplays() {
		appDelegate.displayController.hideDisplays()
	}

	// MARK: - Snap Functions

	/// Snaps the display.
	func snapDisplays(_ event: NSEvent?) {
		appDelegate.displayController.snapDisplays(event)
	}

	// MARK: - Window Functions

	#warning("Add in interface controls")
	func openAboutWindow() {
		appDelegate.aboutWindowController.open()
	}

	func openAccessibilityWindow() {
		appDelegate.accessibilityWindowController.open()
	}

	func openWelcomeWindow() {
		appDelegate.welcomeWindowController.open()
	}

	func openLicensePanel() {
	}

	// MARK: - Utility Functions

	/// Resets state fields across the app.
	private func resetAppState() {
		appDelegate.pathController.oldSelection = nil
	}

	/// Checks to see if the active app is Finder
	private func utilityIsActiveAppFinder() -> Bool? {

		// Get the bundle id
		let bundleID = NSWorkspace.shared.frontmostApplication?.bundleIdentifier
		guard let appBundleID = NSRunningApplication.current.bundleIdentifier else { return nil }

		// If we're not interacting with Finder then hide the interface
		if bundleID != appBundleID, bundleID != "com.apple.finder" {
			return false
		}

		return true
	}
}
