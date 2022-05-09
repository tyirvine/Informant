//
//  Controlelr.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-21.
//

import Foundation

/// This is the base class that all controllers adhere to.
class Controller {

	let appDelegate: AppDelegate

	required init(appDelegate: AppDelegate) {

		// Gather refs
		self.appDelegate = appDelegate
	}
}

/// This is the protocol that all controllers adhere to.
protocol ControllerProtocol: Controller {
	var appDelegate: AppDelegate { get }
	init(appDelegate: AppDelegate)
}
