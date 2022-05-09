//
//  Styling.swift
//  Informant
//
//  Created by Ty Irvine on 2021-04-22.
//

import SwiftUI

/// Contains all styling constants to be used across app
class Style {
	public enum Text {
		static let opacity = 0.5
		static let darkOpacity = 0.7
		static let fontSFCompact = "SFCompactDisplay-Regular"
		static let fontSFMono = "SFMono-Regular"
	}

	public enum Button {
		static let labelButtonOpacity = 0.8
	}

	public enum Color {
		static let backing = "Backing"
	}

	public enum Icons {
		static let appIconSize: CGFloat = 100
	}

	public enum Menu {
		static let juicyImageHeight: CGFloat = 26
		static let juicyImageWidth: CGFloat = 26
	}

	public enum Animation {
		static let standard = 0.15
	}
}

extension Text {

	func H1(weight: Font.Weight = .regular, linelimit: Int? = nil) -> some View {
		self.font(.system(size: 36))
			.fontWeight(weight)
			.lineLimit(linelimit)
	}

	func H2(weight: Font.Weight = .regular, linelimit: Int? = nil) -> some View {
		self.font(.system(size: 28))
			.fontWeight(weight)
			.lineLimit(linelimit)
	}
	
	func H3X(weight: Font.Weight = .regular, linelimit: Int? = nil) -> some View {
		self.font(.system(size: 21))
			.fontWeight(weight)
			.lineLimit(linelimit)
	}

	func H3(weight: Font.Weight = .regular, linelimit: Int? = nil) -> some View {
		self.font(.system(size: 20))
			.fontWeight(weight)
			.lineLimit(linelimit)
	}

	func H4(weight: Font.Weight = .regular, linelimit: Int? = nil) -> some View {
		self.font(.system(size: 17))
			.fontWeight(weight)
			.lineLimit(linelimit)
	}

	func Body(weight: Font.Weight = .regular, linelimit: Int? = nil, alignment: TextAlignment = .leading) -> some View {
		self.font(.system(size: 14))
			.fontWeight(weight)
			.lineLimit(linelimit)
			.lineSpacing(4.0)
			.multilineTextAlignment(alignment)
			.fixedSize(horizontal: false, vertical: true)
	}

	// MARK: Specialty Styles ⤵︎

	func floatDisplayActionFont() -> some View {
		self.font(.system(size: 12))
			.fontWeight(.medium)
			.opacity(0.5)
	}
}
