//
//  DisplayDetached.swift
//  Informant
//
//  Created by Ty Irvine on 2022-04-16.
//

import Foundation
import SwiftUI

/// This provides extra functionality for displays that are detached.
class DetachedDisplayClass: DisplayClass {

	let window: NSWindow

	required init(appDelegate: AppDelegate) {
		self.window = NSWindow()
		super.init(appDelegate: appDelegate)
		print("‼️ DetachedDisplay - This initializer isn't meant to be used and is only for TESTING. Please check which initializer you're using to instantiate this object.")
	}

	init(appDelegate: AppDelegate, window: NSWindow) {
		self.window = window
		super.init(appDelegate: appDelegate)
	}

	/// This gets the origin point based on a provided snap point.
	func getRelativeOrigin(_ snapPoint: SnapPoint) -> NSPoint {
		let position = snapPoint.position
		let displayPoint = FramePoint.getCorrespondingPointWithFrame(window.frame, position)
		return calculateRelativeOrigin(snapPoint, displayPoint)
	}

	/// This takes in a display point and snap point and calculates the relative origin.
	func calculateRelativeOrigin(_ snapPoint: SnapPoint, _ displayPoint: NSPoint) -> NSPoint {

		// Find the delta x and delta y between the snap zone and the found point
		let deltaX = snapPoint.point.x - displayPoint.x
		let deltaY = snapPoint.point.y - displayPoint.y

		// Find where the display's origin is relative to the mid. point of the snap zone
		return NSPoint(
			x: window.frame.origin.x + deltaX,
			y: window.frame.origin.y + deltaY
		)
	}

	/// This gets the origin point on the active desktop.
	func getRelativeOriginOnActiveDesktop(_ snapPoint: SnapPoint) -> NSPoint? {

		// Get active desktop screen
		guard let main = NSScreen.main else {
			return nil
		}

		let position = snapPoint.position

		// Get relative snap point on the active desktop screen using the provided one
		let relativePoint = FramePoint.getCorrespondingPointWithFrame(main.visibleFrame, position, SnapPoint.side)

		// Save the snap point for future snaps or sessions
		let relativeSnapPoint = SnapPoint(origin: relativePoint, position: position)
		relativeSnapPoint.save()

		// Return the relative origin
		return getRelativeOrigin(relativeSnapPoint)
	}
}

/// This is the protocol that only detached displays adhere to.
protocol DetachedDisplayProtocol: DisplayProtocol {

	// Functions
	func snap()
	func refresh()
	func window() -> NSWindow
}

typealias DetachedDisplay = DetachedDisplayClass & DetachedDisplayProtocol
