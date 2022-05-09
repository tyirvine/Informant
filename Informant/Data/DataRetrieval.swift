//
//  DataRetrieval.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-24.
//

import AVFoundation
import Foundation
import SwiftUI
import UniformTypeIdentifiers

class DataRetrieval {

	private let cache: Cache
	private let metadata: [CFString: Any]?
	private let avasset: AVAsset?
	private var selection: SelectionData
	private let info: SelectionInfo

	/// Main initializer.
	init?(cache: Cache, info: SelectionInfo) {

		// Assign cache ref.
		self.cache = cache

		// Create a temporary mutable holder for the constant metadata
		var metaTemp: [CFString: Any]?

		// Retrieve and assign metadata for file
		if let metadata = DataUtility.getURLMetadata(info.url) {
			metaTemp = metadata
		}

		// This way the metadata we work with is immutable
		metadata = metaTemp

		// Initialize the player object
		avasset = AVAsset(url: info.url)

		// Initialize selection object
		selection = SelectionData()

		// Assign info ref.
		self.info = info
	}

	// MARK: - Retrieval Functions

	/// This packages all data and returns it.
	func retrieve() -> SelectionData? {

		print("-------------------- NEW SELECTION ↓ -------------------")

		// Cancel all async jobs
		info.appDelegate.dataDirector.resetAll()

		// TODO: Make this process right here async
		// Get initial single selection data.
		guard let singleData = returnInitialData() else {
			return nil
		}

		// Attempt to grab remaining data asynchronously.
		guard let remainingData = returnRemainingData(singleData) else {
			return nil
		}

		// Attempt to merge the data with any new data found.
		guard let merged = mergeData(singleData, remainingData) else {
			return nil
		}

		// Apply any long duration async items found (like total size).
		guard let asyncSelection = applyLargeAsyncItems(merged) else {
			return nil
		}

		// Filter data for settings
		guard let selection = applySettingsToData(asyncSelection) else {
			return nil
		}

		return selection
	}

	// MARK: - Async Packaging Functions

	/// This retrieves the data in an async manner.
	private func returnRemainingData(_ selection: SelectionData) -> SelectionData? {

		// Create a mutable copy of the selection
		var selection = selection

		// Put data retrieval on a background thread
		info.appDelegate.dataDirector.findRemainingData(info, selection) {
			self.returnData()
		}

		// Sleep main thread, this way we can wait a certain duration for the background thread to complete
		do {
			// usleep takes microseconds so we just need to get milliseconds by multiplying by 1000
			usleep(20 * 1000)
		}

		// After the main thread has slept, attempt to get the selection from the cache
		// - avoids poor looking double updates.
		// ---------------------------------
		// Grab ref. to the director
		guard let dataDirector = info.appDelegate.dataDirector else {
			return selection
		}

		// Attempts to get a selection
		guard let newSelection = dataDirector.fastCacheQueueGetSelection(jobID: info.jobIDMain) else {
			return selection
		}

		// We've found a new selection
		return newSelection
	}

	/// This allows the selection to return as one without awkward updates.
	/// When sizing small items, they size quickly but they still make the menu bar jump
	/// because they're loading in asynchronously. This prevents that from happening.
	private func applyLargeAsyncItems(_ selection: SelectionData) -> SelectionData? {

		// Create a mutable copy of the selection
		var selection = selection

		// Make a fetch for async data
		let size = info.appDelegate.dataDirector.findSize(info, selection, cache: cache)

		// Assign the fetch value to size
		selection.data[.keyShowSize] = size

		// Sleep the main thread for x milliseconds. The delay is in microseconds
		// ... if it's a large size search like a directory type.
		// Size must not exist for this delay to occur as well.
		if (info.type == .Directory || info.type == .Application) && (size == nil) {
			do {
				// usleep takes microseconds so we just need to get milliseconds by multiplying by 1000
				usleep(50 * 1000)
			}
		}

		// Then we attempt to get the size again. This way we can get everything synchronously
		// and avoid poor looking double updates.
		// ---------------------------------
		// Grab ref. to the director
		guard let dataDirector = info.appDelegate.dataDirector else {
			return selection
		}

		// Attempts to get a size
		guard let size = dataDirector.fastCacheQueueGetSelection(jobID: info.jobIDSize)?.data[.keyShowSize] else {
			return selection
		}

		// Wait until the loader delay is finished before returning.
		// This way we can return the selection if it's short enough as one whole.
		selection.data[.keyShowSize] = size
		print("✳️ SIZE: \(size)")

		return selection
	}

	// MARK: - Packaging Functions

	/// Applies all display settings from the settings controller to the data.
	private func applySettingsToData(_ selection: SelectionData) -> SelectionData? {
		let selectionWithSettings = info.appDelegate.settings.applySettings(selection)
		return selectionWithSettings
	}

