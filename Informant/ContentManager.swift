//
//  LocalizableTriage.swift
//  Informant
//
//  Created by Ty Irvine on 2021-05-23.
//

import Foundation

/// This class is used to reduce the use of hard-coded strings in the source
class ContentManager {

	// MARK: - Messages
	public enum Messages {

		static let setupAccessibilityNotEnabled = NSLocalizedString("Access Not Enabled", comment: "The message that appears if the user declines accessibility access.")

		static let settingsRootURLDescriptor = NSLocalizedString(
			"Required in-order to display additional metadata and the size of a directory. Choose Macintosh HD.",
			comment: ""
		)
	}

	// MARK: - Labels
	public enum Labels {

		static let use = NSLocalizedString("Use", comment: "")

		static let showDetailsIn = NSLocalizedString("Show details in", comment: "")

		static let options = NSLocalizedString("Options", comment: "")

		static let copied = NSLocalizedString("Copied", comment: "")

		static let close = NSLocalizedString("Close", comment: "")

		static let divider = NSLocalizedString("  •  ", comment: "")

		// Volumes
		static let volumeCapacity = NSLocalizedString("total", comment: "")

		static let volumeAvailable = NSLocalizedString("available", comment: "")

		static let volumePurgeable = NSLocalizedString("purgeable", comment: "")

		// Alerts
		static let alertOK = NSLocalizedString("OK", comment: "")

		static let alertConfirmation = NSLocalizedString("Continue", comment: "")

		static let alertCancel = NSLocalizedString("Cancel", comment: "")

		static let alertWarningTitle = NSLocalizedString("Wait a minute!", comment: "")

		static let alertResetSettingsSuccessTitle = NSLocalizedString("Good to go!", comment: "")

		static let alertResetSettingsMessage = NSLocalizedString("Are you sure you want to do this? This will erase all your settings.", comment: "")

		static let alertResetSettingsMessageFinished = NSLocalizedString("Your settings have been reset to their defaults.", comment: "")

		// Settings
		static let settingsResetButton = NSLocalizedString("Reset settings to default", comment: "")

		// Picker
		static let displayDetailsIn = NSLocalizedString("Display:", comment: "")

		static let menubarIconDesc = NSLocalizedString("Icon:", comment: "")

		static let displayMenubar = NSLocalizedString("Menu Bar", comment: "")

		static let displayFloat = NSLocalizedString("Float Bar", comment: "")

		static let updateFrequency = NSLocalizedString("Updates:", comment: "")

		static let checkForUpdates = NSLocalizedString("Check for updates", comment: "")

		// Updates
		static let updateAutoUpdate = NSLocalizedString("Automatically check for updates", comment: "")

		static let updateJustNotify = NSLocalizedString("Just notify me of updates", comment: "")

		static let updateDontDoAnything = NSLocalizedString("Don't do anything", comment: "")

		// Colors
		static let red = NSLocalizedString("Red", comment: "The colour Red")

		static let orange = NSLocalizedString("Orange", comment: "The colour Orange")

		static let yellow = NSLocalizedString("Yellow", comment: "The colour Yellow")

		static let green = NSLocalizedString("Green", comment: "The colour Green")

		static let blue = NSLocalizedString("Blue", comment: "The colour Blue")

		static let purple = NSLocalizedString("Purple", comment: "The colour Purple")

		static let grey = NSLocalizedString("Grey", comment: "The colour Gray")

		// State
		static let unavailable = NSLocalizedString("Unavailable", comment: "Used when calculating a property but it's not there")

		static let calculating = NSLocalizedString("Calculating...", comment: "Used when calculating a property")

		static let finding = NSLocalizedString("Finding...", comment: "Used when finding a property")

		static let findingItems = NSLocalizedString("Finding items...", comment: "Used when finding a property")

		static let findingSize = NSLocalizedString("Finding size...", comment: "Used when finding a property")

		static let findingNoPeriods = NSLocalizedString("Finding", comment: "")

