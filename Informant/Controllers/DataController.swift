//
//  DataController.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-21.
//

import AVFoundation
import Foundation
import SwiftUI
import UniformTypeIdentifiers

/// Controls the flow of selection details and provides them to requesting views.
class DataController: Controller, ControllerProtocol {

	/// Keeps copies of recent selections for later use.
	let cache: Cache!

	required init(appDelegate: AppDelegate) {

		// Initialize cache
		cache = Cache()

		super.init(appDelegate: appDelegate)
	}

	// MARK: - Packaging Functions

	/// This packages externally provided data and returns it.
	func package(_ data: SelectionData) -> SelectionData? {

		// Filter data for settings
		guard let selection = appDelegate.settings.applySettings(data) else {
			return nil
		}

		return selection
	}

	// MARK: - Selection Functions

	/// Determines the selection type and then returns the data for it.
	func getSelection(_ paths: Paths? = nil) -> Selection? {

		// Gather paths
		let gatheredPaths = paths ?? appDelegate.pathController.getSelectedPaths()

		// Get paths
		guard let selectedPaths = gatheredPaths else {
			return nil
		}

		// Check on the state of the path object
		switch selectedPaths.state {

			case .PathUnavailable:
				return Selection(type: .None, info: nil, data: nil)

			case .PathDuplicate:
				return Selection(type: .Duplicate, info: nil, data: nil)

			case .PathError:
				return Selection(type: .Error, info: nil, data: nil)

			default:
				break
		}

		// Get the paths
		guard let paths = selectedPaths.paths else {
			return nil
		}

		// Get selection type
		guard let selectionType = getSelectionType(paths: paths) else {
			return Selection(type: .Error, info: nil, data: nil)
		}

		// Get utility data
		let info = getSelectionInfo(type: selectionType, paths: paths)

		// TODO: Verify that this fix is okay in the future
		// ⚠️ .iCloud file checking has been removed

		// Get display data
		let data = getSelectionData(info: info)

		// Return selection
		return Selection(
			type: selectionType,
			info: info,
			data: data
		)
	}

	/// Determine selection type.
	private func getSelectionType(paths: [String]) -> SelectionType? {

		// Determine if the selection is a single item or multiple items
		if paths.count >= 2 {
			return .Multi
		}

		// Get the selection type for a singal item
		return DataUtility.getSelectionTypeSingle(path: paths[0])
	}

	/// Pull in data for the determined selection type.
	private func getSelectionData(info: SelectionInfo) -> SelectionData? {

		// Initialize data retrieval object
		guard let retriever = DataRetrieval(cache: cache, info: info) else {
			return nil
		}

		// Make a retrieval of data
		return retriever.retrieve()
	}

	/// Pull in specifics to the selection.
	private func getSelectionInfo(type: SelectionType, paths: [String]) -> SelectionInfo {

		// Abort if it's a multi item selection
		if type == .Multi {

			// Get the disk name
			let diskNameURL = URL(fileURLWithPath: paths[1])
			let diskName = diskNameURL.pathComponents[1]

			// Filter out the disk name
			let urls: [URL] = paths.map { path in
				let pathWithoutDisk = path.replacingOccurrences(of: diskName, with: "")
				return URL(fileURLWithPath: pathWithoutDisk)
			}

			return SelectionInfo(
				appDelegate: appDelegate,
				urls: urls,
				type: type,
				isiCloudSyncFile: nil,
				isHidden: nil
			)
		}

		// Create url
		let url = URL(fileURLWithPath: paths[0])

		// Gather all resources
		let resources = DataUtility.getURLResources(url, [.isUbiquitousItemKey, .isHiddenKey])

		// Exit
		return SelectionInfo(
			appDelegate: appDelegate,
			urls: [url],
			type: type,
			isiCloudSyncFile: resources?.isUbiquitousItem,
			isHidden: resources?.isHidden
		)
	}

	// MARK: - Data Functions

	// iCloud Fix
	/// Abort if certain requirements are met. For example, the selection ending with an .icloud extension.
	/*
	 func shouldSelectionAbort(info: SelectionInfo) -> Bool? {

	 	// Abort if it's an iCloud sync file
	 	if info.isiCloudSyncFile == true {
	 		return true
	 	}

	 	return nil
	 }
	  */
}
