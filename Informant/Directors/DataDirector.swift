//
//  DataSizing.swift
//  Informant
//
//  Created by Ty Irvine on 2022-04-02.
//

import Foundation

class DataDirector {

	/// Keeps track of all job statuses.
	/// BOOL: Job status
	/// False = cancelled
	/// True = active
	private var jobs: [String: Bool] = [:]
	private let jobQueue = DispatchQueue(label: "dataDirectorJobQueue")

	/// Keeps track of all sizes so they can be accessed by other controllers.
	private var fastCache: [String: SelectionData] = [:]
	private let fastCacheQueue = DispatchQueue(label: "dataDirectorFastCacheQueue")

	/// This is the global loader delay.
	/// This is the loader delay in milliseconds. Meaning the loader won't appear till this delay is reached.
	let loaderDelayMilliseconds: Double = 10
	var loaderDelaySeconds: Double {
		loaderDelayMilliseconds * 0.001
	}

	// MARK: - Universal Functions

	/// Resets all globals.
	func resetAll() {
		fastCacheQueueEmpty()
		cancelAllJobs()
	}

	// MARK: - Fast Cache Functions

	/// Retrieves from the fast cache synchronously!
	func fastCacheQueueGetSelection(jobID: String) -> SelectionData? {
		fastCacheQueue.sync {
			if self.fastCache.keys.contains(jobID) {

				// If the cached selection is valid, close the job
				guard let cachedSelection = self.fastCache[jobID] else {
					return nil
				}

				endJob(jobID)

				return cachedSelection
			}
			return nil
		}
	}

	/// Empties all fast cache properties.
	private func fastCacheQueueEmpty() {
		fastCacheQueue.sync {
			self.fastCache.removeAll()
		}
	}

	/// Makes sure the size gets updated synchronously.
	private func fastCacheQueueUpdate(jobID: String, selection: SelectionData?) {
		fastCacheQueue.sync {
			self.fastCache[jobID] = selection
		}
	}

	// MARK: - Director Functions

	/// Checks to see if the entire selection is loading or not.
	func isSelectionLoading(_ id: String) -> Bool {
		jobQueue.sync {
			for job in self.jobs {
				if job.value == true {
					return true
				}
			}
			return false
		}
	}

	/// Checks to see if the job is not cancelled.
	func isJobActive(_ id: String) -> Bool? {
		jobQueue.sync {
			guard jobs.keys.contains(id), let jobStatus = jobs[id] else { return nil }
			return jobStatus
		}
	}

	/// Cancel all jobs.
	private func cancelAllJobs() {
		jobQueue.sync {
			for job in self.jobs {
				self.jobs[job.key] = false
			}
		}
	}

	/// Removes the job. This will be done only after it's been CONFIRMED cancelled.
	/// This must be done to prevent memory leaks.
	private func removeJob(_ id: String) {
		jobQueue.sync {
			if self.jobs.keys.contains(id), self.jobs[id] == false {
				self.jobs.removeValue(forKey: id)
			}
		}
	}

	/// This is the clean up process when done finding a size.
	private func endJob(_ id: String) {
		jobQueue.sync {
			self.jobs[id] = false
		}
	}

	/// Creates a new job. Returns the job id.
	private func addJob(_ id: String) {
		jobQueue.sync {
			self.jobs[id] = true
		}
	}

	/// Simply aggregates clean up functions.
	private func cleanUpJob(jobID: String) {
		endJob(jobID)
		removeJob(jobID)
	}

	/// This updates the current display with the given selection.
	private func updateDisplay(_ info: SelectionInfo, _ jobID: String, _ selectionData: SelectionData) {

		// This lets us know that the update has been queued on the main thread
		print("UPDATING...")

		// This update has to occur on the main thread because that's where the UI gets its updates from
		DispatchQueue.main.async {

			// Double check to make sure the job is still active
			// If so, update the display
			if self.isJobActive(jobID) == true {

				// The job is no longer needed regardless of the state
				self.cleanUpJob(jobID: jobID)

				// Get the display controller
				let displayController = info.appDelegate.displayController

				// Merge the data from the display
				if let merged = displayController?.findCurrentSelection()?.merge(with: selectionData) {
					displayController?.updateDisplayExternally(merged, info)
				}

				// Otherwise update the display with what we found
				else {
					displayController?.updateDisplayExternally(selectionData, info)
				}

				print("UPDATE MADE ⛳️")
			}
		}
	}

