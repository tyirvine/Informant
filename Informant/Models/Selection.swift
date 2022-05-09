//
//  Selection.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-23.
//

import Foundation

/// Used to indicate generalized selection type.
public enum SelectionType {
	case None
	case Error
	case Duplicate
	case Single
	case Multi
	case Directory
	case Application
	case Volume
	case Image
	case Movie
	case Audio
}

/// Used to transfer selections.
struct Selection {
	let type: SelectionType
	let info: SelectionInfo?
	let data: SelectionData?
}

/// Useful information that can influence how data is displayed.
public struct SelectionInfo {

	/// Just a ref. to the app's delegate.
	let appDelegate: AppDelegate

	/// This is the url that points to the selection.
	var url: URL {
		return urls[0]
	}

	/// Used to store a collection of urls.
	var urls: [URL]

	/// Used to hold a type.
	var type: SelectionType

	/// Selection id.
	var id: String = UUID().uuidString

	/// Used to identify the selection during async operations for size.
	var jobIDSize: String = UUID().uuidString

	/// Used to identify the selection during async operations.
	var jobIDMain: String = UUID().uuidString

	/// Determines if the file has the .icloud extension.
	var isiCloudSyncFile: Bool?

	/// Determines if the file is marked hidden. Hidden files have a period in front of them.
	var isHidden: Bool?
}

/// Used to model data for any type of selection.
struct SelectionData {

	/// This contains all selection data.
	var data: [String: String?]

	/// This tells us whether or not the data is loading, completed, error'd out, etc.
	private var state: [SelectionDataState]

	init(_ data: [String: String?] = [:]) {

		// Initialize data
		self.data = data
		self.state = []
	}

	/// Returns all display data as a list filtered for nil values and anything that's not just text.
	func toListOfStrings() -> [String] {

		var list: [String] = []

		// Cycle all fields and only add approved types
		for field in toList() {

			// Make sure the value is valid
			guard let value = field.value else {
				continue
			}

			// Only add types that are text based
			switch field.type {

				case .URL:
					list.append(value)
					break

				case .Text:
					list.append(value)
					break

				default:
					break
			}
		}

		// Removes all nils
		return list.compactMap { $0 }
	}

	/// Returns all fields with their corresponding field type.
	func toListOfFields() -> [SelectionField] {
		return toList()
	}

	/// Merges another selection display data struct with this one.
	func merge(with: Self) -> Self {

		var mergedData = data
		mergedData.merge(with.data, uniquingKeysWith: { _, b in b })

		var newSelection = SelectionData()
		newSelection.data = mergedData

		return newSelection
	}

	/// Provides the selection as a list of typed selection fields.
	private func toList() -> [SelectionField] {

		var list: [SelectionField] = []

		// Cycle all fields
		for (key, _) in Settings.defaultSettingsOrdered {
			if let value = data[key] as? String {

				// Hold field type
				let fieldType: SelectionFieldType

				// Determine field type
				switch key {
					case .keyShowPath:
						fieldType = .URL
						break

					default:
						fieldType = .Text
						break
				}

				// Build the field
				let field = SelectionField(value: value, type: fieldType)

				// Add it to the list
				list.append(field)
			}
		}

		// Removes all nils and exit
		return list.compactMap { $0 }
	}
}

/// Used to indicate state.
enum SelectionDataState {
	case Loading
}

/// Used to carry additional functionality to the field view.
struct SelectionField {
	let value: String?
	let type: SelectionFieldType
	let id: String = UUID().uuidString
}

/// Used to define a selection field.
enum SelectionFieldType {
	case Divider
	case LoadingIndicator
	case Text
	case URL
}
