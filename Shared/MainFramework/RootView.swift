//
//  RootView.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 16.01.2022.
//

import SwiftUI


struct RootView: View {
	@StateObject private var rootState = RootStateOject()
	
	var body: some View {
		HStack() {
			LeftPanelView(rootState: rootState)
			Divider().scaleEffect(x: 10)
			VStack() {
				HStack(spacing:0) {
					if rootState.state != .info {
						GeometryReader { g in
							rootState.getLStatusBarView(geometry: g)
						}
						.frame(width: rootState.getLStatusBarWidth())
					}
					GeometryReader { g in
						rootState.getMainView( geometry: g )
					}
				}
				Divider().scaleEffect(y: 5)
					.background(Color.accentColor)
				ContextSuperPanelView(rootState: rootState)
			}
		}
	}
}




fileprivate let preWidth: CGFloat = 600
fileprivate let preHeight: CGFloat = 400

struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		RootView()
			.previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
		RootView()
			.previewLayout(.fixed(width: preWidth, height: preHeight))
		//		RootView()
		//			.previewDevice(PreviewDevice(rawValue: "iPhone 8"))
		//		RootView()
		//			.previewDevice(PreviewDevice(rawValue: "iPad mini (6th generation)"))
	}
}
