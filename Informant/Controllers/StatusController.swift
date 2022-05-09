//
//  StatusController.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-21.
//

import Foundation
import SwiftUI

class StatusController: Controller, ControllerProtocol {

	private let statusBar: NSStatusBar

	// ----------- Initialization --------------

	required init(appDelegate: AppDelegate) {

		// Initialize local fields
		statusBar = NSStatusBar.system

		// Initialize inherited fields
		super.init(appDelegate: appDelegate)

		// Creates a status bar item with a fixed length
		appDelegate.statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)

		// Intializes the menu bar button
		if let panelBarButton = appDelegate.statusItem?.button {

			// Status bar icon image
			panelBarButton.image = NSImage(named: appDelegate.settings.settingMenubarIcon)

			// Status bar icon image size
			panelBarButton.image?.size = NSSize(width: 17.5, height: 17.5)

			// Decides whether or not the icon follows the macOS menubar colouring
			panelBarButton.image?.isTemplate = true

			panelBarButton.imagePosition = .imageTrailing
			panelBarButton.imageHugsTitle = false

			// Updates constraint keeping the image in mind
			panelBarButton.updateConstraints()

			// This is the button's action it executes upon activation
			panelBarButton.sendAction(on: [.leftMouseUp, .rightMouseUp])
			panelBarButton.target = self

			// Updates size and position
			StatusController.updateIcon()
		}

		// Assign app's status menu to status item
		appDelegate.statusItem?.menu = appDelegate.statusMenu
	}

	// MARK: - Misc. Functions

	/// This function simply updates the menu bar icon with the current one stored in userdefaults
	static func updateIcon() {

		let appDelegate = AppDelegate.current()
		let statusItemButton = appDelegate.statusItem?.button
		let icon = appDelegate.settings.settingMenubarIcon

		statusItemButton?.image = NSImage(named: icon)
		statusItemButton?.image?.isTemplate = true
		statusItemButton?.image?.size = NSSize(width: 17.5, height: 17.5)

		statusItemButton?.updateConstraints()
	}

	/// Simply makes the icon look disabled.
	static func pauseIcon(paused: Bool) {

		let appDelegate = AppDelegate.current()
		let statusItemButton = appDelegate.statusItem?.button

		statusItemButton?.appearsDisabled = paused
	}
}
