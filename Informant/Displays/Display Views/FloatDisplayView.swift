//
//  FloatDisplayView.swift
//  Informant
//
//  Created by Ty Irvine on 2022-04-11.
//

import SwiftUI

struct FloatDisplayView: View {

	let fields: [SelectionField]

	let appDelegate: AppDelegate

	// Keeps track of the view being hovered
	@State var isHovering: Bool = false

	// Keeps track of the click count for a double click.
	@State var mouseUpCount: Int = 0
	@State var mouseDownCount: Int = 0

	/// Handle double tap and close the display.
	func closeDisplay(_ pressed: Bool) {

		// On mouse down
		if pressed {
			mouseDownCount += 1
		}

		// On mouse up
		else {
			mouseUpCount += 1

			// Check to see if this is a valid double click
			// If so, close the displays
			if mouseUpCount >= 2, mouseDownCount >= 2 {
				appDelegate.interfaceController.hideDisplays()
			}

			// Cancel double click
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				mouseDownCount = 0
				mouseUpCount = 0
			}
		}
	}

	var body: some View {
		RootView {
			ZStack(alignment: .trailing) {

				// This is the background selector for detecting clicks and hovers
				Rectangle()
					.fill(.clear)
					.inactiveWindowTap { pressed in
						closeDisplay(pressed)
					}
					.whenHovered { hovering in
						isHovering = hovering
					}

				// Field stack
				HStack(spacing: 0) {
					Spacer(minLength: 18)

					// The actual fields
					ForEach(fields, id: \.id) { field in

						// Show the correct field view depending on the type
						switch field.type {
							case .Text, .URL:
								FloatDisplayFieldCopyView(field, hover: isHovering)

							case .Divider:
								FloatDisplayFieldDividerView()

							case .LoadingIndicator:
								FloatDisplayFieldLoaderView()
						}
					}

					Spacer(minLength: 18)
				}
			}

			// Animates properties
			.animation(.easeIn(duration: 0.14), value: isHovering)
		}

		// Ensures the window displays properly without safety padding from title bar
		.fixedSize(horizontal: true, vertical: false)
		.frame(height: 16)
	}
}
