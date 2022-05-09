//
//  AccessibilityView.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-21.
//

import SwiftUI

struct AccessibilityView: View {

	let clickIcon = "􀇰 "

	var body: some View {
		RootView {

			// Main stack
			VStack(alignment: .center, spacing: 20) {

				// Header stack
				VStack(spacing: 4) {

					// Image
					Image(ContentManager.Images.appIconNoShadow)
						.resizable()
						.frame(width: 100, height: 100)

					VStack(spacing: 8) {
						// Welcome: Authorize Informant
						Text(ContentManager.Labels.authorizeInformant)
							.H2(weight: .medium)

						// How to authorize
						Text(ContentManager.Labels.authorizeNeedPermission)
							.Body(alignment: .center)
					}
				}

				// Mid stack
				VStack {

					// Top box
					SecurityGuidanceBox(label: "􀍟 " + ContentManager.Labels.authorizedInstructionSystemPreferencesLong, color: .gray)

					// Privacy boxes
					SecurityGuidanceBox(icon: "􀝣", iconSize: 17, label: ContentManager.Labels.authorizedInstructionCheckInformantLong, color: .blue) {
						SettingsController.openSystemPrefsAccessibility()
					}

					SecurityGuidanceBox(icon: "􀣋", label: ContentManager.Labels.authorizedInstructionAutomationCheckFinder, color: .blue) {
						SettingsController.openSystemPrefsAutomation()
					}

					SecurityGuidanceBox(icon: "􀈕", iconSize: 15, label: ContentManager.Labels.authorizedInstructionCheckFullDiskAccess, color: .blue) {
						SettingsController.openSystemPrefsFullDiskAccess()
					}

					// Quit box
					SecurityGuidanceBox(label: clickIcon + ContentManager.Labels.authorizedInstructionRestartInformant, color: .purple, arrow: false) {
						NSApp.terminate(nil)
					}
				}

				// Bottom stack
				VStack(spacing: 12) {

					Text(ContentManager.Labels.authorizedInstructionClickLock)
						.Body(alignment: .center)

					HStack {
						Image(systemName: ContentManager.Icons.authLockIcon)
							.font(.system(size: 13, weight: .semibold))
						Image(systemName: ContentManager.Icons.rightArrowIcon)
							.font(.system(size: 11, weight: .bold))
							.opacity(0.8)
						Image(systemName: ContentManager.Icons.authUnlockIcon)
							.font(.system(size: 13, weight: .semibold))
					}
					.opacity(0.8)
				}
				.opacity(0.45)
			}

			// Main padding
			.padding([.horizontal], 20)
		}
		.frame(width: 335, height: 740, alignment: .center)
	}
}

/// This is the little blue box that shows where the user should navigate to
struct SecurityGuidanceBox: View {

	let icon: String
	let iconSize: CGFloat
	let label: String
	let color: Color
	let arrow: Bool
	let action: (() -> Void)?

	private let radius: CGFloat = 10.0

	internal init(icon: String = "", iconSize: CGFloat = 16, label: String, color: Color, arrow: Bool = true, action: (() -> Void)? = nil) {
		self.icon = icon
		self.iconSize = iconSize
		self.label = label
		self.color = color
		self.arrow = arrow
		self.action = action
	}

	var body: some View {
		VStack {

			// Label
			if action == nil {
				AuthInstructionBlurb(icon, iconSize, label, color, radius)
			} else if let action = action {
				AuthInstructionBlurb(icon, iconSize, label, color, radius, hover: true)
					.onTapGesture {
						action()
					}
			}

			// Arrow
			if arrow {
				Image(systemName: ContentManager.Icons.downArrowIcon)
					.font(.system(size: 12, weight: .bold, design: .rounded))
					.opacity(0.15)
					.padding([.vertical], 2)
			}
		}
	}
}

/// This is the actual text blurb used in the AuthAccessibilityView
struct AuthInstructionBlurb: View {

	let icon: String
	let iconSize: CGFloat
	let label: String
	let color: Color
	let hover: Bool
	let radius: CGFloat

	internal init(_ icon: String, _ iconSize: CGFloat, _ label: String, _ color: Color, _ radius: CGFloat, hover: Bool = false) {
		self.icon = icon
		self.iconSize = iconSize
		self.label = label
		self.color = color
		self.radius = radius
		self.hover = hover
	}

	@State private var isHovering = false

	var body: some View {
		VStack(spacing: 0) {

			if icon != "" {
				Text(icon)
					.font(.system(size: iconSize))
					.padding([.bottom], 3)
			}

			Text(label)
				.font(.system(size: 14))
				.fontWeight(.semibold)
				.lineSpacing(2)
		}
		.multilineTextAlignment(.center)
		.foregroundColor(color)
		.padding([.horizontal], 10)
		.padding([.vertical], 6)
		.background(
			RoundedRectangle(cornerRadius: radius)
				.fill(color)
				.opacity(isHovering ? 0.25 : 0.1)
		)
		.overlay(
			RoundedRectangle(cornerRadius: radius)
				.stroke(color, lineWidth: 1)
				.opacity(0.2)
		)
		.fixedSize(horizontal: false, vertical: true)
		.onHover(perform: { hovering in
			if hover {
				isHovering = hovering
			}
		})

		.animation(.easeInOut, value: isHovering)
	}
}
