//
//  StatusDisplay.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-25.
//

import Foundation
import SwiftUI

/// This is a controller for the status display.
class StatusDisplay: Display {

	/// This is a ref. to the status item in the menu bar
	let statusItem: NSStatusItem!

	/// This is a ref. to the sizing status item in the menu bar
	var statusItemSizing: NSStatusItem?

	/// This is the font that is used in the status bar.
	let font = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)

	/// Keeps track of the old selection so we can make decisions about updating the interface.
	var oldSelection: String?

	required init(appDelegate: AppDelegate) {

		// Assigns the status item ref to this field
		statusItem = appDelegate.statusItem

		super.init(appDelegate: appDelegate)
	}

	// MARK: - Display Functions

	/// This updates the display.
	func display(_ data: SelectionData, _ info: SelectionInfo) {

		// Get the formatted string
		guard let selectionFormatted = appDelegate.displayController.formatSelectionAsString(data, info, spaceAtEnd: true) else {
			return hide()
		}

		// Updates the display with the provided selection
		updateDisplay(selectionFormatted)

		// Set the display to be open
		isOpen = true
	}

	/// This hides the display.
	func hide() {

		// Reset the status item length and title
		statusItem.length = NSStatusItem.variableLength
		statusItem.button?.attributedTitle = NSAttributedString(string: "")

		// Set the display to be closed
		isOpen = false
	}

	/// This shows an error message on the display.
	func error() {
		hide()
	}

	// MARK: - Utility Functions

	/// Updates the display.
	private func updateDisplay(_ input: String) {

		// Mutable copy of the information
		var information = input

		// Creates a left justified paragraph style. Makes sure size (102 KB or whatever) stays to the left of the status item
		let paragraphStyle = NSMutableParagraphStyle()

		// Adjust the styles for a blank icon
		if appDelegate.settings.settingMenubarIcon == ContentManager.Icons.menubarBlank {
			paragraphStyle.alignment = .center
		} else {
			paragraphStyle.alignment = .left
			information.append("  ")
		}

		// Put the attributed string all together
		let attrString = NSAttributedString(
			string: information,
			attributes: [.font: font, .baselineOffset: -0.5, .paragraphStyle: paragraphStyle]
		)

		// Find the status item length
		guard let statusItemLength = getStatusItemLength(attrString: attrString) else {
			return hide()
		}

		// Change the status item length before the title is set to avoid layout conflicts
		statusItem.length = statusItemLength

		// Feed the data into the display
		statusItem.button?.attributedTitle = attrString
	}

	/// Gets the status item size so it can be set before the title is changed.
	private func getStatusItemLength(attrString: NSAttributedString) -> CGFloat? {

		// Creates a temporary status item to be used to find the appropriate size
		// - if none is already there
		if statusItemSizing == nil {
			statusItemSizing = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
		}

		// Creates a temporary ref.
		guard let temp = statusItemSizing else {
			return nil
		}

		// Find image position
		guard let imagePosition = statusItem.button?.imagePosition else {
			return nil
		}

		// Find image hugs title
		guard let imageHugs = statusItem.button?.imageHugsTitle else {
			return nil
		}

		temp.isVisible = false
		temp.button?.image = statusItem.button?.image
		temp.button?.imagePosition = imagePosition
		temp.button?.imageHugsTitle = imageHugs
		temp.button?.attributedTitle = attrString
		temp.button?.updateConstraints()

		guard let height = temp.button?.frame.size.height else { return nil }
		guard let width = temp.button?.frame.size.width else { return nil }

		return width - height
	}
}
