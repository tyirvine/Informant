//
//  DisplayController.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-23.
//

import AppKit
import Foundation

/// Controls all available display views and delegates the flow of data to them.
class DisplayController: Controller, ControllerProtocol {

	/// These are all the display types used within the app.
	enum Displays: String {
		case StatusDisplay
		case FloatDisplay
	}

	/// This holds all the monitors connected and their dimensions.
	var connectedMonitors: [ConnectedMonitor]

	/// This holds all the snap zones from all connected monitors.
	var allSnapPoints: [SnapPoint]

	required init(appDelegate: AppDelegate) {

		// Get all connected monitors and snap zones
		connectedMonitors = Self.getConnectedMonitors()
		allSnapPoints = Self.getAllSnapPoints(connectedMonitors)

		super.init(appDelegate: appDelegate)
	}

	// MARK: - Display General Functions

	/// Updates all active display views.
	func updateDisplays() {

		// Pull in the current selection
		guard let currentSelection = appDelegate.dataController.getSelection() else {
			return
		}

		// Get the current chosen display
		let display = findChosenDisplay()

		// Check the display type before proceeding
		switch currentSelection.type {
			case .None:
				hideDisplay(display)
				return

			case .Duplicate:
				return

			case .Error:
				errorDisplay(display)
				return

			default:
				break
		}

		// Otherwise, nil check the data
		guard let data = currentSelection.data else {
			hideDisplay(display)
			return
		}

		guard let info = currentSelection.info else {
			hideDisplay(display)
			return
		}

		// Close non-chosen displays
		closeNonChosenDisplays(display)

		// Show or update the chosen display
		updateDisplay(display, data, info)
	}

	/// Hides all active display views.
	func hideDisplays() {

		// Get the current chosen display
		let display = findChosenDisplay()

		// Hide the chosen display
		hideDisplay(display)
	}

	// MARK: - Display Specialized Functions

	/// This allows the currently chosen display to be updated externally.
	/// Make sure settings are applied.
	func updateDisplayExternally(_ data: SelectionData, _ info: SelectionInfo) {

		// Packages the provided data
		guard let packagedData = appDelegate.dataController.package(data) else {
			return
		}

		// Updates the current display
		let chosenDisplay = findChosenDisplay()
		chosenDisplay.update(packagedData, info)
	}

	/// Updates the currently chosen display.
	private func updateDisplay(_ chosenDisplay: Display, _ data: SelectionData, _ info: SelectionInfo) {
		chosenDisplay.update(data, info)
	}

	/// Wipes all information off visible displays.
	private func hideDisplay(_ chosenDisplay: Display) {
		chosenDisplay.hide()
	}

	/// Displays an error message.
	private func errorDisplay(_ chosenDisplay: Display) {
		chosenDisplay.error()
	}

	/// Returns the appropriate display object.
	private func pickDisplay(_ chosenDisplay: DisplayController.Displays) -> Display {
		switch chosenDisplay {
			case .StatusDisplay:
				return appDelegate.statusDisplay

			case .FloatDisplay:
				return appDelegate.floatDisplay
		}
	}

	/// Switches which displays should be shown.
	func closeNonChosenDisplays(_ chosenDisplay: Display) {

		// Get all displays
		guard let allDisplays = findAllDisplays() else {
			return
		}

		for display in allDisplays {

			// If display is closed - continue
			if display.isClosed == true {
				continue
			}

			// If only display open is the chosen display - continue
			else if display.self === chosenDisplay.self {
				continue
			}

			// Otherwise, close display because it isn't chosen
			else {
				display.hide()
			}
		}
	}

	// MARK: - Connected Monitor Functions

	/// This checks the connected monitors and makes sure they match the ones held in memory.
	static func getConnectedMonitors() -> [ConnectedMonitor] {

		var monitors: [ConnectedMonitor] = []

		for screen in NSScreen.screens {
			let monitor = ConnectedMonitor(screen)
			monitors.append(monitor)
		}

		return monitors
	}

	/// Determines if there is a change in the connected monitors.
	func haveConnectedMonitorsChanged() -> Bool {

		let foundMonitors = Self.getConnectedMonitors()
		let connectedMonitors = connectedMonitors

		// Make sure both sets of monitors have the same count
		if foundMonitors.count != connectedMonitors.count {
			return false
		}

		// Compare the monitors held in memory to the ones found
		for (index, connectedMonitor) in connectedMonitors.enumerated() {

			// Grab ref. to the found monitor
			let foundMonitor = foundMonitors[index]

			// Check to make sure the screens are the same
			if (connectedMonitor.screen != foundMonitor.screen) || (connectedMonitor.dimensions != foundMonitor.dimensions) {
				return false
			}
		}

		// Otherwise the monitors held in memory are valid
		return true
	}

	/// Issues updates to the monitors.
	func updateMonitors() {

		// Reassign monitors and snap points
		if haveConnectedMonitorsChanged() == false {
			print("🖥 MONITORS & SNAP ZONES REASSIGNED")
			connectedMonitors = Self.getConnectedMonitors()
			allSnapPoints = Self.getAllSnapPoints(connectedMonitors)
		}

		// Re-snap any detached displays
		guard let chosenDetachedDisplay = findChosenDisplay() as? DetachedDisplay else {
			return
		}

		chosenDetachedDisplay.refresh()
	}

	// MARK: - Detached Display Functions

