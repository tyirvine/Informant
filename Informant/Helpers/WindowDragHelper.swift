//
//  WindowDragHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2022-04-13.
//
//  This solution was found on StackOverflow.
//  https://stackoverflow.com/a/70279092/13142325

import Foundation
import SwiftUI

// This modifier basically passes the the mouseDown event and then a drag
// is initiated using that event with a newly created NSView.
extension View {
	func dragWindowWithClick() -> some View {
		self.overlay(DragWindowView())
	}
}

struct DragWindowView: NSViewRepresentable {
	func makeNSView(context: Context) -> NSView {
		return DragWindowNSView()
	}

	func updateNSView(_ nsView: NSView, context: Context) { }
}

class DragWindowNSView: NSView {
	override public func mouseDown(with event: NSEvent) {
		NSApp?.mainWindow?.performDrag(with: event)
	}
}
