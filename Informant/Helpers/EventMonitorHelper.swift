//
//  EventLogic.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-13.
//

import Cocoa
import Foundation

// This class listens for any requested actions and can be used to execute logic.
// So say I wanted to know when the user left clicks, this is the class to use.
// Ensure this gets start/stopped very little. Each monitor uses a good amount of resources
class EventMonitorHelper {

	private var monitor: Any?
	private let mask: NSEvent.EventTypeMask
	private let handler: (NSEvent) -> Void

	public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> Void) {
		self.mask = mask
		self.handler = handler
	}

	deinit {
		stop()
	}

	// Starts monitoring
	public func start() {
		if monitor == nil {
			monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as! NSObject
		}
	}

	// Stops monitoring
	public func stop() {
		if monitor != nil {
			NSEvent.removeMonitor(monitor!)
			monitor = nil
		}
	}
}
