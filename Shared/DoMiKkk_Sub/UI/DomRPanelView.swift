//
//  DomRightPanelView.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 17.01.2022.
//

import SwiftUI

struct DomRPanelView: View {
	@ObservedObject var model: DomExerciseModel
	
	@State var scaleFreez: Double = 0.8
	@State var scaleSingleStep: Double = 0.8
	@State var rotorStar: Angle = .degrees(90)
	@State var scaleStar: Double = 0.8
	
	var body: some View {
		VStack {
			Spacer()
			Spacer()
			Image(systemName: "repeat.1" )
				.foregroundColor(model.isSingleStepAnswer ? .red : .secondary )
				.scaleEffect(scaleSingleStep)
				.animation(.linear(duration: 0.5 ), value: scaleSingleStep)
				.padding()
				.onTapGesture {
					model.isSingleStepAnswer.toggle()
					scaleSingleStep = (model.isSingleStepAnswer ? 1.2 : 0.8)
				}
			
			Image(systemName: model.isMultiOctave ? "rectangle.expand.vertical" : "rectangle.compress.vertical" )
				.foregroundColor(model.isMultiOctave ? .red : .secondary)
				.rotationEffect(rotorStar)
				.animation(.linear(duration: 0.5 ), value: rotorStar)
				.scaleEffect(scaleStar)
				.animation(.linear(duration: 1 ), value: scaleStar)
				.padding()
				.onTapGesture {
					model.isMultiOctave.toggle()
					rotorStar += .degrees(model.isMultiOctave ? 90 : -90)
					scaleStar = (model.isMultiOctave ? 1.2 : 0.8)
				}
			Image(systemName: model.isFreezed ? "pin.fill" : "pin.slash" )
				.foregroundColor(model.isFreezed ? .accentColor : .secondary )
				.scaleEffect(scaleFreez)
				.animation(.linear(duration: 0.5 ), value: scaleFreez)
				.padding()
				.onTapGesture {
					model.isFreezed.toggle()
					scaleFreez = (model.isFreezed ? 1.2 : 0.8)
				}
			
			Spacer()
		}
		.font(.largeTitle)
	}
}

struct DomRPanelView_Previews: PreviewProvider {
	static var previews: some View {
		DomRPanelView( model: DomExerciseModel(withDomMode: DomMode(), andLStatusBar: LStatusBarModel()) )
	}
}
