//
//  ContextSuperPanelView.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 14.01.2022.
//

import SwiftUI

struct ContextSuperPanelView: View {
	@ObservedObject var rootState: RootStateOject
//	@State var setupPopUp:Bool = false
	
	var body: some View {
		VStack(spacing:5){
			HStack(alignment: .center, spacing: 0) {
				Spacer()
				rootState.getPanelSubView()
					.font(.largeTitle)
				Spacer()
//				Divider().frame(maxHeight: 20)
//				Image(systemName: "gear")
//					.onTapGesture {setupPopUp.toggle()}
//					.font(.title)
//					.padding(.leading)
//					.padding(.trailing)
			}
		}
		.shadow(color: .primary, radius: 5, x: 3, y: 3)
		.padding(.bottom, 5)
		.frame(minWidth: 200, alignment: .leading)
		//.clipped()
		
//		.sheet(isPresented: $setupPopUp, onDismiss: {}) {
//			AudioSetupView(popup: $setupPopUp)
//		}
	}
}

struct ContextSuperPanelView_Previews: PreviewProvider {
	static var previews: some View {
		ContextSuperPanelView(rootState: RootStateOject())
	}
}
