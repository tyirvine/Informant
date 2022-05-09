//
//  SnapPoints.swift
//  Informant
//
//  Created by Ty Irvine on 2022-04-14.
//

import Foundation

/// A simple object that represents the snap zones for a connected monitor.
struct SnapPoint {

	// Collects information needed to create the snap zone
	let origin: NSPoint
	let size: NSSize

	/// This is what's used to find where to snap to.
	let point: NSPoint

	/// This is way to connect a snap point to the correct display point.
	let position: FramePosition

	/// This zone is constructed from the size and origin.
	/// It uses it's mid point to find the snap point.
	private let zone: NSRect

	// TODO: Make this adjustable in the future.
	/// This is the length of a single side for a snap zone.
	static let side: CGFloat = 20

	// MARK: - Initialize

	init(origin: NSPoint, position: FramePosition) {

		self.origin = origin
		self.position = position

		// Builds zone
		size = NSSize(width: Self.side, height: Self.side)
		zone = NSRect(origin: self.origin, size: size)

		// Build point
		point = NSPoint(
			x: zone.midX,
			y: zone.midY
		)
	}

	/// Returns the snap point as simple save object. It encodes the save object into JSON
	/// and then saves that to user defaults.
	func save() {

		// Get the save object and encoder
		let save = SnapPointSave(origin: origin, position: position.rawValue)
		let encoder = JSONEncoder()

		// Encode the save object and save it
		if let encoded = try? encoder.encode(save) {
			UserDefaults.standard.set(encoded, forKey: .keySavedSnapPoint)
		}
	}

	/// Reads the encoded JSON data stored in user defaults and returns it as a normal snap point.
	static func read() -> SnapPoint? {

		// Read the save data
		if let save = UserDefaults.standard.object(forKey: .keySavedSnapPoint) as? Data {

			// Decode the save data and then generate the snap point from the save object
			let decoder = JSONDecoder()
			if let read = try? decoder.decode(SnapPointSave.self, from: save) {
				return read.getSnapPoint()
			}
		}

		return nil
	}

	/// Returns the absolute delta value of the distance from the provided point to this snap point.
	func distance(_ providedPoint: NSPoint) -> CGFloat {

		// Find the delta between the two points
		let deltaX = (point.x - providedPoint.x).magnitude
		let deltaY = (point.y - providedPoint.y).magnitude

		// Find the distance using the Pythagorean theorem
		let a = pow(deltaX, 2)
		let b = pow(deltaY, 2)

		// Return hypotenuse distance
		return sqrt(a + b)
	}

	/// Returns an array of snap points using an array of frame points.
	static func getSnapPoints(_ framePoints: [FramePoint]) -> [SnapPoint] {

		var snapPoints: [SnapPoint] = []

		for framePoint in framePoints {
			snapPoints.append(SnapPoint(origin: framePoint.point, position: framePoint.position))
		}

		return snapPoints
	}
}

/// This is a simple object meant to be stored in user defaults.
struct SnapPointSave: Codable {
	var origin: NSPoint
	var position: String

	/// Generates a snap point from the save data.
	func getSnapPoint() -> SnapPoint {
		return SnapPoint(origin: origin, position: FramePosition(rawValue: position) ?? .TopRight)
	}
}

/// Joins snap point data with other data such as an additional point for a detached display.
struct SnapPointSearch {

	/// This is the snap zone found.
	let snapPointFound: SnapPoint

	/// This is the point found within the snap zone.
	var displayPointFound: NSPoint? {

		// Get the corresponding point for snap point
		guard let correspondingPoint = FramePoint.getCorrespondingPoint(displayPoints, snapPointFound.position) else {
			return nil
		}

		// Assign the corresponding point
		return correspondingPoint.point
	}

	/// These are all the display points found in the search.
	let displayPoints: [FramePoint]

	/// This is the point to point distance between the two points.
	let distance: CGFloat?

	internal init(_ snapPointFound: SnapPoint, _ displayPoints: [FramePoint], _ distance: CGFloat) {
		self.snapPointFound = snapPointFound
		self.distance = distance
		self.displayPoints = displayPoints
	}
}
