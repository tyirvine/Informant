//
//  FloatDisplayField.swift
//  Informant
//
//  Created by Ty Irvine on 2022-04-12.
//

import SwiftUI

struct FloatDisplayFieldCopyView: View {

	let field: SelectionField
	let text: String

	init(_ field: SelectionField, hover: Bool) {
		self.field = field
		self.text = field.value ?? ""

		// Only reset the hover state if it's false
		if hover == false {
			self.isHovering = hover
		}
	}

	// Controls hover state of the blue highlight
	@State var isHovering: Bool = false

	// Controls the state of the copied message
	@State var wasCopied: Bool = false

	/// Copies the text to the clipboard.
	func copy() {

		// TODO: See if you can come up with a better solution for this
		// Reset hovering state
		isHovering = false

		// Block additional copy attempts
		if wasCopied == false {

			// Record the state and copy the fragment
			wasCopied = true

			let pasteboard = NSPasteboard.general
			pasteboard.declareTypes([.string], owner: nil)

			// Determine if formatting needs to be done before copying
			switch field.type {

				case .URL:
					let text = text.formatSpecialCharacters()
					pasteboard.setString(text, forType: .string)
					break

				default:
					pasteboard.setString(text, forType: .string)
					break
			}

			// Reset the state
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
				wasCopied = false
			}
		}
	}

	// MARK: View ⤵︎

	var body: some View {
		ZStack {

			// Primary text and highlight group
			Group {
				// Primary text
				Text(text)
					.fontWeight(.medium)
					.opacity(isHovering ? 0 : 1)

				// Blue highlight on hover for copy/paste
				Text(text)
					.fontWeight(.medium)
					.foregroundColor(.blue)
					.opacity(isHovering ? 1 : 0)

					// Runs the copy to clipboard flow
					.inactiveWindowTap(draggable: false) { pressed in
						if pressed == false {
							copy()
						}
					}
			}
			.opacity(wasCopied ? 0 : 1)

			// Copied message
			HStack(alignment: .center, spacing: 3) {

				// If the field is too small then we just don't show the full copied message
				if text.count > 10 {
					Text(ContentManager.Labels.copied)
						.floatDisplayActionFont()
				}

				Text("􀐅")
					.font(.system(size: 13, weight: .heavy))
					.opacity(0.4)
			}
			.opacity(wasCopied ? 1 : 0)
		}

		// Controls hover state
		.whenHovered { hovering in
			isHovering = hovering
		}

		// Animate opacities
		.animation(.easeInOut(duration: 0.18), value: isHovering)
		.animation(.easeInOut(duration: 0.18), value: wasCopied)
	}
}