		static let finished = NSLocalizedString("Finished", comment: "Used when calculating a property has come to end")

		// Authorization labels
		static let authorizeInformant = NSLocalizedString("Allow Informant", comment: "Used on authorization welcome screen")

		static let authorizeNeedPermission = NSLocalizedString("Informant needs your permission to read file metadata.", comment: "Used on the authorize panel, it's the body string")

		// Authorization instruction labels
		static let authorizedInstructionSystemPreferences = NSLocalizedString("Open System Preferences", comment: "Used on auth instructions")

		static let authorizedInstructionSystemPreferencesLong = NSLocalizedString("Open System Preferences, Security & Privacy, then Privacy", comment: "Used on auth instructions")

		static let authorizedInstructionSecurity = NSLocalizedString("Click Security & Privacy", comment: "Used on auth instructions")

		static let authorizedInstructionSecurityLong = NSLocalizedString("Go to Security & Privacy, then Privacy, then scroll down and select Accessibility", comment: "Used on auth instructions")

		static let authorizedInstructionPrivacy = NSLocalizedString("Click Privacy", comment: "Used on auth instructions")

		static let authorizedInstructionScrollAndClick = NSLocalizedString("Scroll down and click Accessibility", comment: "Used on auth instructions")

		static let authorizedInstructionCheckInformant = NSLocalizedString("Check Informant", comment: "Used on auth instructions")

		static let authorizedInstructionCheckInformantLong = NSLocalizedString("In Accessibility, make sure Informant is checked", comment: "Used on auth instructions")

		static let authorizedInstructionCheckFullDiskAccess = NSLocalizedString("In Full Disk Access, make sure Informant is checked (optional)", comment: "Used on auth instructions")

		static let authorizedInstructionRestartInformant = NSLocalizedString("Quit Informant and reopen it", comment: "")

		static let authorizedInstructionAutomationCheckFinder = NSLocalizedString("In Automation, under Informant, make sure Finder is checked", comment: "")

		// Auth. Padlock tidbit
		static let authorizedInstructionClickLock = NSLocalizedString("If the checkbox is greyed out, click the lock and enter your password.", comment: "Used on authorized welcome panel")

		// Welcome labels
		static let welcomeReadyToUse = NSLocalizedString("You're ready to use Informant!", comment: "Used on welcome panel")

		static let welcomeHowToUse = NSLocalizedString("To use Informant, select a file, and its size will appear in the menu bar.", comment: "Used on welcome panel")

		static let openPanelChoose = NSLocalizedString("Choose", comment: "")

		static let panelNoItemsSelected = NSLocalizedString("No selection", comment: "String displayed when no items are selected.")

		static let panelErrorTitle = NSLocalizedString("No access", comment: "The title displayed when the selection errors out")

		static let openPanelGrantAccess = NSLocalizedString("Grant Access", comment: "Open panel's grant access button label")

		static let menubar = NSLocalizedString("Menu Bar Utility", comment: "")

		static let display = NSLocalizedString("Display", comment: "")

		static let details = NSLocalizedString("Details", comment: "")

		static let panel = NSLocalizedString("Panel", comment: "")

		static let system = NSLocalizedString("System", comment: "")

		static let privacyPolicy = NSLocalizedString("Privacy policy", comment: "")

		static let donate = NSLocalizedString("Donate", comment: "")

		static let feedback = NSLocalizedString("Feedback", comment: "")

		static let license = NSLocalizedString("License", comment: "")

		static let about = NSLocalizedString("About", comment: "")

		static let acknowledgements = NSLocalizedString("Acknowledgements", comment: "")

		static let privacy = NSLocalizedString("Privacy", comment: "")

		static let eula = NSLocalizedString("EULA", comment: "")

		static let twitter = NSLocalizedString("Twitter", comment: "")

		static let github = NSLocalizedString("GitHub", comment: "")

		static let releases = NSLocalizedString("Releases", comment: "")

		static let help = NSLocalizedString("Help", comment: "")

		static let none = NSLocalizedString("None", comment: "")

