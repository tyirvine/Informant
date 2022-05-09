//
//  UpdateController.swift
//  Informant
//
//  Created by Ty Irvine on 2022-03-03.
//

import Foundation
import Sparkle

public enum UpdateFrequency: String {
	case AutoUpdate
	case None
}

/// Controls flow and initiation of updates.
class UpdateController: Controller, ControllerProtocol {

	let updater: Updater

	required init(appDelegate: AppDelegate) {
		updater = Updater()
		super.init(appDelegate: appDelegate)

		// Check to see for updates
		if appDelegate.settings.settingUpdateFrequency == .AutoUpdate {
			updater.checkForUpdates()
		}
	}

	/// This initiates a check for updates.
	func checkForUpdates() {
		updater.checkForUpdates()
	}
}

// This view model class manages Sparkle's updater and publishes when new updates are allowed to be checked
final class Updater {

	private let updaterController: SPUStandardUpdaterController

	init() {
		// If you want to start the updater manually, pass false to startingUpdater and call .startUpdater() later
		// This is where you can also pass an updater delegate if you need one
		updaterController = SPUStandardUpdaterController(startingUpdater: true, updaterDelegate: nil, userDriverDelegate: nil)
	}

	func checkForUpdates() {
		updaterController.checkForUpdates(nil)
	}
}
