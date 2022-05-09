//
//  FramePoints.swift
//  Informant
//
//  Created by Ty Irvine on 2022-04-15.
//

import Foundation

struct FramePoint {

	/// Provides the position this point is located at.
	let position: FramePosition

	/// This is the actual display point.
	let point: NSPoint

	internal init(_ point: NSPoint, _ position: FramePosition) {
		self.position = position
		self.point = point
	}

	/// This gets a single point on the provided frame for the provided position.
	static func getCorrespondingPointWithFrame(_ frame: NSRect, _ position: FramePosition, _ offset: CGFloat = 0) -> NSPoint {

		// Calculate width and height accounting for snap zone side length.
		let maxX = frame.maxX - offset
		let maxY = frame.maxY - offset
		let midX = frame.midX - offset
		let midY = frame.midY - offset
		let minX = frame.minX
		let minY = frame.minY

		switch position {
			case .TopLeft:
				return NSPoint(x: minX, y: maxY)

			case .TopMiddle:
				return NSPoint(x: midX, y: maxY)

			case .TopRight:
				return NSPoint(x: maxX, y: maxY)

			case .MiddleLeft:
				return NSPoint(x: minX, y: midY)

			case .MiddleMiddle:
				return NSPoint(x: midX, y: midY)

			case .MiddleRight:
				return NSPoint(x: maxX, y: midY)

			case .BottomLeft:
				return NSPoint(x: minX, y: minY)

			case .BottomMiddle:
				return NSPoint(x: midX, y: minY)

			case .BottomRight:
				return NSPoint(x: maxX, y: minY)
		}
	}

	/// This finds the corresponding point out of a collection of points for the provided position.
	static func getCorrespondingPoint(_ points: [FramePoint], _ correspondingPosition: FramePosition) -> FramePoint? {
		return points.first { point in
			point.position == correspondingPosition
		}
	}

	/// This gets all nine frame points for any given frame.
	static func getPoints(frame: NSRect, offset: CGFloat = 0) -> [FramePoint] {

		// Calculate width and height accounting for snap zone side length.
		let maxX = frame.maxX - offset
		let maxY = frame.maxY - offset
		let midX = frame.midX - offset
		let midY = frame.midY - offset
		let minX = frame.minX
		let minY = frame.minY

		// Tops
		let originTopLeft = NSPoint(x: minX, y: maxY)
		let originTopMiddle = NSPoint(x: midX, y: maxY)
		let originTopRight = NSPoint(x: maxX, y: maxY)

		// Middles
		let originMiddleLeft = NSPoint(x: minX, y: midY)
		let originMiddleMiddle = NSPoint(x: midX, y: midY)
		let originMiddleRight = NSPoint(x: maxX, y: midY)

		// Bottoms
		let originBottomLeft = NSPoint(x: minX, y: minY)
		let originBottomMiddle = NSPoint(x: midX, y: minY)
		let originBottomRight = NSPoint(x: maxX, y: minY)

		return [
			FramePoint(originTopLeft, .TopLeft),
			FramePoint(originTopMiddle, .TopMiddle),
			FramePoint(originTopRight, .TopRight),

			FramePoint(originMiddleLeft, .MiddleLeft),
			FramePoint(originMiddleMiddle, .MiddleMiddle),
			FramePoint(originMiddleRight, .MiddleRight),

			FramePoint(originBottomLeft, .BottomLeft),
			FramePoint(originBottomMiddle, .BottomMiddle),
			FramePoint(originBottomRight, .BottomRight)
		]
	}
}

/// This is way to connect a snap point to the correct display point.
public enum FramePosition: String {
	case TopLeft
	case TopMiddle
	case TopRight

	case MiddleLeft
	case MiddleMiddle
	case MiddleRight

	case BottomLeft
	case BottomMiddle
	case BottomRight
}
