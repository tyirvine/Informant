//
//  AlertController.swift
//  Informant
//
//  Created by Ty Irvine on 2022-03-05.
//

import AppKit
import Foundation

class AlertController: Controller, ControllerProtocol {

	required init(appDelegate: AppDelegate) {
		super.init(appDelegate: appDelegate)
	}

	/// Runs a simple confirmation alert.
	static func alertOK(title: String, message: String) {
		let alert = NSAlert()
		alert.alertStyle = .informational
		alert.messageText = title
		alert.informativeText = message
		alert.addButton(withTitle: ContentManager.Labels.alertOK)
		alert.runModal()
	}

	/// Runs a simple warning cancel/confirm alert. Confirm is the first button. Cancel is the second.
	static func alertWarning(title: String, message: String) -> NSApplication.ModalResponse {
		let alert = NSAlert()
		alert.alertStyle = .critical
		alert.messageText = title
		alert.informativeText = message
		alert.addButton(withTitle: ContentManager.Labels.alertConfirmation)
		alert.addButton(withTitle: ContentManager.Labels.alertCancel)
		return alert.runModal()
	}
}
