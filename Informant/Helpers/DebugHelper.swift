//
//  DebugHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-25.
//

import Foundation

public func print(_ object: Any...) {
	#if DEBUG
	for item in object {
		Swift.print(item)
	}
	#endif
}

public func print(_ object: Any) {
	#if DEBUG
	Swift.print(object)
	#endif
}
