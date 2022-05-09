//
//  LinkHelper.swift
//  Informant
//
//  Created by Ty Irvine on 2021-08-08.
//

import Foundation
import SwiftUI

class LinkHelper {

	/// Opens a link in the default browser.
	static func openLink(link: String) {
		if let url = URL(string: link) {
			NSWorkspace.shared.open(url)
		}
	}

	/// Opens a file in preview.
	static func openPDF(link: String) {
		if let url = Bundle.main.url(forResource: link, withExtension: "pdf") {
			NSWorkspace.shared.open(url)
		}
	}
}

#warning("Add in remaining links")
extension String {

	static let linkTwitter = "https://twitter.com/_tyirvine"

	static let linkDonate = "https://github.com/sponsors/tyirvine"

	static let linkPrivacyPolicy = "https://github.com/tyirvine/Informant#privacy-policy"

	static let linkFeedback = "https://github.com/tyirvine/Informant/issues/new/choose"

	static let linkReleases = "https://github.com/tyirvine/Informant/releases"

	static let linkHelp = "https://github.com/tyirvine/Informant#frequently-asked-questions"

	static let linkAcknowledgements = "https://github.com/tyirvine/Informant#acknowledgements"

	static let linkEULA = "https://informant.so/eula"
}
