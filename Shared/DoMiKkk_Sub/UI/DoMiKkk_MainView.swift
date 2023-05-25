//
//  DoMiKkk_MainView.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 15.01.2022.
//

import SwiftUI

fileprivate let h2wRatio: Double = 4.4

struct DoMiKkkMainView: View {
	let geometry: GeometryProxy
	@ObservedObject var model: DomExerciseModel
	@ObservedObject var audioCfg = audioSetup
	@State private var clickedStep: DomikStep?

	var body: some View {
		HStack(alignment: .center) {
//			Rectangle()//Spacer()
//				.frame(minWidth:5, maxWidth: 5)
			DoMiKkkView(scaleSet: model.scaleSet,fromStep: -6 + model.stepUpdater * 0, toStep: 8, playedStep: model.playedStep, clickedStep: $clickedStep, scaleInfo: model.scaleInfo)
				.frame(width: getDomHeigth() / h2wRatio, height: getDomHeigth())
				.scaleEffect(geometry.size.height * 0.001)
				.shadow(color: .white.opacity(0.7), radius: 10, x: 5, y: 5)
				.shadow(color: .black.opacity(0.85), radius: 10, x: 5, y: 5)
			Divider().padding(.leading)
			DomRPanelView(model: model)
			//
			Spacer()
				.frame(minWidth:100, maxWidth: 200)
		}
		.onChange(of: clickedStep) { _ in
			guard clickedStep != nil else {return}
			model.checkAnswer( withStep: clickedStep! )
			clickedStep = nil
		}
		.onChange(of: audioCfg.instrumentName) { _ in
			model.reloadMainVoiceSF()
		}
	}
	
	private func getDomHeigth() -> Double {
		if geometry.size.height < geometry.size.width * h2wRatio {
			return geometry.size.height
		}
		return geometry.size.width * h2wRatio
	}
}





fileprivate struct TstView: View {
	var body: some View {
		GeometryReader { g in
			DoMiKkkMainView(geometry: g, model: DomExerciseModel(withDomMode: DomMode(), andLStatusBar: LStatusBarModel()) )
		}
	}
}

struct DoMiKkk_MainView_Previews: PreviewProvider {
	static var previews: some View {
		TstView()
	}
}
