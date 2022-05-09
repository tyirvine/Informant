//
//  Notifications.swift
//  Informant
//
//  Created by Ty Irvine on 2022-04-05.
//

import Cocoa
import Foundation
import SwiftUI

class NotificationDirector {
	
	let appDelegate: AppDelegate
	
	init(appDelegate: AppDelegate) {
		
		// Assign delegate
		self.appDelegate = appDelegate
		
		// Responsible for updating the accessibility state.
		// https://stackoverflow.com/a/56206516/13142325
		DistributedNotificationCenter.default().addObserver(
			forName: NSNotification.Name("com.apple.accessibility.api"),
			object: nil,
			queue: nil
		) { _ in
			self.didAccessibilityChange()
		}
		
		// Responsible for issuing updates about screen changes.
		// https://developer.apple.com/documentation/appkit/nsapplication/1428749-didchangescreenparametersnotific
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(didScreenChange),
			name: NSApplication.didChangeScreenParametersNotification,
			object: nil
		)
		
		// Checks for space focus changes
		NSWorkspace.shared.notificationCenter.addObserver(
			self,
			selector: #selector(didScreenChange),
			name: NSWorkspace.activeSpaceDidChangeNotification,
			object: nil
		)
		
		// Checks for app activations, like opening from command + space
		NSWorkspace.shared.notificationCenter.addObserver(
			self,
			selector: #selector(appActivation),
			name: NSWorkspace.didActivateApplicationNotification,
			object: nil
		)
	}
	
	// MARK: - Notification Handlers 🥽
	
	// Check to see if accessibility controls are enabled in sys. prefs.
	@objc func didAccessibilityChange() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.appDelegate.settings.statePrivacyAccessibilityEnabled = AXIsProcessTrusted()
			self.appDelegate.interfaceController.updateAllInterfaces()
		}
	}
	
	// Check to see if the screen changed!
	@objc func didScreenChange() {
		appDelegate.displayController.updateMonitors()
	}
	
	#warning("Make sure this works in release. It's difficult to test in Xcode.")
	// Opens up the settings window for the app
	@objc func appActivation(notification: NSNotification) {
		
		let foundBundleID = String(describing: notification.userInfo?["NSWorkspaceApplicationKey"])

		// Grab Informant's app bundle id - com.tyirvine.Informant
		guard let appBundleID = NSRunningApplication.current.bundleIdentifier else {
			return
		}

		// Open settings
		if foundBundleID.contains(appBundleID) {

			// Check if settings is open
			if appDelegate.settingsWindowController.window.isVisible == false {
				
				// Get a collection of windows that does not include the nsstatusbarwindows
				let windows = NSApplication.shared.windows.filter { window in
					window.description.contains("NSStatusBarWindow") == false
				}
				
				// If a window is visible then break execution of this fn.
				for window in windows {
					if window.isVisible {
						return
					}
				}

				appDelegate.settingsWindowController.open()
			}
		}
	}
	
	// Issues an update when any view changes
	/*
	 @objc func didViewChange() {
	 	interfaceController.updateDisplays()
	 }
	  */
}
