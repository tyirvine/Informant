//
//  AppDelegate.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-21.
//

import Cocoa
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
	
	// ----------------------------- Universal ---------------------------
	
	// Settings
	var settings: Settings!
	
	// ----------------------------- Controllers ---------------------------

	// Status controller
	var statusController: StatusController!
	
	// Interaction controller
	var interactionController: InteractionController!
	
	// Data controller
	var dataController: DataController!
	
	// Interface controller
	var interfaceController: InterfaceController!
	
	// Display controller
	var displayController: DisplayController!
	
	// Menu controller
	var menuController: MenuController!
	
	// Path controller
	var pathController: PathController!
	
	// Update controller
	var updateController: UpdateController!
	
	// Settings controller
	var settingsController: SettingsController!
	
	// ------------------------------- Displays ----------------------------
	
	// Status display
	var statusDisplay: StatusDisplay!
	
	// Float display
	var floatDisplay: FloatDisplay!
	
	// ------------------------------- Windows -----------------------------
	
	// Settings window
	var settingsWindowController: WindowController<SettingsView>!
	
	// Welcome window
	var welcomeWindowController: WindowController<WelcomeView>!

	// About window
	var aboutWindowController: WindowController<AboutView>!

	// Accessibiility window
	var accessibilityWindowController: WindowController<AccessibilityView>!
	
	// Payment window
	var paymentWindowController: WindowController<PaymentView>!
	
	// -------------------------- Directors ------------------------------
	
	// Data director
	var dataDirector: DataDirector!
	
	// Notification director
	var notificationDirector: NotificationDirector!
	
	// -------------------------- Items ------------------------------
	
	/// We use this to access the menu bar status item. This toggles the panel open and closed. It's the main button.
	var statusItem: NSStatusItem?
	
	/// We use this to access the menu pop up.
	var statusMenu: NSMenu?
	
	// -------------------------- Testing ------------------------------
	
	#if DEBUG
	var testing: Testing?
	#endif
	
	// ======================== App Start ✳️ ============================
	
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		
		// MARK: - Initialize
		
		// Initialize settings
		Settings.registerDefaults()
		settingsController = SettingsController(appDelegate: self)
		settings = settingsController.settings
		
		// Initialize controllers
		menuController = MenuController(appDelegate: self)
		statusController = StatusController(appDelegate: self)
		interactionController = InteractionController(appDelegate: self)
		dataController = DataController(appDelegate: self)
		interfaceController = InterfaceController(appDelegate: self)
		displayController = DisplayController(appDelegate: self)
		pathController = PathController(appDelegate: self)
		updateController = UpdateController(appDelegate: self)
		
		// Initialize directors
		dataDirector = DataDirector()
		notificationDirector = NotificationDirector(appDelegate: self)
		
		// Initialize displays
		statusDisplay = StatusDisplay(appDelegate: self)
		floatDisplay = FloatDisplay(appDelegate: self)
		
		// Initialize windows
		settingsWindowController = WindowController(appDelegate: self, rootView: SettingsView(), fullToolbar: true)
		welcomeWindowController = WindowController(appDelegate: self, rootView: WelcomeView())
		aboutWindowController = WindowController(appDelegate: self, rootView: AboutView())
		accessibilityWindowController = WindowController(appDelegate: self, rootView: AccessibilityView())
		paymentWindowController = WindowController(appDelegate: self, rootView: PaymentView())
		
		// MARK: - Start up
		
		// Do an initialization of all displays
		interfaceController.updatePause()
		interfaceController.hideDisplays()
		
		#if DEBUG
		// Testing
		testing = Testing(appDelegate: self)
		#endif
	}

	// ======================== App Stop 🛑 ============================
	
	func applicationWillTerminate(_ aNotification: Notification) {
		interactionController.monitorKeyPress?.stop()
		interactionController.monitorMouseDismiss?.stop()
		interactionController.monitorDisplayMouseDrag?.stop()
	}

	func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
		return true
	}
}