	/// Picks out appropriate data to return.
	private func returnData() -> SelectionData? {

		// Pick out the appropriate data to return
		switch info.type {

			case .Multi:
				return displayDataMulti()

			case .Single:
				return displayDataSingle()

			case .Directory:
				return displayDataDirectory()

			case .Application:
				return displayDataApplication()

			case .Volume:
				return displayDataVolume()

			case .Image:
				return displayDataImage()

			case .Movie:
				return displayDataMovie()

			case .Audio:
				return displayDataAudio()

			default:
				break
		}

		return nil
	}

	/// This returns an initial selection if the selection is a single selection.
	private func returnInitialData() -> SelectionData? {

		// abort if the selection type is not appropriate to merge with
		if info.type == .Multi {
			return SelectionData()
		}

		// Otherwise, proceed with merging
		guard let displayDataSingle = displayDataSingle() else {
			return nil
		}

		return displayDataSingle
	}

	/// Merges specific display data with generalized display data to reduce function complexity.
	private func mergeData(_ old: SelectionData, _ new: SelectionData) -> SelectionData? {

		// abort if the selection type is not appropriate to merge with
		if info.type == .Multi {
			return old
		}

		return old.merge(with: new)
	}

	// MARK: - General Display Data Functions

	/// Gets data for selections involving multiple files and directories.
	private func displayDataMulti() -> SelectionData? {

		let urls = info.urls

		// Get count of all URL items
		let totalCount = urls.count

		// Format fields
		let totalCountFormatted = DataFormatting.formatDirectoryItemCount(totalCount)

		// Assign fields and exit
		selection.data[.keyShowItems] = "\(totalCountFormatted)"

		return selection
	}

	/// Gets data for a single file or directory selected.
	private func displayDataSingle() -> SelectionData? {

		let keys: Set<URLResourceKey> = [
			.pathKey,
			.localizedNameKey,
			.localizedTypeDescriptionKey,
			.creationDateKey,
			.contentModificationDateKey,
			.ubiquitousItemContainerDisplayNameKey,
		]

		// Get resources
		let resources = DataUtility.getURLResources(info.url, keys)

		// Get and assign created date
		if let created = resources?.creationDate {
			selection.data[.keyShowCreated] = created.formatDate()
		}
		else {
			selection.data[.keyShowCreated] = nil
		}

		// Get and assign modified date
		if let modified = resources?.contentModificationDate {
			selection.data[.keyShowModified] = modified.formatDate()
		}
		else {
			selection.data[.keyShowModified] = nil
		}

		// Format and assign the path
		if let path = resources?.path {
			let url = URL(fileURLWithPath: path).deletingLastPathComponent()
			selection.data[.keyShowPath] = url.path
		}

		// Format and assign the cloud container
		if let cloudContainer = resources?.ubiquitousItemContainerDisplayName {
			let cloudContainerFormatted = "􀌋 \(cloudContainer)"
			selection.data[.keyShowiCloudContainerName] = cloudContainerFormatted
		}

		// Assign remaining fields and exit
		selection.data[.keyShowName] = resources?.localizedName
		selection.data[.keyShowKind] = resources?.localizedTypeDescription

		return selection
	}

	// MARK: - Specialized Display Data Functions

	private func displayDataImage() -> SelectionData? {

		// Get image metadata
		let imageMetadata = DataUtility.getURLImageMetadata(info.url)

		// Image information
		if let exifDict = imageMetadata?[kCGImagePropertyExifDictionary] as? [CFString: Any] {

			if let focalLength = exifDict[kCGImagePropertyExifFocalLength] {
				selection.data[.keyShowFocalLength] = String(describing: focalLength) + " mm"
			}

			if let aperture = exifDict[kCGImagePropertyExifFNumber] {
				selection.data[.keyShowAperture] = "f/" + String(describing: aperture)
			}

			if let shutter = exifDict[kCGImagePropertyExifExposureTime] {
				let fraction = Rational(approximating: shutter as! Double)
				selection.data[.keyShowShutterSpeed] = String(fraction.numerator.description + "/" + fraction.denominator.description)
			}

			if let iso = (exifDict[kCGImagePropertyExifISOSpeedRatings] as? NSArray) {
				selection.data[.keyShowISO] = String(describing: iso[0])
			}
		}

		// Get color gamut
		var gamut: String?
		let image = NSImage(byReferencing: info.url).cgImage(forProposedRect: nil, context: nil, hints: nil)
		if let isWideGamutRGB = image?.colorSpace?.isWideGamutRGB {
			gamut = isWideGamutRGB ? "Wide Gamut" : "sRGB"
		}

		// Retrieve and format remaining fields
		selection.data[.keyShowColorGamut] = gamut
		selection.data[.keyShowCamera] = retrieveCamera(imageMetadata)
		selection.data[.keyShowColorProfile] = retrieveColorProfile()
		selection.data[.keyShowDimensions] = retrieveDimensions()

		return selection
	}

