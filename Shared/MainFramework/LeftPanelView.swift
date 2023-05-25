//
//  LeftPanelView.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 13.01.2022.
//

import SwiftUI



struct LeftPanelView: View {
	@ObservedObject var rootState: RootStateOject
	@State var setupPopUp:Bool = false

	var body: some View {
		VStack(alignment: .center, spacing: 0) {
			VStack(spacing:10){
				Spacer()
				ForEach( RootState.allCases, id: \.self ) {st in
					Image(systemName: st.rawValue )
						.foregroundColor(rootState.state == st ? .accentColor : .primary)
						.onTapGesture {rootState.state = st}
					Spacer()
				}
				Divider().frame(maxWidth: 20).scaleEffect(y:5)
					.padding(.top)
				Image(systemName: "gear")
					.foregroundColor(.secondary)
					.onTapGesture {setupPopUp.toggle()}
			}
		}
		.font(.largeTitle)
		.sheet(isPresented: $setupPopUp, onDismiss: {}) {
			AudioSetupView(popup: $setupPopUp)
		}

	}
}


fileprivate struct TstView: View {
	@StateObject var rootState = RootStateOject()
	var body: some View {
		HStack{
			LeftPanelView(rootState: rootState)
			Spacer()
		}
	}
}

struct LeftPanelView_Previews: PreviewProvider {
	static var previews: some View {
		TstView()
	}
}