	// MARK: - Directors

	/// Grabs the remaining data asynchronously.
	func findRemainingData(_ info: SelectionInfo, _ selection: SelectionData, data: @escaping () -> SelectionData?) {
		findRemainingDataAsynchronously(info, selection) {
			data()
		}
	}

	/// Decides if a size should be found synchronously or not.
	func findSize(_ info: SelectionInfo, _ selection: SelectionData, cache: Cache) -> String? {

		// Abort if this is a non-size type
		if info.type == .Volume {
			return nil
		}

		// Used to build the total size
		var totalSize: Int64? = 0

		let type = info.type

		// Loop through all urls
		for url in info.urls {

			// Check cache first
			if let size = cache.get(url: url)?.bytes {
				totalSize? += size
				continue
			}

			// Check type and bail if it's a directory type — if no size is found in the cache
			else if type == .Directory || type == .Application || type == .Multi {
				totalSize = nil
				break
			}

			// At this point it's safe to just collect the data synchronously on a single file
			else if let size = getBytes(info) {
				totalSize? += Int64(size)
			}
		}

		// Check to see if the total size is valid
		if let size = totalSize {
			return size.formatBytes()
		}

		// Otherwise just get the data asynchronously
		findSizeAsynchronously(info, selection, cache: cache)

		// Exit
		return nil
	}

	// MARK: - Asynchronous Directors

	/// Asynchronously gets the remaining data.
	private func findRemainingDataAsynchronously(_ info: SelectionInfo, _ selection: SelectionData, _ data: @escaping () -> SelectionData?) {

		// Start getting the data
		findSelectionAsynchronously(info: info, jobID: info.jobIDMain, name: "Remaining Data") {

			// Return the new selection found merged with the old selection
			let newSelection = data()
			let merged = newSelection?.merge(with: selection)
			return merged
		}
	}

	/// Asynchronously gets the size.
	private func findSizeAsynchronously(_ info: SelectionInfo, _ selection: SelectionData, cache: Cache) {

		// Start getting the data
		findSelectionAsynchronously(info: info, jobID: info.jobIDSize, name: "Sizing") {

			// Create ref to size
			var size: String?

			// Find the size. This is where the hang up will be
			switch info.type {
				case .Multi:
					size = self.getMultiSize(info, cache: cache)
					break

				default:
					size = self.getSize(info, cache: cache)
					break
			}

			// Get a mutable copy of the selection and return it
			var selection = selection
			selection.data[.keyShowSize] = size
			return selection
		}
	}

