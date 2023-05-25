//
//  Cadance_MainView.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 18.01.2022.
//

import SwiftUI

fileprivate let strokeStyleLine = StrokeStyle(lineWidth: 1)


struct Cadance_MainView: View {
	let geometry: GeometryProxy
	@ObservedObject var model: CadanceModel
	@State var step_A: DomikStep = .Yo
	@State var step_B: DomikStep = .Yo
	@State var step_C: DomikStep = .dZo
	
	var body: some View {
		HStack {
			Spacer()
			VStack {
				Spacer()
				HStack {
					SubDomView(theStep: $step_A, scaleSet: model.scaleSet)
						.disabled(model.getState() != .waitAnswer)
					SubDomView(theStep: $step_B, scaleSet: model.scaleSet)
						.disabled(model.getState() != .waitAnswer)
					SubDomView(theStep: $step_C, scaleSet: [.Yo])
						.disabled(model.getState() != .waitAnswer)
				}
				.frame(width: 300, height: 500)
				.scaleEffect(x:0.45,y:0.5)
				Spacer()
			}
			Spacer()
		}
		.onChange(of: step_C) {newValue in
			if step_C == .Yo {
				model.checkAnswer(withStepA: step_A, andStepB: step_B)
			}
		}
		.onChange(of: model.updateCounter) {newValue in
			switch model.getState() {
			case .startPhase:
				step_A = .Yo
				step_B = .Yo
				step_C = .dZo
			case .getIncorrectAnswer, .waitAnswer:
				step_C = .dZo
			default:
				break
			}
		}
	}
}

struct SubDomView: View {
	@Binding var theStep: DomikStep
	let scaleSet: Set<DomikStep>
	
	var body: some View {
		VStack {
			ForEach( -7..<6, id: \.self ) {stepRelVar in
				let stepArg = DomikStep(relativeInterval: -stepRelVar)
				let isVisible = scaleSet.contains(stepArg)
				let isPlayed = (stepArg == theStep)
				if isVisible {
					DomBlock(step: stepArg, isActive: true, isPlayed: isPlayed, onClick: {step in theStep = step})
				}else{
					DomBlock(step: stepArg, isActive: false, isPlayed: false, onClick: {step in })
						.hidden()
				}
			}
		}
	}
}






fileprivate struct TstView: View {
	var body: some View {
		GeometryReader { g in
			Cadance_MainView(geometry: g, model: CadanceModel(withLStatusBar: LStatusBarModel()))
		}
	}
}

struct Cadance_MainView_Previews: PreviewProvider {
	static var previews: some View {
		TstView()
	}
}
