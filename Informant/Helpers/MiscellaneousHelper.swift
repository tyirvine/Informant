//
//  MiscellaneousHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-24.
//

import Foundation

/// Used to construct a bitrate.
public enum DataSizeUnit {
	case None
	case Kb
	case Mb
}

/// Compares two values. Can fail under rare conditions.
/// https://stackoverflow.com/a/61050386/13142325
func isEqual(_ x: Any, _ y: Any) -> Bool {
	guard x is AnyHashable else { return false }
	guard y is AnyHashable else { return false }
	return (x as! AnyHashable) == (y as! AnyHashable)
}
