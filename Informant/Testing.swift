//
//  Testing.swift
//  Informant
//
//  Created by Ty Irvine on 2022-04-16.
//

import Foundation

class Testing {

	let appDelegate: AppDelegate

	internal init(appDelegate: AppDelegate) {
		self.appDelegate = appDelegate

//		appDelegate.settingsWindowController.open()
//		appDelegate.welcomeWindowController.open()
//		appDelegate.aboutWindowController.open()
//		appDelegate.accessibilityWindowController.open()
//		appDelegate.displayController.updateDisplays()
//		testSnapZones()
	}

	// Test Snap Zone Positions
	func testSnapZones() {
		// Add new ones
		for snapPoint in appDelegate.displayController.allSnapPoints {
			let window = WindowController<TestView>(appDelegate: appDelegate)
			window.open()
			let mid = snapPoint.point
			let frame = window.window.frame
			window.window.setFrameOrigin(NSPoint(x: mid.x - (frame.width / 2), y: mid.y - (frame.height / 2)))
		}
	}
}
