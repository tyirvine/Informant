//
//  MenuController.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-21.
//

import AppKit
import Foundation

/// Controls the NSMenu instance for the app.
class MenuController: Controller, ControllerProtocol {
	
	let menu: NSMenu!
	
	// Standard menu items
	let menuItemAccessibility: NSMenuItem!
	let menuItemPause: NSMenuItem!
	let menuItemAbout: NSMenuItem!
	let menuItemPreferences: NSMenuItem!
	let menuItemQuit: NSMenuItem!
	
	required init(appDelegate: AppDelegate) {
		
		// MARK: - Setup menu bar items
		
		// Create NSMenu instance
		appDelegate.statusMenu = NSMenu()
		
		// Assign NSMenu
		menu = appDelegate.statusMenu
		
		// Create NSMenuItem instances
		menuItemAccessibility = NSMenuItem(title: ContentManager.Labels.menuAccessibility, action: #selector(menuAccessibility), keyEquivalent: "")
		menuItemPause = NSMenuItem(title: ContentManager.Labels.menuPause, action: #selector(menuPauseApp), keyEquivalent: "")
		menuItemAbout = NSMenuItem(title: ContentManager.Labels.menuAbout, action: #selector(menuAbout), keyEquivalent: "")
		menuItemPreferences = NSMenuItem(title: ContentManager.Labels.menuPreferences, action: #selector(menuPreferences), keyEquivalent: ",")
		menuItemQuit = NSMenuItem(title: ContentManager.Labels.menuQuit, action: #selector(menuQuitApp), keyEquivalent: "")
		
		super.init(appDelegate: appDelegate)
		
		// Assign menu item target's to this instance of this class
		menuItemAccessibility.target = self
		menuItemPause.target = self
		menuItemAbout.target = self
		menuItemPreferences.target = self
		menuItemQuit.target = self
		
		// Assign images to the menu items
		menuItemAccessibility.setupImage(ContentManager.Icons.lock)
		menuItemPause.setupImage(ContentManager.Icons.pause)
		
		// Setup the NSMenu
		updateMenu()
		
		// Set the size of the NSMenu
		menu.minimumWidth = 225
	}
	
	// MARK: - Menu Functions

	/// This updates the state of the menu and adds, removes, or disables menu items depending on the settings controller.
	func updateMenu() {
		
		print("🐯 Accessibility Status: \(String(describing: appDelegate.settings.statePrivacyAccessibilityEnabled))")
		
		// Remove authorization menu item if authorized and restore all other items
		if appDelegate.settings.statePrivacyAccessibilityEnabled == true {
			menu.removeAllItems()
			setupMenuDefault()
		}
		
		// Add authroization menu item if not authorized and hide all other items except for the quit button
		else {
			menu.removeAllItems()
			setupMenuAccessibility()
		}
		
		// Exit
		updateMenuItems()
		appDelegate.statusItem?.menu = menu
	}
	
	/// Updates menu item titles based on the state of the settings controller.
	func updateMenuItems() {
		
		// Pause app
		if appDelegate.settings.settingPauseApp == true {
			menuItemPause.title = ContentManager.Labels.menuResume
			menuItemPause.setupImage(ContentManager.Icons.resume)
		} else {
			menuItemPause.title = ContentManager.Labels.menuPause
			menuItemPause.setupImage(ContentManager.Icons.pause)
		}
	}
	
	/// This is the default set up for the NSMenu.
	func setupMenuDefault() {
		menu.addItem(menuItemPause)
		menu.addItem(NSMenuItem.separator())
		menu.addItem(menuItemAbout)
		menu.addItem(menuItemPreferences)
		menu.addItem(NSMenuItem.separator())
		menu.addItem(menuItemQuit)
	}
	
	/// This is the accessibility set up for the NSMenu.
	func setupMenuAccessibility() {
		menu.addItem(menuItemAccessibility)
		menu.addItem(NSMenuItem.separator())
		menu.addItem(menuItemAbout)
		menu.addItem(menuItemPreferences)
		menu.addItem(NSMenuItem.separator())
		menu.addItem(menuItemQuit)
	}
	
	// MARK: - Menu Item Functions
	
	/// This opens up the accessibility window.
	@objc func menuAccessibility() {
		appDelegate.accessibilityWindowController.open()
	}
	
	/// This simply pauses the app so no further selections can be made.
	@objc func menuPauseApp() {
		appDelegate.settings.settingPauseApp.toggle()
	}

	/// This opens up the about window.
	@objc func menuAbout() {
		appDelegate.aboutWindowController.open()
	}

	/// This opens up the preferences window.
	@objc func menuPreferences() {
		appDelegate.settingsWindowController.open()
	}

	/// This quits the application.
	@objc func menuQuitApp() {
		NSApp.terminate(nil)
	}
}
