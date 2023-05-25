//
//  CadanceCntxPanelView.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 18.01.2022.
//

import SwiftUI



struct CadanceCntxPanelView: View {
	@ObservedObject var model: CadanceModel
	@State var domSetupPupUp: Bool = false
	
	var body: some View {
		HStack(spacing: 0){
			Group {
				let isStateUndef = ( model.getState() == .undef )
				Image(systemName: "tuningfork")
					.disabled(isStateUndef)
					.scaleEffect(isStateUndef ? 0.6 : 1)
					.foregroundColor(isStateUndef ? .secondary : .primary)
					.onTapGesture {
						model.playTonic()
					}
				Spacer()
				Image(systemName: "livephoto.play")
					.scaleEffect(isStateUndef ? 2 : 1.5)
					.onTapGesture {
						model.startExcersise()
					}
				Spacer()
				Image(systemName: "ear")
					.disabled(isStateUndef)
					.scaleEffect(isStateUndef ? 0.6 : 1)
					.foregroundColor(isStateUndef ? .secondary : .primary)
					.onTapGesture {
						model.playQuest()
					}
				Spacer()
			}
			Spacer()
			Divider().frame(maxHeight: 20).padding(.trailing)
			Image(systemName: "ellipsis.circle")
				.foregroundColor(.secondary)
				.onTapGesture {
					domSetupPupUp.toggle()
				}
		}
		.sheet(isPresented: $domSetupPupUp, onDismiss: {}) {
			Toggle("close", isOn: $domSetupPupUp)
				.padding()
//			DomSetupView(popup: $domSetupPupUp, model: model)
		}
	}
}

struct CadanceCntxPanelView_Previews: PreviewProvider {
	static var previews: some View {
		CadanceCntxPanelView(model: CadanceModel(withLStatusBar: LStatusBarModel()))
	}
}
