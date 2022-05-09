//
//  DataUtility.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

class DataUtility {

	/// This function will take in a url string and provide a url resource values object which can be
	/// then used to grab info, such as name, size, etc. Returns nil if nothing is found
	static func getURLResources(_ url: URL, _ keys: Set<URLResourceKey>) -> URLResourceValues? {
		do {
			return try url.resourceValues(forKeys: keys)
		}
		catch {
			return nil
		}
	}

	/// Used to grab the metadata for an image on a security scoped url
	static func getURLImageMetadata(_ url: URL) -> NSDictionary? {
		if let source = CGImageSourceCreateWithURL(url as CFURL, nil) {
			if let dictionary = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) {
				return dictionary as NSDictionary
			}
		}

		return nil
	}

	/// Used to grab all metadata for a movie on a security scoped url
	static func getURLMetadata(
		_ url: URL,
		_ keys: NSArray = [
			kMDItemCodecs!,
			kMDItemDurationSeconds!,
			kMDItemProfileName!,
			kMDItemColorSpace!,
			kMDItemPixelWidth!,
			kMDItemPixelHeight!,
			kMDItemAudioSampleRate!,
			kMDItemVersion!,
		]
	) -> [CFString: Any]? {

		if let mdItem = MDItemCreateWithURL(kCFAllocatorDefault, url as CFURL) {
			if let metadata = MDItemCopyAttributes(mdItem, keys) as? [CFString: Any] {
				return metadata
			}
		}

		return nil
	}

	/// Determines the selection type of a single item.
	static func getSelectionTypeSingle(
		path: String,
		types: [UTType] = [
			.image,
			.movie,
			.audio,
			.application,
			.volume,
			.directory,
		]
	) -> SelectionType? {

		// TODO: I'd consider removing this section
//		// Finds the root volume path and removes it in order to get a volume selection.
//		// For some reason a normal volume path with the root drive isn't accepted.
//		guard let rootDrivePath = FileManager.default.getRootVolumeAsPath else {
//			return nil
//		}
//
//		if path == rootDrivePath {
//			url = URL(fileURLWithPath: "/")
//		}
//
//		// Otherwise the url is assigned normally
//		else {
//			url = URL(fileURLWithPath: path)
//		}

		/// This is the selection's URL
		let url = URL(fileURLWithPath: path)

		// The resources we want to find
		let keys: Set<URLResourceKey> = [
			.contentTypeKey,
		]

		// Grabs the UTI type id and compares that to all the types we want to identify
		guard let resources: URLResourceValues = Self.getURLResources(url, keys) else {
			return nil
		}

		// Cast the file's uniform type identifier
		guard let uti = resources.contentType else {
			return nil
		}

		/// Stores the uti this selection conforms to
		var selectionType: UTType?

		// Cycle all the types and identify the file's type
		for type in types {
			if type == uti || type.isSupertype(of: uti) {
				selectionType = type
				break
			}
		}

		// Confirm a valid UTType was found. Otherwise just return .Single
		guard let selectionType = selectionType else {
			return .Single
		}

		// Now that we have the uniform type identifier, let's return the matching type
		switch selectionType {

			case .directory: return .Directory

			case .application: return .Application

			case .image: return .Image

			case .movie: return .Movie

			case .audio: return .Audio

			case .volume: return .Volume

			default: return .Single
		}
	}
}
