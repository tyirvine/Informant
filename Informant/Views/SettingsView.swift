//
//  SettingsView.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-21.
//

import LaunchAtLogin
import SwiftUI

struct SettingsView: View {
	@ObservedObject var settingsController: SettingsController

	init() {
		self.settingsController = AppDelegate.current().settingsController
	}

	var body: some View {
		// Main view group
		RootView {
			HStack {
				Spacer()

				// Left side
				SettingsLeftView()

				Spacer()

				// Right side
				SettingsRightView(settingsController: settingsController)
			}
			.padding([.trailing], 20)
			.padding([.vertical], 20)
		}
		.frame(width: 715, height: 425)
	}
}

struct SettingsLeftView: View {
	var version: String?

	init() {
		if let version = AppDelegate.version() {
			self.version = version
		}
	}

	var body: some View {
		Group {
			// Main stack
			VStack(spacing: 15) {
				// Top stack
				VStack(spacing: 0) {
					Image(ContentManager.Images.appIconNoShadow)
						.resizable()
						.frame(width: 135, height: 135)

					Text("Informant")
						.H2(weight: .medium)

					Spacer()
						.frame(height: 1)

					if let version = version {
						Text("\(ContentManager.Labels.panelVersion) \(version)")
							.opacity(0.5)
							.padding([.top], 2)
					}
				}

				// Bottom stack
				VStack(alignment: .leading) {
					// Feedback
					ComponentsPanelLabelButton {
						LinkHelper.openLink(link: .linkFeedback)
					} content: {
						ComponentsWindowLargeLink(label: ContentManager.Labels.feedback, icon: "megaphone")
					}

					// License
					ComponentsPanelLabelButton {
						LinkHelper.openLink(link: .linkDonate)
					} content: {
						ComponentsWindowLargeLink(label: ContentManager.Labels.donate, icon: "arrow.up.heart", iconSize: 20)
					}

					// About
					ComponentsPanelLabelButton {
						AppDelegate.current().interfaceController.openAboutWindow()
					} content: {
						ComponentsWindowLargeLink(label: ContentManager.Labels.about, icon: "menucard", iconSize: 19)
					}

					// Help
					ComponentsPanelLabelButton {
						LinkHelper.openLink(link: .linkHelp)
					} content: {
						ComponentsWindowLargeLink(label: ContentManager.Labels.help, icon: "bubble.left.and.exclamationmark.bubble.right")
					}
				}
			}
		}
	}
}

struct SettingsRightView: View {
	@ObservedObject var settingsController: SettingsController

	let cornerRadius: CGFloat = 10

	var body: some View {
		ScrollView(.vertical, showsIndicators: true) {
			SettingsItems(settingsController: settingsController)
				.padding([.horizontal], 36)
				.padding([.vertical], 22)
		}

		// Clips the content to fit in the scroll view
		.clipped()

		// Makes sure to clip the scroll indicator
		.cornerRadius(cornerRadius)

		// The padding below offsets the stroke so aligned outside the view, not in the centre
		.background(
			RoundedRectangle(cornerRadius: cornerRadius)
				.fill(Color(Style.Color.backing))
				.opacity(0.3)
		)

		.padding([.all], 0.5)

		.overlay(
			RoundedRectangle(cornerRadius: cornerRadius)
				.stroke(Color.gray)
				.opacity(0.4)
		)
	}
}

struct SettingsItems: View {
	@ObservedObject var settingsController: SettingsController

