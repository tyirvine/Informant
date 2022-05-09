//
//  Extensions.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-21.
//

import AVFoundation
import Foundation
import SwiftUI

// This is so weird. This gets the codecs but it's really convoluted.
// https://developer.apple.com/documentation/avfoundation/avassettrack/1386694-formatdescriptions
extension AVAssetTrack {
	var mediaFormat: String {
		var format = ""
		let descriptions = self.formatDescriptions as! [CMFormatDescription]
		for (index, formatDesc) in descriptions.enumerated() {
			// Get a string representation of the media subtype.
			let subType =
				CMFormatDescriptionGetMediaSubType(formatDesc).toString()
			// Format the string as type/subType, such as vide/avc1 or soun/aac.
			format += "\(subType.uppercased().replacingOccurrences(of: ".", with: ""))"
			// Comma-separate if there's more than one format description.
			if index < descriptions.count - 1 {
				format += ","
			}
		}
		return format
	}
}

extension FourCharCode {
	// Create a string representation of a FourCC.
	func toString() -> String {
		let bytes: [CChar] = [
			CChar((self >> 24) & 0xff),
			CChar((self >> 16) & 0xff),
			CChar((self >> 8) & 0xff),
			CChar(self & 0xff),
			0
		]
		let result = String(cString: bytes)
		let characterSet = CharacterSet.whitespaces
		return result.trimmingCharacters(in: characterSet)
	}
}

extension Array where Element == String {

	/// Checks to see if all elements in the new array are equal to the elements in the old array.
	func areStringsEqual(_ other: [String]) -> Bool {

		for (index, string) in self.enumerated() {

			if other.indices.contains(index), other[index] == string {
				continue
			} else {
				return false
			}
		}

		// All elements are equal
		return true
	}
}

extension AppDelegate {

	/// Returns the version of the app.
	static func version() -> String? {

		guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
			return nil
		}

		return version
	}
}

extension Text {

	/// Adds some extra padding at the end
	func togglePadding() -> some View {
		self.padding([.leading], 4)
	}
}

extension Date {

	/// This takes in a date object and returns a formatted date as a string.
	func formatDate() -> String {

		// Format dates as strings
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		dateFormatter.doesRelativeDateFormatting = true

		return dateFormatter.string(from: self)
	}
}

extension Int {

	/// Formats raw byte size into a familliar 10MB, 3.2GB, etc.
	func formatBytes() -> String {
		return ByteCountFormatter().string(fromByteCount: Int64(self))
	}
}

extension Int64 {

	/// Formats raw byte size into a familliar 10MB, 3.2GB, etc.
	func formatBytes() -> String {
		return ByteCountFormatter().string(fromByteCount: self)
	}
}

extension String {

	/// Wraps all special characters. Used primarily for making paths terminal friendly.
	func formatSpecialCharacters() -> String {

		var string = self
		var escapes = 0

		// Cycle through characters and place escapes
		for (index, char) in string.enumerated() {
			if char.isSymbol || char.isWhitespace || char == "&" {
				string.insert("\\", at: string.index(string.startIndex, offsetBy: index + escapes))
				escapes += 1
			}
		}

		// Remove tilde escape from start
		if string.first == "\\" {
			string.removeFirst()
		}

		return string
	}

	/// Translates HFS path to POSIX path.
	/// [Check this out for more info](https://en.wikibooks.org/wiki/AppleScript_Programming/Aliases_and_paths).
	func posixPathFromHFSPath() -> String? {

		#warning("This needs to be re-written to not rely on the volumes keyword")
		guard let fileCFURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, ("Volumes:" + self) as CFString?, CFURLPathStyle(rawValue: 1)!, hasSuffix(":")) else {
			return nil
		}

		let fileURL = fileCFURL as URL

		return fileURL.path
	}
}

extension URL {

	/// Converts an array of string paths to URLs
	static func convertPathsToURLs(_ urls: [String]) -> [URL] {
		var convertedURLs: [URL] = []
		for url in urls {
			convertedURLs.append(URL(fileURLWithPath: url))
		}
		return convertedURLs
	}
}

extension NSMenuItem {

	/// Makes the button more juicy to click
	func juicyWithoutImage() {
		self.image = NSImage()
		self.image?.size = NSSize(width: 0.01, height: Style.Menu.juicyImageHeight)
	}

	/// Makes the button more juicy to click when an image is present
	func juicyWithImage() {
		self.image?.isTemplate = true
		self.image?.size = NSSize(width: Style.Menu.juicyImageWidth, height: Style.Menu.juicyImageHeight)
	}

	/// Sets up the image for the nsmenuitem
	func setupImage(_ resourceName: String) {
		self.image = NSImage(imageLiteralResourceName: resourceName)
		self.juicyWithImage()
	}
}

extension AppDelegate {

	/// Provides the current instance of the app delegate along with all fields present in the class.
	static func current() -> AppDelegate {
		return NSApp.delegate as! AppDelegate
	}
}
