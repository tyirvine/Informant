//
//  InteractionController.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-21.
//

import Foundation
import SwiftUI

class InteractionController: Controller, ControllerProtocol {

	// Universal interaction monitors
	public var monitorMouseDismiss: EventMonitorHelper?
	public var monitorKeyPress: EventMonitorHelper?

	// Display interaction monitors
	public var monitorDisplayMouseDrag: EventMonitorHelper?

	// ----------- Initialization --------------

	required init(appDelegate: AppDelegate) {
		super.init(appDelegate: appDelegate)

		// Monitors mouse events
		monitorMouseDismiss = EventMonitorHelper(mask: [.leftMouseDown, .rightMouseDown, .leftMouseUp, .rightMouseUp], handler: handlerMouseDismiss)

		// Monitors key events
		monitorKeyPress = EventMonitorHelper(mask: [.keyDown, .keyUp], handler: handlerArrowKeys)

		// Monitor drags
		monitorDisplayMouseDrag = EventMonitorHelper(mask: [.leftMouseUp, .rightMouseUp, .otherMouseUp], handler: handlerDisplayMouseDrag)

		// These get stopped when the application is torn down
		monitorMouseDismiss?.start()
		monitorKeyPress?.start()
		monitorDisplayMouseDrag?.start()
	}

	// MARK: - Interface Functions

	/// Tells the display controller we want to hide the displayed views.
	func hideDisplays() {
		appDelegate.interfaceController.hideDisplays()
	}

	/// Tells the display controller we want to update the displayed views.
	func updateDisplays() {
		appDelegate.interfaceController.updateDisplays()

		// TODO: Try and come up with a better solution for this.
		// Selections are being found faster than Finder can provide the selection, therefore,
		// a double-check is needed to confirm the correct selection was made.
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.appDelegate.interfaceController.updateDisplays()
		}
	}

	// MARK: - Display Monitor Functions

	/// Helper function to activate a snap check for the currently selected display.
	func handlerDisplayMouseDrag(event: NSEvent?) {
		appDelegate.interfaceController.snapDisplays(event)
	}

	// MARK: - Monitor Functions

	/// Helper function to let us know what type of event the provided one is
	func eventTypeCheck(_ event: NSEvent?, types: [NSEvent.EventType]) -> Bool {
		for type in types {
			if event?.type == type {
				return true
			}
		}

		// All checks down with no positives found
		return false
	}

	// MARK: Mouse Dismiss
	// Hides interface if no finder items are selected. Otherwise update the interface - based on left and right clicks
	func handlerMouseDismiss(event: NSEvent?) {

		// A selection is intended so send an update to the display controller
		if eventTypeCheck(event, types: [.leftMouseUp, .rightMouseUp, .otherMouseUp]) {
			updateDisplays()
		}
	}

	// MARK: Key Detection
	/// Used by the keyedWindowHandler to decide how many updates to the interface to do
	var keyCounter = 0

	/// Used by the key down & up monitor, this updates the interface if it's an arrow press and closes it with any other press
	func handlerArrowKeys(event: NSEvent?) {

		/// If it's a repeating key, update the interface every other key instead
		/// Once the user lifts the key this function is called again - that key lift doesn't count as a repeating key.
		/// So that means that this block ⤵︎ is skipped when the user lifts their held keypress meaning that
		/// the interface will get updated immediately with the selected file.

		/// Finder uses simillar functionallity with it's quicklook
		if event!.isARepeat {

			// Adds to count and will only update when the threshold below is reached
			keyCounter += 1

			// Checks every 10 items. A good blend between performance and power consumption
			if keyCounter >= 10 {
				updateDisplays()
				keyCounter = 0
				return
			}
			else {
				return
			}
		}

		// ---------------------- Start execution ---------------------
		let key = event?.keyCode

		switch key {

		// If esc key press is detected on down press then hide the interface
		case 53:
			if event?.type == NSEvent.EventType.keyDown {
				hideDisplays()
			}
			break

		// if ⌘ + del is pressed, then hide all interfaces
		case 51:
			if event?.modifierFlags.contains(.command) == true {
				hideDisplays()
			}

		// Otherwise, update the displays
		default:
			updateDisplays()
			break
		}
	}
}