	var body: some View {
		// Panel and system preferences
		VStack(alignment: .leading, spacing: 0) {
			// MARK: Display

			// For determining fixed size
			Group {
				// Menu label
				Text(ContentManager.Labels.details)
					.H3(weight: .semibold)
					.padding([.bottom], 8)

				// Display details in
				Picker(ContentManager.Labels.displayDetailsIn, selection: $settingsController.settings.settingChosenDisplay) {
					Text(ContentManager.Labels.displayMenubar)
						.tag(DisplayController.Displays.StatusDisplay)

					Text(ContentManager.Labels.displayFloat)
						.tag(DisplayController.Displays.FloatDisplay)
				}
				.pickerStyle(SegmentedPickerStyle())
				.frame(width: 250)

				// Picker spacer
				Spacer()
					.frame(height: 13)

				// Menu bar icon
				Picker(ContentManager.Labels.menubarIconDesc, selection: $settingsController.settings.settingMenubarIcon) {
					Text(ContentManager.Icons.noIcon)
						.tag(ContentManager.Icons.menubarBlank)

					Image(ContentManager.Icons.menubarDefault + "-picker")
						.tag(ContentManager.Icons.menubarDefault)

					Image(ContentManager.Icons.menubarDark + "-picker")
						.tag(ContentManager.Icons.menubarDark)

					Image(ContentManager.Icons.menubarSquare + "-picker")
						.tag(ContentManager.Icons.menubarSquare)
				}
				.pickerStyle(MenuPickerStyle())
				.frame(width: 130)

				// Picker spacer
				Spacer()
					.frame(height: 16)

				VStack(alignment: .leading, spacing: 21) {
					// MARK: - General

					ComponentsSettingsToggleSection(ContentManager.Labels.menubarSectionsGeneral) {
						TogglePadded(ContentManager.Labels.menubarShowSize, isOn: $settingsController.settings.settingShowSize)

						TogglePadded(ContentManager.Labels.menubarShowKind, isOn: $settingsController.settings.settingShowKind)

					} secondColumn: {
						TogglePadded(ContentManager.Labels.menubarShowName, isOn: $settingsController.settings.settingShowName)

						TogglePadded(ContentManager.Labels.menubarShowPath, isOn: $settingsController.settings.settingShowPath)

					} thirdColumn: {
						TogglePadded(ContentManager.Labels.menubarShowCreated, isOn: $settingsController.settings.settingShowCreated)

						TogglePadded(ContentManager.Labels.menubarShowEdited, isOn: $settingsController.settings.settingShowModified)

					} fourthColumn: {
						TogglePadded(ContentManager.Labels.menubarShowVersion, isOn: $settingsController.settings.settingShowVersion)

						TogglePadded(ContentManager.Labels.menubarShowItems, isOn: $settingsController.settings.settingShowItems)
					}

					// MARK: - Images

					ComponentsSettingsToggleSection(ContentManager.Labels.menubarSectionsImages) {
						TogglePadded(ContentManager.Labels.menubarShowAperture, isOn: $settingsController.settings.settingShowAperture)

						TogglePadded(ContentManager.Labels.menubarShowCamera, isOn: $settingsController.settings.settingShowCamera)

					} secondColumn: {
						TogglePadded(ContentManager.Labels.menubarShowShutterspeed, isOn: $settingsController.settings.settingShowShutterSpeed)

						TogglePadded(ContentManager.Labels.menubarShowFocalLength, isOn: $settingsController.settings.settingShowFocalLength)

					} thirdColumn: {
						TogglePadded(ContentManager.Labels.menubarShowColorGamut, isOn: $settingsController.settings.settingShowColorGamut)

						TogglePadded(ContentManager.Labels.menubarShowISO, isOn: $settingsController.settings.settingShowISO)

					} fourthColumn: {}

					// MARK: - Media

					ComponentsSettingsToggleSection(ContentManager.Labels.menubarSectionsMedia) {
						TogglePadded(ContentManager.Labels.menubarShowDimensions, isOn: $settingsController.settings.settingShowDimensions)

						TogglePadded(ContentManager.Labels.menubarShowDuration, isOn: $settingsController.settings.settingShowDuration)

					} secondColumn: {
						TogglePadded(ContentManager.Labels.menubarShowSampleRate, isOn: $settingsController.settings.settingShowSampleRate)

						TogglePadded(ContentManager.Labels.menubarShowColorProfile, isOn: $settingsController.settings.settingShowColorProfile)

					} thirdColumn: {
						TogglePadded(ContentManager.Labels.menubarShowCodecs, isOn: $settingsController.settings.settingShowCodecs)

						TogglePadded(ContentManager.Labels.menubarShowBitrate, isOn: $settingsController.settings.settingShowTotalBitrate)

					} fourthColumn: {}

					// MARK: - Volume

					ComponentsSettingsToggleSection(ContentManager.Labels.menubarSectionsVolume) {
						TogglePadded(ContentManager.Labels.menubarShowVolumeTotal, isOn: $settingsController.settings.settingShowVolumeTotal)

					} secondColumn: {
						TogglePadded(ContentManager.Labels.menubarShowVolumeAvailable, isOn: $settingsController.settings.settingShowVolumeAvailable)

					} thirdColumn: {
						TogglePadded(ContentManager.Labels.menubarShowVolumePurgeable, isOn: $settingsController.settings.settingShowVolumePurgeable)

					} fourthColumn: {}

					// MARK: - Extra

					ComponentsSettingsToggleSection(ContentManager.Labels.menubarShowExtra) {
						TogglePadded(ContentManager.Labels.menubarShowiCloudContainer, isOn: $settingsController.settings.settingShowiCloudContainerName)

					} secondColumn: {} thirdColumn: {} fourthColumn: {}
				}
			}
			.fixedSize()

			// Space sections
			Spacer()
				.frame(height: 20)

			// MARK: System

			// For determining fixed size
			Group {
				// System label
				Text(ContentManager.Labels.system)
					.H3(weight: .semibold)
					.padding([.bottom], 8)

				VStack(alignment: .leading, spacing: 12) {
					// Hide when using apps besides Finder
					TogglePadded(ContentManager.Labels.hideWhenUsingOtherApps, isOn: $settingsController.settings.settingHideWhenViewingOtherApps)

					// Skips the sizing of directories all together
					TogglePadded(ContentManager.Labels.skipDirectories, isOn: $settingsController.settings.settingSkipGettingSizeForDirectories)

					// Launch informant on system startup
					LaunchAtLogin.Toggle {
						Text(ContentManager.Labels.launchOnStartup).togglePadding()
					}

					// Reset all settings button
					Button {
						AppDelegate.current().settingsController.resetDefaults()
					} label: {
						Text(ContentManager.Labels.settingsResetButton)
					}
					.padding([.top], 2)

					// Separates system from update settings
					Divider()
						.padding([.vertical], 8)

					// Check for updates button
					Button {
						AppDelegate.current().updateController.checkForUpdates()
					} label: {
						Text(ContentManager.Labels.checkForUpdates)
					}
					.padding([.bottom], 4)

					// Update frequency
					Picker(ContentManager.Labels.updateFrequency, selection: $settingsController.settings.settingUpdateFrequency) {
						Text(ContentManager.Labels.updateAutoUpdate)
							.padding([.bottom], 4)
							.tag(UpdateFrequency.AutoUpdate)

						Text(ContentManager.Labels.updateDontDoAnything)
							.padding([.bottom], 4)
							.tag(UpdateFrequency.None)
					}
					.pickerStyle(RadioGroupPickerStyle())
					.frame(width: 350, alignment: .leading)
				}
			}
			.fixedSize()
		}
	}
}
