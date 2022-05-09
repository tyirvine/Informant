//
//  Display.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-25.
//

import AppKit
import Foundation

/// This is the base class that all displays inherit.
class DisplayClass {

	let appDelegate: AppDelegate

	var isOpen: Bool?

	var isClosed: Bool? {
		if let isOpen = isOpen {
			return !isOpen
		}

		return nil
	}

	/// This is the selection data visible on the display.
	private(set) var selectionData: SelectionData?

	/// This is the selection info visible on the display.
	private(set) var selectionInfo: SelectionInfo?

	/// This is the front facing update method. It allows us to hook in extra functionality.
	func update(_ data: SelectionData, _ info: SelectionInfo) {

		selectionData = data
		selectionInfo = info

		guard let display = self as? Display else {
			return
		}

		display.display(data, info)
	}

	required init(appDelegate: AppDelegate) {
		self.appDelegate = appDelegate
	}
}

/// This is the protocol that all displays adhere to.
protocol DisplayProtocol {

	/// This is a ref. to the app delegate.
	var appDelegate: AppDelegate { get }

	/// This keeps track of the state of the view.
	var isOpen: Bool? { get set }
	var isClosed: Bool? { get }

	// Init
	init(appDelegate: AppDelegate)

	// Functions
	func display(_ data: SelectionData, _ info: SelectionInfo)
	func hide()
	func error()
}

typealias Display = DisplayClass & DisplayProtocol
