//
//  FloatDisplayFieldLoader.swift
//  Informant
//
//  Created by Ty Irvine on 2022-04-21.
//

import SwiftUI

struct FloatDisplayFieldLoaderView: View {
	var body: some View {
		VStack {
			ProgressView()
				.scaleEffect(0.55)
		}
		.frame(width: 20, height: 20)
		.padding([.leading], 10)
	}
}
