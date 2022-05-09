//
//  AppleScripts.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import Foundation

// MARK: - Apple Scripts
/// Used to store and use any apple scripts

class PathController: Controller, ControllerProtocol {

	/// This stores the previously selected url.
	var oldSelection: [String]?

	required init(appDelegate: AppDelegate) {
		super.init(appDelegate: appDelegate)
	}

	// Find the currently selected Finder files in a string format with line breaks.
	func getSelectedPaths() -> Paths? {

		// Find selected items as a list with line breaks
		var errorInformation: NSDictionary?

		/// Apple script that tells Finder to give us the file paths
		let script = NSAppleScript(source: """
		set AppleScript's text item delimiters to linefeed
		tell application "Finder" to POSIX path of (selection as text)
		""")

		// Check for errors before using
		guard let scriptExecuted = script?.executeAndReturnError(&errorInformation) else {

			// Erase old selection
			oldSelection = nil

			// If error is present then let the user know that we're unable to get the selection
			if errorInformation != nil {
				return Paths(paths: nil, state: .PathError)
			}

			return nil
		}

		// Parse list for colons and replace with slashes
		guard let selectedItems = scriptExecuted.stringValue else {
			return nil
		}

		// Convert list with line breaks to string array
		let selectedItemsAsArray = selectedItems.components(separatedBy: .newlines)

		// Check for duplicates
		if let oldSelection = oldSelection, selectedItemsAsArray.areStringsEqual(oldSelection) {
			return Paths(paths: nil, state: .PathDuplicate)
		} else {
			oldSelection = selectedItemsAsArray
		}

		// Check for an empty selection
		if selectedItemsAsArray[0].isEmpty {
			return Paths(paths: nil, state: .PathUnavailable)
		}

		#warning("Remove from production")
		print("🥒 Path Found: \(selectedItemsAsArray)")

		// Exit
		return Paths(paths: selectedItemsAsArray, state: .PathAvailable)
	}
}