		static let video = NSLocalizedString("Video:", comment: "")

		static let audio = NSLocalizedString("Audio:", comment: "")

		static let bitrate = NSLocalizedString("Bitrate", comment: "")

		// Menu bar sections

		static let menubarSectionsGeneral = NSLocalizedString("General", comment: "")

		static let menubarSectionsImages = NSLocalizedString("Images", comment: "")

		static let menubarSectionsAudio = NSLocalizedString("Audio", comment: "")

		static let menubarSectionsVideo = NSLocalizedString("Video", comment: "")

		static let menubarSectionsAudioVideo = NSLocalizedString("Video & Audio", comment: "")

		static let menubarSectionsMedia = NSLocalizedString("Media", comment: "")

		static let menubarSectionsVolume = NSLocalizedString("Volume", comment: "")

		// Menu bar labels

		static let menubarShowSize = NSLocalizedString("Size", comment: "")

		static let menubarShowKind = NSLocalizedString("Kind", comment: "")

		static let menubarShowName = NSLocalizedString("Name", comment: "")

		static let menubarShowPath = NSLocalizedString("Path", comment: "")

		static let menubarShowItems = NSLocalizedString("Items", comment: "")

		static let menubarShowCreated = NSLocalizedString("Created", comment: "")

		static let menubarShowEdited = NSLocalizedString("Edited", comment: "")

		static let menubarShowVersion = NSLocalizedString("Version", comment: "")

		static let menubarShowDuration = NSLocalizedString("Duration", comment: "")

		static let menubarShowDimensions = NSLocalizedString("Dimensions", comment: "")

		static let menubarShowCodecs = NSLocalizedString("Codecs", comment: "")

		static let menubarShowAudioCodec = NSLocalizedString("Audio Codec", comment: "")

		static let menubarShowVideoCodec = NSLocalizedString("Video Codec", comment: "")

		static let menubarShowColorProfile = NSLocalizedString("Color Profile", comment: "")

		static let menubarShowColorGamut = NSLocalizedString("Gamut", comment: "")

		static let menubarShowVideoBitrate = NSLocalizedString("Video Bitrate", comment: "")

		static let menubarShowSampleRate = NSLocalizedString("Sample Rate", comment: "")

		static let menubarShowAudioBitrate = NSLocalizedString("Audio Bitrate", comment: "")

		static let menubarShowBitrate = NSLocalizedString("Bitrate", comment: "")

		static let menubarShowVolumeTotal = NSLocalizedString("Total", comment: "")

		static let menubarShowVolumeAvailable = NSLocalizedString("Available", comment: "")

		static let menubarShowVolumePurgeable = NSLocalizedString("Purgeable", comment: "")

		static let menubarShowAperture = NSLocalizedString("Aperture", comment: "")

		static let menubarShowISO = NSLocalizedString("ISO", comment: "")

		static let menubarShowFocalLength = NSLocalizedString("Focal Length", comment: "")

		static let menubarShowCamera = NSLocalizedString("Camera", comment: "")

		static let menubarShowShutterspeed = NSLocalizedString("Shutter Speed", comment: "")

		static let menubarShowExtra = NSLocalizedString("Extra", comment: "")

		// System

		static let preferredShell = NSLocalizedString("Preferred Shell:", comment: "The shell application the user chooses to use")

		static let menubarShowiCloudContainer = NSLocalizedString("iCloud Container", comment: "")

		static let menubarCopyPathDescriptor = NSLocalizedString("Click the menu bar utility to copy the path.", comment: "")

		static let menubarIcon = NSLocalizedString("Icon", comment: "")

		static let pickRootURL = NSLocalizedString("Disk Path:", comment: "Pick the root url used to give security access to the app.")

		static let shortcutToActivatePanel = NSLocalizedString("Shortcut to activate panel", comment: "Asks the user what shortcut they want to activate the panel")

		static let launchOnStartup = NSLocalizedString("Launch Informant on system startup", comment: "Asks the user if they want the app to launch on startup")

