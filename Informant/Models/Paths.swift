//
//  SelectionModel.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-23.
//

import Foundation

public enum PathState {
	case PathDuplicate
	case PathAvailable
	case PathUnavailable
	case PathError
}

/// This is just an object that allows us to send error information along with the urls
struct Paths {

	let paths: [String]?
	let state: PathState?

	internal init(paths: [String]?, state: PathState? = nil) {
		self.paths = paths
		self.state = state
	}
}