	/// Asynchronously gets the remaining data.
	private func findSelectionAsynchronously(info: SelectionInfo, jobID: String, name: String, _ workItem: @escaping () -> SelectionData?) {

		// Create a new job
		addJob(jobID)

		// Record the time
		let startTime = Date().timeIntervalSince1970.magnitude

		// Start getting the size
		DispatchQueue.global(qos: .userInitiated).async {

			// The actual work item that gets the selection
			guard let selection = workItem() else {
				return self.cleanUpJob(jobID: jobID)
			}

			// Now that the size has been found, check to see if the job is still active
			// If so, update the selection. Make sure the size is valid too!
			if self.isJobActive(jobID) == true {

				// Get elapsed time in milliseconds
				let elapsed = (Date().timeIntervalSince1970.magnitude - startTime) * 1000

				// This sort of ends execution but it gets ref.'d twice
				func updateJob() {
					self.fastCacheQueueUpdate(jobID: jobID, selection: selection)
					self.updateDisplay(info, jobID, selection)
				}

				// If time has elapsed past 50ms, then add in a delay
				if elapsed > 50 {
					DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.2) {
						updateJob()
					}
				}

				// Otherwise, update normally
				else {
					updateJob()
				}
			}

			// Otherwise, clean up operation
			else {
				self.cleanUpJob(jobID: jobID)
			}

			// Record the end time
			let endTime = Date().timeIntervalSince1970.magnitude

			print("⏱ \(name) took: \(((endTime - startTime) * 1000.0).rounded())ms")
		}
	}

	// MARK: - Sizing Functions

	/// Simply gets the size of a multi. selection.
	private func getMultiSize(_ info: SelectionInfo, cache: Cache) -> String? {

		let urls = info.urls

		// Get total size of all selected files
		var totalSize: Int? = 0

		// Iterate over all urls
		for url in urls {

			// Nil check total size and make sure the job is active
			if totalSize == nil || isJobActive(info.jobIDSize) == false {
				break
			}

			// Grab resources
			let resources = DataUtility.getURLResources(url, [.isDirectoryKey, .totalFileSizeKey])

			// Continue to next iteration if the item is not a directory
			if resources?.isDirectory == false, let size = resources?.totalFileSize {
				totalSize! += size
				continue
			}

			// Otherwise, find the correct directory size
			else if resources?.isDirectory == true, let size = getDirectorySize(url, info: info, cache: cache) {
				totalSize! += size
				continue
			}

			// Otherwise bail out on a bad selection
			else {
				totalSize = nil
				break
			}
		}

		// Do a final nil check
		guard let totalSize = totalSize else {
			return nil
		}

		// Format and exit
		return totalSize.formatBytes()
	}

	/// Gets the size of the selection regardless of whether it's a directory or file.
	/// Selection must only include one item however. Returns selection already formatted.
	private func getSize(_ info: SelectionInfo, cache: Cache) -> String? {

		let type = info.type

		// Get size for a directory type
		if type == .Directory || type == .Application {

			// Abort if the settings say so
			if info.appDelegate.settings.settingSkipGettingSizeForDirectories == true ||
				info.appDelegate.settings.settingShowSize == false
			{
				return nil
			}

			// Otherwise get the size
			let size = getDirectorySize(info.url, info: info, cache: cache)
			return size?.formatBytes()
		}

		// Otherwise get the size for a single file
		else {
			return getBytes(info)?.formatBytes()
		}
	}

	/// This gets the plain bytes of the file.
	private func getBytes(_ info: SelectionInfo) -> Int? {

		// Don't get size due to no size existing
		if info.type == .Volume {
			return nil
		}

		// Get the size for a file type
		let resources = DataUtility.getURLResources(info.url, [.totalFileSizeKey])
		return resources?.totalFileSize
	}

	/// Asynchronously gets the file size for a directory, whether in the cache or not.
	func getDirectorySize(_ url: URL, info: SelectionInfo, cache: Cache) -> Int? {

		// Get size of url from the cache
		if let size = cache.get(url: url)?.bytes {
			return Int(size)
		}

		// Otherwise store to the cache
		else {
			do {
				let size = try FileManager.default.allocatedSizeOfDirectory(at: url, info: info)
				cache.store(url: url, bytes: size)
				return Int(size)
			}
			catch { }
		}

		// Otherwise error out
		return nil
	}

	/// Simply cleans up execution of the async finder.
	/*
	 private static func cleanUp(_ info: SelectionInfo, _ selection: SelectionData, _ size: String?) {

	 let jobID = info.jobID
	 var selection = selection

	 // Now that the size has been found, check to see if the job is still active
	 // If so, update the selection. Make sure the size is valid too!
	 if isJobActive(jobID) == true, size != nil {
	 selection.data[.keyShowSize] = size

	 sizes[info.jobID] = size

	 // Update the display
	 updateSelection(info, selection)
	 }

	 // Clean up
	 endJob(jobID)
	 removeJob(jobID)
	 }
	 */
}
