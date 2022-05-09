//
//  FloatDisplay.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-25.
//

import Foundation
import SwiftUI

/// This is a controller for the float display.
class FloatDisplay: DetachedDisplay {

	/// This is the floating menu bar that is used when using the existing menu bar is not possible.
	/// For example, on 2022+ MacBook Pros.
	let float: NSWindow!

	/// Keeps track of transitioning windows.
	var transitioning: Bool = false

	/// Keeps track of animation states. Makes sure, animation states aren't interrupted as they come up.
	var animationState: AnimationState?

	enum AnimationState {
		case Opening
		case Closing
	}

	required init(appDelegate: AppDelegate) {

		// Initialize the floating menu bar
		float = NSWindow(
			contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
			styleMask: [.closable, .unifiedTitleAndToolbar, .resizable, .fullSizeContentView, .titled],
			backing: .buffered,
			defer: false
		)

		// Setup remaining fields
		float?.titlebarAppearsTransparent = true

		// Hide all title buttons
		float.standardWindowButton(.closeButton)?.isHidden = true
		float.standardWindowButton(.miniaturizeButton)?.isHidden = true
		float.standardWindowButton(.zoomButton)?.isHidden = true

		// Behaviours
		float.isReleasedWhenClosed = false
		float.animationBehavior = .default
		float.isMovableByWindowBackground = true
		float.level = .floating

		// Set the minimum size - for some reason this changes depending on the behaviour of the display
		// so it has to be set.
		float.minSize = NSSize(width: 0, height: 44)

		super.init(appDelegate: appDelegate, window: float)
	}

	/// This updates the display.
	func display(_ data: SelectionData, _ info: SelectionInfo) {

		// Format the selection
		guard let selectionFormatted = appDelegate.displayController.formatSelectionAsFields(data, info) else {
			return hide()
		}

		// Create the view with the formatted selection
		let rootView = FloatDisplayView(fields: selectionFormatted, appDelegate: appDelegate)

		// Assign the view
		float.contentViewController = NSHostingController(rootView: rootView)

		// Bail if the window is transitioning
		if transitioning {
			return
		}

		// Get the saved snap position
		let savedSnapPoint = appDelegate.displayController.findSavedSnapPoint()

		// Is the panel on the active desktop
		let onActiveDesktop = float.screen == NSScreen.main

		// Get the relative origin by calculating the delta
		guard let relativeOrigin = onActiveDesktop ? getRelativeOrigin(savedSnapPoint) : getRelativeOriginOnActiveDesktop(savedSnapPoint) else {
			return
		}

		// At this point the float display needs to switch screens
		if onActiveDesktop == false {
			transition(relativeOrigin)
		}

		// Otherwise, open the display normally
		else {
			open(relativeOrigin)
		}
	}

	/// Simply opens the display.
	func open(_ origin: NSPoint) {

		animationState = .Opening

		// Translate the window to that position
		float.setFrameOrigin(origin)

		// Display the window
		float.orderFront(nil)

		// Only show when transitioning
		if float.isOnActiveSpace == false {
			float.alphaValue = 0
		}

		// Animate window in
		animate(alpha: 1) {

			// Display the window
			if self.animationState == .Opening {
				self.float.orderFront(nil)
			}

			// Set the display to be open
			self.isOpen = true
		}
	}

	/// This hides the display.
	func hide() {

		animationState = .Closing

		#warning("Remove from production: Reset to 0")
		animate(alpha: 0.4) {

			if self.animationState == .Closing {
				self.float.close()
			}

			// Set the display to be closed
			self.isOpen = false
		}
	}

	/// This hides the display.
	func transition(_ origin: NSPoint) {

		// Record start of transition
		transitioning = true

		// Begin transitioning
		#warning("Remove from production: Reset to 0")
		animate(alpha: 0.4) {

			self.open(origin)

			// End transition
			self.transitioning = false
		}
	}

	/// This shows an error message on the display.
	func error() {
		hide()
	}

	/// This simply animates the window.
	func animate(alpha: CGFloat, _ completion: @escaping () -> Void) {
		DispatchQueue.main.async {
			NSAnimationContext.runAnimationGroup { context -> Void in
				context.duration = TimeInterval(0.25)
				self.float.animator().alphaValue = alpha
			} completionHandler: {
				completion()
			}
		}
	}

	// MARK: - Detached Display Functions

	/// Simply refreshes the position of the display.
	func refresh() {
		guard let data = selectionData else { return }
		guard let info = selectionInfo else { return }

		if isOpen == true {
			display(data, info)
		}
	}

	/// This snaps the display to the designated corner.
	func snap() {

		// Check to see if the display is closed first
		if isOpen == false {
			return
		}

		// Sees if this display is inside a snap zone
		guard let snapPointSearch = appDelegate.displayController.closestSnapPointSearch(float.frame) else {
			return // The display was not inside a snap zone, so abort
		}

		// At this point, the display is inside a snap zone!
		let snapPoint = snapPointSearch.snapPointFound

		// Get the corresponding display point
		guard let displayPoint = snapPointSearch.displayPointFound else {
			return
		}

		// Calculates the relative origin
		let relativeDisplayOrigin = calculateRelativeOrigin(snapPoint, displayPoint)

		// Bring the display to the front
		float.orderFront(nil)

		// Get a temporary copy of the window
		var tempFloatFrame = float.frame

		// Translate the temporary frame's origin
		tempFloatFrame.origin = relativeDisplayOrigin

		// Animate the window's position
		NSAnimationContext.runAnimationGroup({ context in
			context.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
			context.duration = TimeInterval(0.2)
			float.animator().setFrame(tempFloatFrame, display: true, animate: true)
		}, completionHandler: {

		})

		// Exit with this message
		print("✨ DISPLAY SNAPPED - IS VISIBLE: \(float.isVisible)")
	}

	/// This returns the window for the display.
	func window() -> NSWindow {
		return float
	}
}
