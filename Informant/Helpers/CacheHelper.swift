//
//  DispatchQueueHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2021-06-25.
//

import Foundation
import UniformTypeIdentifiers

/// Stores each url's byte size at a specific time stamp
class Cache {

	// Cache object
	fileprivate var cache: [URL: CachedItem] = [:]

	/// Stores the provided bytes into the cache at the position of the url using it as the key.
	func store(url: URL, bytes: Int64) {

		let types: [UTType] = [
			.application,
			.directory
		]

		guard let type = DataUtility.getSelectionTypeSingle(path: url.path, types: types) else {
			return
		}

		cache[url] = CachedItem(bytes: bytes, type: type)
	}

	/// Retrieves the cached item at the provided url.
	func get(url: URL) -> CachedItem? {

		// Gets the object out of the cache
		guard let item = cache[url] else {
			return nil
		}

		// Checks to make sure it's not expired before returning
		if item.isExpired() {
			return nil
		}

		print("💾 Cache Hit: \(item.bytes.formatBytes())")

		return item
	}

	/// Erases the cache item at the provided url.
	func erase(url: URL) {
		cache.removeValue(forKey: url)
	}

	/// This object will tell you when a directory's cache size is expired as well as the size of the directory in bytes.
	struct CachedItem {

		var expiry: TimeInterval
		var bytes: Int64

		internal init(bytes: Int64, type: SelectionType) {
			self.bytes = bytes

			// Get timestamp created
			let created = Date().timeIntervalSince1970
			var interval: TimeInterval = 0

			// Find expiry by adding specified time to created time
			switch type {

			// Expiry is 10 minutes for applications
			case .Application: interval = (60 * 10)
				break

			// Expiry is 10 seconds for directories
			case .Directory: interval = 10
				break

			default:
				break
			}

			// Set final expiry
			expiry = created + interval
		}

		/// Checks if the object is valid
		func isExpired() -> Bool {

			// Get the current timestamp
			let now = Date().timeIntervalSince1970

			// Compare it to the old timestamp
			if now >= expiry {
				return true
			}

			return false
		}
	}
}