	/// Snaps the currently chosen display.
	func snapDisplays(_ event: NSEvent?) {

		// Bail if this event doesn't even have a window
		guard let eventWindow = event?.window else {
			return
		}

		// Get the chosen display and...
		// make sure it conforms to the detached display protocol
		guard let chosenDetachedDisplay = findChosenDisplay() as? DetachedDisplayProtocol else {
			return
		}

		// Make sure the drag is being applied to our window
		guard eventWindow == chosenDetachedDisplay.window() else {
			return
		}

		// Snap it
		chosenDetachedDisplay.snap()
	}

	/// This generates a set of snap zones for any given physical monitor.
	static func getAllSnapPoints(_ connectedMonitors: [ConnectedMonitor]) -> [SnapPoint] {

		// Make sure we have the connected monitors
		let monitors = connectedMonitors

		var snapPoints: [SnapPoint] = []

		// Collects all snap zone collections from each monitor
		for monitor in monitors {
			let monitorsSnapPoints = monitor.getSnapPoints()
			snapPoints.append(contentsOf: monitorsSnapPoints)
		}

		return snapPoints
	}

	/// This finds the closest snap point to the display.
	/// Returns nil if no point is found.
	func closestSnapPointSearch(_ frame: NSRect) -> SnapPointSearch? {

		let snapPoints = appDelegate.displayController.allSnapPoints

		// Collect display's points
		let displayPoints = FramePoint.getPoints(frame: frame)

		// This will hold our sort information
		var closestPoint: SnapPointSearch?

		// Cycle snap zones and see which zone the display is in
		for snapPoint in snapPoints {

			// Find the corresponding point
			guard let displayPoint = FramePoint.getCorrespondingPoint(displayPoints, snapPoint.position) else {
				return nil
			}

			// Find the distance
			let foundDistance = snapPoint.distance(displayPoint.point)

			// Determine if the shortest distance ref. has been filled
			if closestPoint == nil {
				closestPoint = SnapPointSearch(snapPoint, displayPoints, foundDistance)
			}

			// Otherwise see if there is a new shortest distance
			else if let _shortestDistance = closestPoint?.distance, foundDistance < _shortestDistance {
				closestPoint = SnapPointSearch(snapPoint, displayPoints, foundDistance)
			}
		}

		// Save the snap point for future snaps or sessions
		closestPoint?.snapPointFound.save()

		return closestPoint
	}

	/// Find the saved snap point.
	func findSavedSnapPoint() -> SnapPoint {

		// Get the snap point - If the snap point is nil, return the default value
		guard let snapPoint = SnapPoint.read() else {
			return getDefaultSnapPoint()
		}

		// Validate that the snap point exists
		guard allSnapPoints.contains(where: { $0.origin == snapPoint.origin }) == true else {
			return getDefaultSnapPoint()
		}

		// Return the snap point
		return snapPoint
	}

	/// Gets the default snap point.
	func getDefaultSnapPoint() -> SnapPoint {

		// Get the first monitor and use that to get the default point
		let primaryMonitor = connectedMonitors[0]

		// Get the default point
		return primaryMonitor.getDefaultPoint()
	}

	// MARK: - Universal Display Functions
	
	

	/// This pulls in the selection data from the chosen display and returns it.
	func findCurrentSelection() -> SelectionData? {
		let chosenDisplay = findChosenDisplay()
		return chosenDisplay.selectionData
	}

	/// Picks out the chosen display (float, panel, etc.) using the setting held in memory.
	func findChosenDisplay() -> Display {
		let chosenDisplay = appDelegate.settings.settingChosenDisplay
		return pickDisplay(chosenDisplay)
	}

	/// These are all the displays used within the app.
	func findAllDisplays() -> [Display]? {

		guard let statusDisplay = appDelegate.statusDisplay else {
			return nil
		}

		guard let floatDisplay = appDelegate.floatDisplay else {
			return nil
		}

		return [
			statusDisplay,
			floatDisplay,
		]
	}
	
	/// Simply lets you know the open status of the window.
	func isDisplayOpen() -> Bool? {
		
		guard let chosenDisplay = findChosenDisplay() as? DetachedDisplay else {
			return false
		}
		
		return chosenDisplay.isOpen
	}

	/// Formats selection data in a line.
	func formatSelectionAsFields(_ data: SelectionData, _ info: SelectionInfo) -> [SelectionField]? {

		// Convert the data to a list
		let selection = data.toListOfFields()

		// If the selection is empty abort
		if selection.isEmpty {
			return nil
		}

		// Holds formatted selection
		var line: [SelectionField] = []

		// Otherwise build the line
		for (index, item) in selection.enumerated() {

			// Place item
			line.append(item)

			// Then divider if this isn't the last item
			if (selection.count - 1) != index {
				line.append(SelectionField(value: ContentManager.Labels.divider, type: .Divider))
			}
		}

		// Add in a loading indicator if the selection is still loading
		if appDelegate.dataDirector.isSelectionLoading(info.id) {
			line.append(SelectionField(value: nil, type: .LoadingIndicator))
		}

		// Return the built line
		return line
	}

	/// Formats the selection data in a one line string.
	func formatSelectionAsString(_ data: SelectionData, _ info: SelectionInfo, spaceAtEnd: Bool) -> String? {

		// Convert the data to a list of strings
		var selection = data.toListOfStrings()

		// If the selection is empty abort
		if selection.isEmpty {
			return nil
		}

		// Add in a loading indicator if the selection is still loading
		if appDelegate.dataDirector.isSelectionLoading(info.id) {
			selection.append(ContentManager.Labels.findingItems)
		}

		// Add in the dividers
		var line = selection.joined(separator: ContentManager.Labels.divider)

		// Adds a space at the end if required
		if spaceAtEnd == true {
			line.append(" ")
		}

		// Return the built line
		return line
	}
}
