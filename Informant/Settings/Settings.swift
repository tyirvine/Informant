//
//  SettingsController.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-21.
//

import Foundation
import SwiftUI

// A place to store all keys used for settings.
extension String {
	
	// MARK: - Stateful Settings
	
	static let keyPauseApp = "pauseApp"
	
	static let keyShowWelcomeWindow = "welcomeWindowShow"
	
	static let keySavedSnapPoint = "savedSnapPoint"

	// MARK: - Menu Bar Settings
	
	// General
	static let keyShowName = "menubarShowName"
	
	static let keyShowSize = "menubarShowSize"
	
	static let keyShowPath = "menubarShowPath"

	static let keyShowiCloudContainerName = "menubarShowiCloudContainerName"
	
	static let keyShowKind = "menubarShowKind"
	
	static let keyShowCreated = "menubarShowCreated"
	
	static let keyShowModified = "menubarShowModified"
	
	// Media
	static let keyShowDuration = "menubarShowDuration"
	
	static let keyShowDimensions = "menubarShowDimensions"
	
	static let keyShowCodecs = "menubarShowCodecs"
	
	static let keyShowColorProfile = "menubarShowColorProfile"
	
	static let keyShowColorGamut = "menubarShowColorGamut"
	
	static let keyShowTotalBitrate = "menubarShowTotalBitrate"
	
	static let keyShowVideoBitrate = "menubarShowVideoBitrate"
	
	// Directory
	static let keyShowItems = "menubarShowItems"
	
	// Application
	static let keyShowVersion = "menubarShowVersion"
	
	// Audio
	static let keyShowSampleRate = "menubarShowSampleRate"
	
	static let keyShowAudioBitrate = "menubarShowAudioBitrate"
	
	// Volume
	static let keyShowVolumeTotal = "menubarShowVolumeTotal"
	
	static let keyShowVolumeAvailable = "menubarShowAvailable"
	
	static let keyShowVolumePurgeable = "menubarShowVolumePurgeable"
	
	// Images
	static let keyShowAperture = "menubarShowAperture"
	
	static let keyShowISO = "menubarShowISO"
	
	static let keyShowFocalLength = "menubarShowFocalLength"
	
	static let keyShowCamera = "menubarShowCamera"
	
	static let keyShowShutterSpeed = "menubarShowShutterSpeed"
	
	// Multi selection
	static let keyShowTotalCount = "menubarShowTotalCount"

	static let keyShowTotalSize = "menubarShowTotalSize"

	// MARK: - System Settings
	
	static let keyMenubarIcon = "menubarIcon"
	
	static let keySkipGettingSizeForDirectories = "skipGettingSizeForDirectories"
	
	static let keyChosenDisplay = "chosenDisplay"
	
	static let keyHideWhenViewingOtherApps = "hideWhenViewingOtherApps"
	
	static let keyUpdateFrequency = "updateFrequency"
	
	// MARK: - Extra keys
	
	static let keyMainData = "menubarMainData"
}

/// Controls all settings throughout the app and makes sure to send an update when a setting is changed.
/// On init, all user defaults are registered.
///
/// IMPORTANT:
/// Making a change to settings requires changes in three spots.
/// 1. You must make a key that represents the setting.
/// 2. Create a published property representing that key. (optional, if it won't have direct controls)
/// 3. Set the default for the key in user defaults.
class Settings: Controller, ControllerProtocol, ObservableObject {
	
	// MARK: State Fields
	/// Lets us know the state of accessibility permission.
	@Published var statePrivacyAccessibilityEnabled: Bool

