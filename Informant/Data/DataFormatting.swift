//
//  DataFormatting.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-24.
//

import Foundation

class DataFormatting {

	/// Takes in a directory item count and formats it accordingly
	static func formatDirectoryItemCount(_ itemCount: Int) -> String {
		return String(itemCount) + " " + (itemCount > 1 ? ContentManager.Extra.items : ContentManager.Extra.item)
	}

	/// Formats a raw hertz reading into hertz or kilohertz
	static func formatSampleRate(_ hertz: Any?) -> String? {
		guard let contentHertz = hertz as? Double else { return nil }

		// Format as hertz
		if contentHertz < 1000 {
			return String(format: "%.0f", contentHertz) + " Hz"
		}

		// Format as kilohertz
		else {
			let kHz = contentHertz / 1000
			return String(format: "%.1f", kHz) + " kHz"
		}
	}

	/// Formats raw byte size into kbps
	static func formatBitrate(_ bitCount: Float) -> String? {

		let bits = bitCount

		let formattedBits: NSNumber
		let unitDescription: String

		// Figure out the size
		// Bits per second
		if bits < 1000 {
			formattedBits = NSNumber(value: bits)
			unitDescription = "bps"
		}

		// Kilobits per second
		else if bits < 1000000 {
			formattedBits = NSNumber(value: bits / 1000.0)
			unitDescription = "kbps"
		}

		// Megabits per second
		else if bits < 1000000000 {
			formattedBits = NSNumber(value: bits / 1000.0 / 1000.0)
			unitDescription = "Mbps"
		}

		// Gigabits per second
		else {
			formattedBits = NSNumber(value: bits / 1000.0 / 1000.0 / 1000.0)
			unitDescription = "Gbps"
		}

		let formatter = NumberFormatter()
		formatter.maximumFractionDigits = 2

		guard let bitsPerSecond = formatter.string(from: formattedBits) else {
			return nil
		}

		return "\(bitsPerSecond) \(unitDescription)"
	}

	/// Formats seconds into a DD:HH:MM:SS format (days, hours, minutes, seconds)
	static func formatDuration(_ duration: Any?) -> String? {

		guard let contentDuration = duration as? Double else { return nil }

		// Round duration by casting to int
		let roundedDuration = contentDuration.rounded(.toNearestOrAwayFromZero)

		let interval = TimeInterval(roundedDuration)

		// Setup formattter
		let formatter = DateComponentsFormatter()
		formatter.zeroFormattingBehavior = [.pad]

		// If the duration is under an hour then use a shorter formatter
		if contentDuration > 3599.0 {
			formatter.allowedUnits = [.hour, .minute, .second]
		}

		// Otherwise use the expanded one
		else {
			formatter.allowedUnits = [.minute, .second]
		}

		return formatter.string(from: interval)
	}

	/// Simply formats the dimensions for the resource.
	static func formatDimensions(x: Any?, y: Any?) -> String? {
		guard let pixelwidth = x as? Int else { return nil }
		guard let pixelheight = y as? Int else { return nil }

		let xStr = String(describing: pixelwidth)
		let yStr = String(describing: pixelheight)

		return xStr + " × " + yStr
	}
}
