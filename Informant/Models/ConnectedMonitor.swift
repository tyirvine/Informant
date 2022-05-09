//
//  ConnectedMonitor.swift
//  Informant
//
//  Created by Ty Irvine on 2022-04-14.
//

import AppKit
import Foundation

/// A simple object to represent a connected monitor.
struct ConnectedMonitor {

	/// The name of the connected monitor.
	let name: String

	/// The width of the monitor.
	let width: CGFloat

	/// The height of the monitor.
	let height: CGFloat

	/// Width x height.
	var dimensions: NSSize {
		NSSize(width: self.width, height: self.height)
	}

	/// The monitor object.
	let screen: NSScreen

	/// This is a single side length of a snap zone.
	let side: CGFloat

	// Get the screen origin without the dock and menu bar
	// Note: The dock has to have hiding turned in order for it to be part of the sizing
	/// Simply the frame we wanna use.
	var visibleFrame: NSRect {
		self.screen.visibleFrame
	}

	init(_ screen: NSScreen) {
		self.name = screen.localizedName
		self.width = screen.visibleFrame.width
		self.height = screen.visibleFrame.height
		self.screen = screen

		// TODO: This needs to be integrated into settings
		self.side = SnapPoint.side
	}

	/// Returns all snap zones for the monitor.
	func getSnapPoints() -> [SnapPoint] {

		// Logs the zero position for the screen
		print("📌 SCREEN ORIGIN: \(self.visibleFrame.origin)")

		// Calculate width and height accounting for snap zone side length.
		let framePoints = FramePoint.getPoints(frame: self.visibleFrame, offset: self.side)

		// Returns all snap points using the given frame points
		return SnapPoint.getSnapPoints(framePoints)
	}

	/// Gets the default top right point for the monitor.
	func getDefaultPoint() -> SnapPoint {
		let position = FramePosition.TopRight
		let defaultPoint = FramePoint.getCorrespondingPointWithFrame(self.visibleFrame, position, self.side)
		return SnapPoint(origin: defaultPoint, position: position)
	}
}