	// MARK: Settings Fields
	// ------------ ⚡️ Stateful settings ------------
	@Published var settingShowWelcomeWindow: Bool = Settings.fieldInit(type: .Bool, key: .keyShowWelcomeWindow) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowWelcomeWindow) }
		didSet(value) { fieldDidSet(key: .keyShowWelcomeWindow) }
	}
		
	@Published var settingPauseApp: Bool = Settings.fieldInit(type: .Bool, key: .keyPauseApp) {
		willSet(value) { fieldWillSet(value: value, key: .keyPauseApp) }
		didSet(value) { fieldDidSet(key: .keyPauseApp) }
	}
	
	// ------------ ⚙️ System settings ------------
	@Published var settingMenubarIcon: String = Settings.fieldInit(type: .String, key: .keyMenubarIcon) {
		willSet(value) { fieldWillSet(value: value, key: .keyMenubarIcon) }
		didSet(value) { fieldDidSet(key: .keyMenubarIcon) }
	}
	
	@Published var settingSkipGettingSizeForDirectories: Bool = Settings.fieldInit(type: .Bool, key: .keySkipGettingSizeForDirectories) {
		willSet(value) { fieldWillSet(value: value, key: .keySkipGettingSizeForDirectories) }
		didSet(value) { fieldDidSet(key: .keySkipGettingSizeForDirectories) }
	}
	
	@Published var settingChosenDisplay: DisplayController.Displays = Settings.fieldInit(type: .Display, key: .keyChosenDisplay) {
		willSet(value) { fieldWillSet(value: value.rawValue, key: .keyChosenDisplay) }
		didSet(value) { fieldDidSet(key: .keyChosenDisplay) }
	}
	
	@Published var settingHideWhenViewingOtherApps: Bool = Settings.fieldInit(type: .Bool, key: .keyHideWhenViewingOtherApps) {
		willSet(value) { fieldWillSet(value: value, key: .keyHideWhenViewingOtherApps) }
		didSet(value) { fieldDidSet(key: .keyHideWhenViewingOtherApps) }
	}
	
	@Published var settingUpdateFrequency: UpdateFrequency = Settings.fieldInit(type: .UpdateFrequency, key: .keyUpdateFrequency) {
		willSet(value) { fieldWillSet(value: value.rawValue, key: .keyUpdateFrequency) }
		didSet(value) { fieldDidSet(key: .keyUpdateFrequency) }
	}

	// ------------ Display settings ------------
	
	// Single Selection ☝️
	@Published var settingShowSize: Bool = Settings.fieldInit(type: .Bool, key: .keyShowSize) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowSize) }
		didSet(value) { fieldDidSet(key: .keyShowSize) }
	}
	
	@Published var settingShowName: Bool = Settings.fieldInit(type: .Bool, key: .keyShowName) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowName) }
		didSet(value) { fieldDidSet(key: .keyShowName) }
	}

	@Published var settingShowPath: Bool = Settings.fieldInit(type: .Bool, key: .keyShowPath) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowPath) }
		didSet(value) { fieldDidSet(key: .keyShowPath) }
	}
	
	@Published var settingShowiCloudContainerName: Bool = Settings.fieldInit(type: .Bool, key: .keyShowiCloudContainerName) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowiCloudContainerName) }
		didSet(value) { fieldDidSet(key: .keyShowiCloudContainerName) }
	}

	@Published var settingShowKind: Bool = Settings.fieldInit(type: .Bool, key: .keyShowKind) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowKind) }
		didSet(value) { fieldDidSet(key: .keyShowKind) }
	}
		
	@Published var settingShowCreated: Bool = Settings.fieldInit(type: .Bool, key: .keyShowCreated) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowCreated) }
		didSet(value) { fieldDidSet(key: .keyShowCreated) }
	}
		
	@Published var settingShowModified: Bool = Settings.fieldInit(type: .Bool, key: .keyShowModified) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowModified) }
		didSet(value) { fieldDidSet(key: .keyShowModified) }
	}
		
	// Image 📷
	@Published var settingShowCamera: Bool = Settings.fieldInit(type: .Bool, key: .keyShowCamera) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowCamera) }
		didSet(value) { fieldDidSet(key: .keyShowCamera) }
	}
	
	@Published var settingShowFocalLength: Bool = Settings.fieldInit(type: .Bool, key: .keyShowFocalLength) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowFocalLength) }
		didSet(value) { fieldDidSet(key: .keyShowFocalLength) }
	}

	@Published var settingShowAperture: Bool = Settings.fieldInit(type: .Bool, key: .keyShowAperture) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowAperture) }
		didSet(value) { fieldDidSet(key: .keyShowAperture) }
	}
	
	@Published var settingShowShutterSpeed: Bool = Settings.fieldInit(type: .Bool, key: .keyShowShutterSpeed) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowShutterSpeed) }
		didSet(value) { fieldDidSet(key: .keyShowShutterSpeed) }
	}

	@Published var settingShowISO: Bool = Settings.fieldInit(type: .Bool, key: .keyShowISO) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowISO) }
		didSet(value) { fieldDidSet(key: .keyShowISO) }
	}
		
	// Movie 📽
	@Published var settingShowCodecs: Bool = Settings.fieldInit(type: .Bool, key: .keyShowCodecs) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowCodecs) }
		didSet(value) { fieldDidSet(key: .keyShowCodecs) }
	}
	
	// Audio 🎙
	@Published var settingShowSampleRate: Bool = Settings.fieldInit(type: .Bool, key: .keyShowSampleRate) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowSampleRate) }
		didSet(value) { fieldDidSet(key: .keyShowSampleRate) }
	}
	
	// Media 📹
	@Published var settingShowDimensions: Bool = Settings.fieldInit(type: .Bool, key: .keyShowDimensions) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowDimensions) }
		didSet(value) { fieldDidSet(key: .keyShowDimensions) }
	}

	@Published var settingShowColorProfile: Bool = Settings.fieldInit(type: .Bool, key: .keyShowColorProfile) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowColorProfile) }
		didSet(value) { fieldDidSet(key: .keyShowColorProfile) }
	}
	
	@Published var settingShowColorGamut: Bool = Settings.fieldInit(type: .Bool, key: .keyShowColorGamut) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowColorGamut) }
		didSet(value) { fieldDidSet(key: .keyShowColorGamut) }
	}
	
	@Published var settingShowDuration: Bool = Settings.fieldInit(type: .Bool, key: .keyShowDuration) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowDuration) }
		didSet(value) { fieldDidSet(key: .keyShowDuration) }
	}

	// Bitrates 010001010101010100100001010
	@Published var settingShowTotalBitrate: Bool = Settings.fieldInit(type: .Bool, key: .keyShowTotalBitrate) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowTotalBitrate) }
		didSet(value) { fieldDidSet(key: .keyShowTotalBitrate) }
	}
	
	@Published var settingShowVideoBitrate: Bool = Settings.fieldInit(type: .Bool, key: .keyShowVideoBitrate) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowVideoBitrate) }
		didSet(value) { fieldDidSet(key: .keyShowVideoBitrate) }
	}
	
	@Published var settingShowAudioBitrate: Bool = Settings.fieldInit(type: .Bool, key: .keyShowAudioBitrate) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowAudioBitrate) }
		didSet(value) { fieldDidSet(key: .keyShowAudioBitrate) }
	}

	// Directory 📁
	@Published var settingShowItems: Bool = Settings.fieldInit(type: .Bool, key: .keyShowItems) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowItems) }
		didSet(value) { fieldDidSet(key: .keyShowItems) }
	}

	// Application 🪀
	@Published var settingShowVersion: Bool = Settings.fieldInit(type: .Bool, key: .keyShowVersion) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowVersion) }
		didSet(value) { fieldDidSet(key: .keyShowVersion) }
	}
		
	// Volume 💾
	@Published var settingShowVolumeTotal: Bool = Settings.fieldInit(type: .Bool, key: .keyShowVolumeTotal) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowVolumeTotal) }
		didSet(value) { fieldDidSet(key: .keyShowVolumeTotal) }
	}
		
	@Published var settingShowVolumeAvailable: Bool = Settings.fieldInit(type: .Bool, key: .keyShowVolumeAvailable) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowVolumeAvailable) }
		didSet(value) { fieldDidSet(key: .keyShowVolumeAvailable) }
	}
		
	@Published var settingShowVolumePurgeable: Bool = Settings.fieldInit(type: .Bool, key: .keyShowVolumePurgeable) {
		willSet(value) { fieldWillSet(value: value, key: .keyShowVolumePurgeable) }
		didSet(value) { fieldDidSet(key: .keyShowVolumePurgeable) }
	}
		
	/// Used to initialize properties.
	private enum PropertyType {
		case String
		case Bool
		case Display
		case UpdateFrequency
		case FramePosition
	}
	
	/// All state defaults.
	private static let defaultStatesOrdered: KeyValuePairs<String, Any> = [
		.keyShowWelcomeWindow: true,
		.keyPauseApp: false,
		.keySavedSnapPoint: FramePosition.TopRight.rawValue,
	]
	
	/// All user defaults.
	static let defaultSettingsOrdered: KeyValuePairs<String, Any> = [
		
		// System
		.keyMenubarIcon: ContentManager.Icons.menubarDefault,
		.keySkipGettingSizeForDirectories: false,
		.keyHideWhenViewingOtherApps: false,
		.keyUpdateFrequency: UpdateFrequency.AutoUpdate.rawValue,
		
		// Menubar
		.keyShowiCloudContainerName: false,
		.keyShowName: false,
		.keyShowKind: false,
		.keyShowCreated: false,
		.keyShowModified: false,
		
		.keyShowCodecs: false,
		.keyShowColorProfile: false,
		.keyShowColorGamut: false,
		.keyShowTotalBitrate: false,
		.keyShowVideoBitrate: false,
		
		.keyShowVersion: false,
		
		.keyShowSampleRate: false,
		.keyShowAudioBitrate: false,
		
		.keyShowVolumeTotal: false,
		.keyShowVolumeAvailable: false,
		.keyShowVolumePurgeable: false,
		
		.keyShowAperture: false,
		.keyShowISO: false,
		.keyShowFocalLength: false,
		.keyShowCamera: false,
		.keyShowShutterSpeed: false,
		
		.keyShowPath: false,
		
		// Important ordered
		.keyShowItems: false,
		.keyShowDuration: false,
		.keyShowDimensions: false,
		.keyShowSize: true,
	]
	
	/// Converts the ordered key value pair lists into a standard dictionary.
	static let defaultSettings = [String: Any](Array(defaultSettingsOrdered), uniquingKeysWith: { first, _ in first })
	private static let defaultStates = [String: Any](Array(defaultStatesOrdered), uniquingKeysWith: { first, _ in first })

	//  ------------------- Initialize ----------------------
	
	required init(appDelegate: AppDelegate) {

		// Initialize state fields
		self.statePrivacyAccessibilityEnabled = AXIsProcessTrusted()
		
		super.init(appDelegate: appDelegate)
	}
	
	// MARK: - Settings General Functions
	
	/// Takes in the new value and sets it in user defaults.
	private func fieldWillSet(value: Any, key: String) {
		UserDefaults.standard.setValue(value, forKey: key)
	}
	
	/// Interacts with the app and makes changes neccessary based on the settings changed.
	/// This gets called by a notifier so you can be sure this fn. will run whenever an update
	/// to a user default gets changed.
	private func fieldDidSet(key: String) {
		
		// These are settings that require explicit changes to the app
		switch key {
				
			case .keyMenubarIcon:
				appDelegate.interfaceController.updateIcon()
				return
				
			case .keyPauseApp:
				appDelegate.interfaceController.updatePause()
				return
				
			default:
				break
		}
		
		// Otherwise update the interfaces
		appDelegate.interfaceController.updateAllInterfaces(reset: true)
	}
	
	/// Used to initialize each property
	private static func fieldInit<T>(type: PropertyType, key: String) -> T {
		switch type {
			case .String:
				return UserDefaults.standard.string(forKey: key) as! T
				
			case .Bool:
				return UserDefaults.standard.bool(forKey: key) as! T
				
			case .Display:
				return DisplayController.Displays(rawValue: UserDefaults.standard.string(forKey: key) ?? DisplayController.Displays.StatusDisplay.rawValue) as! T
				
			case .UpdateFrequency:
				return UpdateFrequency(rawValue: UserDefaults.standard.string(forKey: key) ?? UpdateFrequency.None.rawValue) as! T
				
			case .FramePosition:
				return FramePosition(rawValue: UserDefaults.standard.string(forKey: key) ?? FramePosition.TopRight.rawValue) as! T
		}
	}
	
	// MARK: - Settings Utility Functions
	
	/// Registers the defaults. This should only be called once.
	static func registerDefaults() {
		
		// Register state defaults
		UserDefaults.standard.register(defaults: Self.defaultStates)
		
		// Register settings defaults
		UserDefaults.standard.register(defaults: Self.defaultSettings)
	}
	
	/// Applies all settings to the selection object.
	func applySettings(_ selection: SelectionData) -> SelectionData? {
	
		// Grabs mutable copy of the selection
		var selected = selection

		// Pull all settings in from user defaults
		let allSettings = UserDefaults.standard.dictionaryRepresentation()
		
		// Iterate through and apply settings to the selection object
		for (key, value) in allSettings {
			
			// Nils out properties that are turned off in settings
			if let value = value as? Bool, value == false {
				selected.data[key] = nil
			}
		}
		
		return selected
	}
}