		static let menubarUtilityShow = NSLocalizedString("Show Menu Bar Utility", comment: "Asks the user if they want the menubar-utility enabled")

		static let menubarUtilityHide = NSLocalizedString("Hide Menu Bar Utility", comment: "Asks the user if they want the menubar-utility disabled")

		static let toggleDetailsPanel = NSLocalizedString("Toggle panel shortcut:", comment: "Asks the user what shortcut they want to toggle the details panel")

		static let showFullPath = NSLocalizedString("Include name of selection in path", comment: "Asks the user if they want to see where the file is located instead of the full path")

		static let skipDirectories = NSLocalizedString("Skip getting size for folders and apps", comment: "Asks the user if they want to prevent the app from sizing directories.")

		static let skipDirectoriesShort = NSLocalizedString("Skip Sizing Directories", comment: "Asks the user if they want to prevent the app from sizing directories.")

		static let hideWhenUsingOtherApps = NSLocalizedString("Hide when using apps besides Finder", comment: "")

		static let hideName = NSLocalizedString("Hide full name", comment: "")

		static let hidePath = NSLocalizedString("Hide path", comment: "")

		static let hideCreated = NSLocalizedString("Hide date created", comment: "")

		static let hideIcon = NSLocalizedString("Hide icon", comment: "")

		static let pause = NSLocalizedString("Pause Informant", comment: "")

		static let resumeInformant = NSLocalizedString("Resume Informant", comment: "")

		static let resume = NSLocalizedString("Resume", comment: "")

		static let paused = NSLocalizedString("Paused", comment: "")

		static let tapToResume = NSLocalizedString("Tap to resume", comment: "")

		// Misc. Labels
		static let multiSelectTitle = NSLocalizedString("items selected", comment: "The tag string to go on a multi-selection title in the panel")

		static let multiSelectSize = NSLocalizedString("Total Size:", comment: "The tag string under the title of the multi-selection panel")

		static let panelSnapZoneIndicator = NSLocalizedString("Release to snap", comment: "The indicator label when dragging the panel near the snap zone")

		// Panel Labels

		static let panelKind = NSLocalizedString("Kind", comment: "This is the file's kind displayed in the panel")

		static let panelSize = NSLocalizedString("Size", comment: "This is the file's size displayed in the panel")

		static let panelCreated = NSLocalizedString("Created", comment: "This is the file's creation date displayed in the panel")

		static let panelName = NSLocalizedString("Name", comment: "This is the file's name displayed on the panel")

		static let panelPath = NSLocalizedString("Path", comment: "This is the file's path displayed in the panel")

		static let panelWhere = NSLocalizedString("Where", comment: "This is the file's where path displayed in the panel")

		static let panelExpandedPath = NSLocalizedString("Expanded Path", comment: "This is the label that appears after clicking the path label on the panel")

		static let panelModified = NSLocalizedString("Edited", comment: "The tag string to the date modified on the panel interface")

		static let panelCamera = NSLocalizedString("Camera", comment: "Camera, Used on panel image view and movie")

		static let panelFocalLength = NSLocalizedString("Focal Length", comment: "Focal Length, Used on panel image view and movie")

		static let panelDimensions = NSLocalizedString("Dimensions", comment: "Dimensions, Used on panel image view and movie")

		static let panelColorProfile = NSLocalizedString("Color Profile", comment: "Color Profile, Used on panel image view and movie")

		static let panelAperture = NSLocalizedString("Aperture", comment: "Aperture, Used on panel image view and movie")

		static let panelExposure = NSLocalizedString("Exposure", comment: "Exposure, Used on panel image view and movie")

		static let panelCodecs = NSLocalizedString("Codecs", comment: "Codecs, Used on panel movie view")

		static let panelDuration = NSLocalizedString("Duration", comment: "Duration, Used on panel movie & audio view")

		static let panelSampleRate = NSLocalizedString("Sample Rate", comment: "Sample rate, Used on panel audio view")

