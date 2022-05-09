//
//  Components.swift
//  Informant
//
//  Created by Ty Irvine on 2022-03-02.
//

import Foundation
import SwiftUI

/// This is just a toggle with some padding between the toggle and title.
struct TogglePadded: View {

	let title: String
	var binding: Binding<Bool>

	internal init(_ title: String, isOn: Binding<Bool>) {
		self.title = title
		self.binding = isOn
	}

	var body: some View {
		Toggle(isOn: binding) {
			Text(title).togglePadding()
		}
	}
}

/// This is a root view that provides the view with a frame size and material.
struct RootView<Content: View>: View {

	let content: Content
	let material: NSVisualEffectView.Material

	internal init(material: NSVisualEffectView.Material = .sidebar, @ViewBuilder content: @escaping () -> Content) {
		self.content = content()
		self.material = material
	}

	var body: some View {
		HStack {
			Spacer(minLength: 0)
			VStack {
				Spacer(minLength: 0)
				content
				Spacer(minLength: 0)
			}
			Spacer(minLength: 0)
		}
		.background(VisualEffectView(material: material))
		.edgesIgnoringSafeArea(.top)
	}
}

/// Arranges columns horizontally.
struct ComponentsSettingsToggleSection<ContentFirst: View, ContentSecond: View, ContentThird: View, ContentFourth: View>: View {

	let firstColumn: ContentFirst
	let secondColumn: ContentSecond
	let thirdColumn: ContentThird
	let fourthColumn: ContentFourth
	let label: String

	internal init(
		_ label: String,
		@ViewBuilder firstColumn: @escaping () -> ContentFirst,
		@ViewBuilder secondColumn: @escaping () -> ContentSecond,
		@ViewBuilder thirdColumn: @escaping () -> ContentThird,
		@ViewBuilder fourthColumn: @escaping () -> ContentFourth
	) {
		self.firstColumn = firstColumn()
		self.secondColumn = secondColumn()
		self.thirdColumn = thirdColumn()
		self.fourthColumn = fourthColumn()
		self.label = label
	}

	var body: some View {

		VStack(alignment: .leading, spacing: 8) {

			Text(label)
				.H4(weight: .medium)

			HStack(alignment: .top, spacing: 17) {

				VStack(alignment: .leading) {
					firstColumn
				}

				VStack(alignment: .leading) {
					secondColumn
				}

				VStack(alignment: .leading) {
					thirdColumn
				}

				VStack(alignment: .leading) {
					fourthColumn
				}
			}
		}
	}
}

/// Settings window button
struct ComponentsWindowLargeLink: View {

	let label: String
	let icon: String
	let iconSize: CGFloat
	let color: Color
	let usesSFSymbols: Bool

	internal init(label: String, icon: String, iconSize: CGFloat = 18, color: Color = .blue, usesSFSymbols: Bool = true) {
		self.label = label
		self.icon = icon
		self.iconSize = iconSize
		self.color = color
		self.usesSFSymbols = usesSFSymbols
	}

	var body: some View {
		HStack(alignment: .center) {

			if usesSFSymbols {
				Image(systemName: icon)
					.font(.system(size: iconSize, weight: .semibold))
					.frame(width: 24, height: 20)
			} else {
				Image(icon)
					.resizable()
					.frame(width: 24, height: 24)
			}

			Text(label).H3X(weight: .medium)
		}
		.foregroundColor(color)
	}
}

/// Shows a label on hover behind the content. When clicked an action is performed. Typically this is used with text objects.
struct ComponentsPanelLabelButton<Content: View>: View {

	let content: Content
	var action: () -> Void

	internal init(action: @escaping () -> Void, @ViewBuilder content: @escaping () -> Content) {
		self.content = content()
		self.action = action
	}

	@State private var isHovering = false

	var body: some View {
		Button {
			action()
		} label: {
			ZStack(alignment: .leading) {

				// Backing
				Color.blue
					.cornerRadius(8.0)
					.opacity(isHovering ? 0.1 : 0)
					.animation(.easeInOut(duration: Style.Animation.standard))

				// Label
				content
					.padding([.horizontal], 8)
					.padding([.vertical], 6)
			}
		}
		.fixedSize()
		.buttonStyle(PlainButtonStyle())
		.onHover { hovering in
			isHovering = hovering
		}
	}
}