	private func displayDataMovie() -> SelectionData? {

		selection.data[.keyShowCodecs] = retrieveCodecs()
		selection.data[.keyShowDuration] = retrieveDuration()
		selection.data[.keyShowColorProfile] = retrieveColorProfile()
		selection.data[.keyShowDimensions] = retrieveDimensionsMovie(info)
		selection.data[.keyShowTotalBitrate] = retrieveTotalBitrate()
		selection.data[.keyShowSampleRate] = retrieveSampleRate()

		//	TODO: Add in separate audio/video bitrates
//		selection.data[.keyShowAudioBitrate] = retrieveBitrate(type: .audio)
//		selection.data[.keyShowVideoBitrate] = retrieveBitrate(type: .video)

		return selection
	}

	private func displayDataAudio() -> SelectionData? {

		selection.data[.keyShowCodecs] = retrieveCodecs()
		selection.data[.keyShowSampleRate] = retrieveSampleRate()
		selection.data[.keyShowDuration] = retrieveDuration()
		selection.data[.keyShowTotalBitrate] = retrieveTotalBitrate()

		return selection
	}

	private func displayDataDirectory() -> SelectionData? {

		// Get access to directory
		if info.isiCloudSyncFile != true {

			// Get # of items in the directory
			if let itemCount = FileManager.default.shallowCountOfItemsInDirectory(at: info.url) {
				selection.data[.keyShowItems] = DataFormatting.formatDirectoryItemCount(itemCount)
			}
		}

		// Otherwise we have no permission to view or it's an iCloud sync file
		return selection
	}

	private func displayDataApplication() -> SelectionData? {

		// Get version #
		if let version = metadata?[kMDItemVersion] {
			let versionString = String(describing: "ν\(version)")
			if versionString.count > 1 {
				selection.data[.keyShowVersion] = versionString
			}
		}

		return selection
	}

	private func displayDataVolume() -> SelectionData? {

		let keys: Set<URLResourceKey> = [
			.volumeTotalCapacityKey,
			.volumeAvailableCapacityKey,
			.volumeAvailableCapacityForImportantUsageKey,
		]

		var volumeTotal = "", volumeAvailable = "", volumePurgeable = ""

		// Get resources
		guard let resources = DataUtility.getURLResources(info.url, keys) else {
			return nil
		}

		// Get important usage
		guard let importantUsage = resources.volumeAvailableCapacityForImportantUsage else {
			return nil
		}

		// Get total capacity
		guard let totalCapacity = resources.volumeTotalCapacity else {
			return nil
		}

		// Get available capacity
		guard let availableCapacity = resources.volumeAvailableCapacity else {
			return nil
		}

		// Get purgeable capacity if usage is 0
		if importantUsage != 0 {
			let purged = abs(importantUsage - Int64(availableCapacity))
			volumePurgeable = purged.formatBytes()
			volumeAvailable = importantUsage.formatBytes()
		}

		// Otherwise use regular available capacity
		else {
			volumeAvailable = availableCapacity.formatBytes()
		}

		volumeTotal = totalCapacity.formatBytes()

		// Assign remaining values and exit
		selection.data[.keyShowVolumeTotal] = volumeTotal
		selection.data[.keyShowVolumeAvailable] = volumeAvailable + " " + ContentManager.Labels.volumeAvailable
		selection.data[.keyShowVolumePurgeable] = volumePurgeable + " " + ContentManager.Labels.volumePurgeable

		return selection
	}

	// MARK: - Specific Data Gathering Functions

	/// Formats and returns dimensions for a video.
	private func retrieveDimensionsMovie(_ info: SelectionInfo) -> String? {

		guard let track = AVURLAsset(url: info.url).tracks(withMediaType: AVMediaType.video).first else {
			return nil
		}

		let size = track.naturalSize.applying(track.preferredTransform)

		let width = size.width.rounded(.towardZero)
		let height = size.height.rounded(.towardZero)

		return DataFormatting.formatDimensions(x: Int(width), y: Int(height))
	}

	/// Formats and returns dimensions for an image.
	private func retrieveDimensions() -> String? {

		let width = metadata?[kMDItemPixelWidth]
		let height = metadata?[kMDItemPixelHeight]

		guard let dimensions = DataFormatting.formatDimensions(x: width, y: height) else {
			return nil
		}

		return dimensions
	}

	/// Retrieves the color profile.
	private func retrieveColorProfile() -> String? {

		let profile = metadata?[kMDItemProfileName] as? String

		return profile
	}

	/// Retrieves the color profile.
	private func retrieveColorSpace() -> String? {

		let profile = metadata?[kMDItemColorSpace] as? String

		return profile
	}

