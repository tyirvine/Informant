//
//  WindowController.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-21.
//

import AppKit
import Foundation
import SwiftUI

/// This is a generalized controller for all windows in the app.
class WindowController<Content: View>: Controller, ControllerProtocol {
	
	let window: NSWindow!
	
	required init(appDelegate: AppDelegate) {
		
		window = NSWindow()
		window.contentViewController = NSHostingController(rootView: TestView())
		window.backgroundColor = .white
		window.titlebarAppearsTransparent = true
		window.styleMask = [.borderless, .fullSizeContentView]
		
		super.init(appDelegate: appDelegate)
		
		print("‼️ WindowController - This initializer isn't meant to be used and is only for TESTING. Please check which initializer you're using to instantiate this object.")
	}

	required init(appDelegate: AppDelegate, rootView: Content, fullToolbar: Bool = false) {
		
		window = NSWindow(
			contentRect: NSRect(x: 0, y: 0, width: 100, height: 100),
			styleMask: [.closable, .unifiedTitleAndToolbar, .fullSizeContentView, .titled],
			backing: .buffered,
			defer: false
		)
		
		super.init(appDelegate: appDelegate)
		
		// Setup window
		window.titlebarAppearsTransparent = true
		
		// Hide buttons if it's not a full toolbar
		if fullToolbar {
			window.styleMask.insert(.miniaturizable)
		} else {
			window.standardWindowButton(.miniaturizeButton)?.isHidden = true
			window.standardWindowButton(.zoomButton)?.isHidden = true
		}

		// Misc.
		window.isReleasedWhenClosed = false
		
		// Animation
		window.animationBehavior = .default
		
		// Connect view
		window.contentViewController = NSHostingController(rootView: rootView)
	}
	
	/// Opens up the window
	func open() {
		window.center()
		window.makeKeyAndOrderFront(nil)
		NSApp.activate(ignoringOtherApps: true)
	}
	
	/// Closes down the window
	func close() {
		window.close()
	}
}
