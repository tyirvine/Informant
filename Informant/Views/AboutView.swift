//
//  AboutView.swift
//  Informant
//
//  Created by Ty Irvine on 2022-02-21.
//

import SwiftUI

struct AboutView: View {
	
	var version: String
	
	init() {
		if let version = AppDelegate.version() {
			self.version = version
		} else {
			self.version = "--"
		}
	}
	
	var body: some View {
		RootView {
			
			// Used to apply a global padding
			VStack(spacing: 2) {
			
				// Top header
				VStack(spacing: 0) {
				
					// Image
					Image(ContentManager.Images.appIconNoShadow)
						.resizable()
						.frame(width: 130, height: 130)
						.offset(x: 0, y: 5)
				
					VStack(spacing: 4) {
					
						// Title
						Text("Informant")
							.H2(weight: .medium)
						
						// Version & Copyright
						HStack(spacing: 11) {
							Text("\(ContentManager.Labels.menubarShowVersion) \(version)")
							Text("© Ty Irvine")
						}
						.opacity(0.5)
					}
				}
				
				Spacer()
					.frame(height: 12)
				
				// Middle stack
				VStack(alignment: .leading, spacing: 2) {
					
					// Acknowledgements
					ComponentsPanelLabelButton {
						LinkHelper.openLink(link: .linkAcknowledgements)
					} content: {
						ComponentsWindowLargeLink(label: ContentManager.Labels.acknowledgements, icon: "shippingbox", iconSize: 20)
					}
				
					// Privacy
					ComponentsPanelLabelButton {
						LinkHelper.openLink(link: .linkPrivacyPolicy)
					} content: {
						ComponentsWindowLargeLink(label: ContentManager.Labels.privacyPolicy, icon: "rectangle.3.group.bubble.left", iconSize: 19)
					}
						
					// Divider
					Divider()
						.padding([.vertical], 10)

					// Releases
					ComponentsPanelLabelButton {
						LinkHelper.openLink(link: .linkReleases)
					} content: {
						ComponentsWindowLargeLink(label: ContentManager.Labels.releases, icon: "laptopcomputer.and.arrow.down")
					}
				}
			}
			.padding([.horizontal], 20)
		}
		.frame(width: 280, height: 390, alignment: .center)
	}
}