	/// Retrieves the camera model.
	private func retrieveCamera(_ imageMetadata: NSDictionary?) -> String? {

		guard let tiffMetadata = imageMetadata?[kCGImagePropertyTIFFDictionary] as? [CFString: Any] else {
			return nil
		}

		guard let camera = tiffMetadata[kCGImagePropertyTIFFModel] as? String else {
			return nil
		}

		return camera
	}

	/// Retrieves the duration model.
	private func retrieveDuration() -> String? {

		let duration = metadata?[kMDItemDurationSeconds]

		guard let durationFormatted = DataFormatting.formatDuration(duration) else {
			return nil
		}

		return durationFormatted
	}

	/// Retrieves the codecs.
	private func retrieveCodecs() -> String? {

		// Try to get it this way first
		if let codecs = metadata?[kMDItemCodecs] as? [String] {
			return codecs.reversed().joined(separator: ", ")
		}

		// Otherwise get it this way
		var codecArray: [String] = []

		// Unwrap tracks
		guard let tracks = avasset?.tracks else {
			return nil
		}

		// Loop through and look for codecs
		for track in tracks {
			let codec = track.mediaFormat
			codecArray.append(codec)
		}

		return codecArray.joined(separator: ", ")
	}

	/// Retrieves the sample rate.
	private func retrieveSampleRate() -> String? {

		// Try and get it the clean way first
		if let track = avasset?.tracks(withMediaType: .audio).first {
			let sampleUInt32 = track.naturalTimeScale.magnitude
			let samples = Double(sampleUInt32)
			return DataFormatting.formatSampleRate(samples)
		}

		// Then try the less accurate way
		else if let sampleRate = metadata?[kMDItemAudioSampleRate] {
			return DataFormatting.formatSampleRate(sampleRate)
		}

		return nil
	}

	/// Retrieves the total bitrate.
	private func retrieveTotalBitrate() -> String? {

		// Grab bitrate and size first
		guard let metadata = DataUtility.getURLMetadata(info.url, [kMDItemFSSize!, kMDItemTotalBitRate!]) else {
			return nil
		}

		// Used to get the bitrate
		var bitrateFormatted: String?

		// Attempt to retrieve bitrates the normal way
		let videoBitrate = retrieveBitrate(type: .video)
		let audioBitrate = retrieveBitrate(type: .audio)

		if videoBitrate != nil && audioBitrate != nil {
			let totalBitrate = videoBitrate! + audioBitrate!
			if totalBitrate != 0 {
				bitrateFormatted = DataFormatting.formatBitrate(totalBitrate)
			}
		}

		// Otherwise use the crappy way
		else if let bitrate = metadata[kMDItemTotalBitRate] as? Float {
			// Bitrate comes as kbps so we need to just convert it to bps
			let bitrateConverted = bitrate * 1000.0
			bitrateFormatted = DataFormatting.formatBitrate(bitrateConverted)
		}

		// If all else fails calculate it manually
		else {
			// GB / (minutes * 0.0075)
			guard let size = metadata[kMDItemFSSize] as? Double else {
				return nil
			}

			guard let duration = avasset?.duration else {
				return nil
			}

			let durationFormatted = CMTimeGetSeconds(duration)

			let bitrateCalculated = (size / 1000000000) / ((durationFormatted / 60.0) * 0.0075)
			let bitrateAsBits = Float(bitrateCalculated * 1000000)

			guard let bitrateEstimate = DataFormatting.formatBitrate(bitrateAsBits) else {
				return nil
			}

			bitrateFormatted = "~" + bitrateEstimate
		}

		// Nil check and exit
		guard let bitrateFormatted = bitrateFormatted else {
			return nil
		}

		return bitrateFormatted
	}

	/// Retrieves the raw bitrate using a type.
	private func retrieveBitrate(type: AVMediaType) -> Float? {

		guard let av = avasset else {
			return nil
		}

		guard let track = av.tracks(withMediaType: type).first else {
			return nil
		}

		let bitrate = track.estimatedDataRate

		return bitrate
	}

	// TODO: Add in bitrate icon type thing
	/// Retrieves the bitrate with the appropriate icon attached.
	/*
	 private func retrieveBitrateWithIcon(type: AVMediaType) -> String? {

	 	guard let track = avasset.tracks(withMediaType: type).first else {
	 		return nil
	 	}

	 	let bitrate = track.estimatedDataRate

	 	guard let bitrateFormatted = DataFormatting.formatBitrate(bitrate) else {
	 		return nil
	 	}

	 	// Find the correct icon to pair with the bitrate type
	 	let icon: String

	 	switch type {
	 		case .audio:
	 			icon = "􀫀"
	 			break

	 		case .video:
	 			icon = "􀎶"
	 			break

	 		default:
	 			icon = ""
	 			break
	 	}

	 	return bitrateFormatted + " \(icon)"
	 }
	 */
}