		static let panelContains = NSLocalizedString("Contains", comment: "Contains, Used on the panel directory view")

		static let panelVersion = NSLocalizedString("Version", comment: "Version, Used on panel application view")

		static let panelAvailable = NSLocalizedString("Available", comment: "Available, Used on panel volume view")

		static let panelTotal = NSLocalizedString("Total", comment: "Total, Used on volume panel view")

		static let panelPurgeable = NSLocalizedString("Purgeable", comment: "Purgeable, Used on volume panel view")

		static let panelTags = NSLocalizedString("Tags", comment: "Used on tags panel view")

		static let panelHidden = NSLocalizedString("Hidden", comment: "Used on bottom of the panel view to indicate a hidden file")

		static let panelUnauthorized = NSLocalizedString("Unauthorized", comment: "Used on panel when accessibility api is disabled")

		static let panelAuthorize = NSLocalizedString("Authorize", comment: "Used on panel when accessibility api is disabled")

		// Panel Menu Labels

		static let menuAccessibility = NSLocalizedString("Authorize Informant", comment: "")

		static let menuAccessibilitySub = NSLocalizedString("Informant must be authorized to work", comment: "")

		static let menuPause = NSLocalizedString("Pause", comment: "")

		static let menuResume = NSLocalizedString("Resume", comment: "")

		static let menuShow = NSLocalizedString("Show", comment: "")

		static let menuHide = NSLocalizedString("Hide", comment: "")

		static let menuAbout = NSLocalizedString("About Informant...", comment: "About menu item in panel menu")

		static let menuPreferences = NSLocalizedString("Preferences...", comment: "Preferences menu item in panel menu")

		static let menuHelp = NSLocalizedString("Help", comment: "Help menu item in panel menu")

		static let menuQuit = NSLocalizedString("Quit", comment: "Quit menu item in panel menu")

		// Preferences Labels
		static let preferencesShortcutsDisplayDetailPanel = NSLocalizedString("Display detail panel", comment: "Shortcut label for displaying panel")
	}

	// MARK: - Icons
	public enum Icons {

		// Universal
		static let rightArrowIcon = "arrow.right"

		static let downArrowIcon = "arrow.down"

		// Panel
		static let panelHidden = "eye.slash"

		static let panelCloud = "cloud"

		static let panelAlertCopied = "doc.on.doc"

		static let panelLockSlash = "lock.slash.fill"

		static let panelNoAccess = "minus.circle"

		static let panelHideButton = "xmark"

		static let panelPreferencesButton = "gear"

		static let panelTerminalButton = "arrowupforwardapp"

		static let panelPathIcon = "externaldrive"

		static let panelCopyIcon = "square.on.square"

		// Auth.
		static let authLockIcon = "lock.fill"

		static let authUnlockIcon = "lock.open.fill"

		static let pause = "pause.png"

		static let resume = "resume.png"

		static let lock = "lock.png"

		static let noIcon = NSLocalizedString("No Icon", comment: "")

		static let menubarBlank = "menubar-blank"

		static let menubarDefault = "menubar-default"

		static let menubarDoc = "menubar-doc"

		static let menubarDrive = "menubar-drive"

		static let menubarFolder = "menubar-folder"

		static let menubarInfo = "menubar-info"

		static let menubarViewfinder = "menubar-viewfinder"

		static let menubarSquare = "menubar-square"

		static let menubarDark = "menubar-dark"
	}

	// MARK: - Images
	public enum Images {

		static let appIcon = "AppIcon"

		static let appIconNoShadow = "AppIcon-noshadow"
	}

	// MARK: - Extra
	public enum Extra {

		static let items = NSLocalizedString("items", comment: "Items, used in the single directory selection")

		static let item = NSLocalizedString("item", comment: "Singular version of items")

		static let popUpCopied = NSLocalizedString("Copied", comment: "Used on the copied popup")

		static let popUpPathCopied = NSLocalizedString("Path Copied", comment: "Used on the copied popup")
	}
}
