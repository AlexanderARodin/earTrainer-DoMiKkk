//
//  ModelProtocol.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 16.01.2022.
//

import SwiftUI

protocol ModelProtocol {
	func getPanelSubView() -> AnyView
	func getMainView( geometry: GeometryProxy ) -> AnyView
}

enum RootState: String, CaseIterable {
	case info = "info.circle"
	case doDoMiK = "music.house"
	case doCadances = "slider.horizontal.3"
}

class RootStateOject: ObservableObject {
	private var model: ModelProtocol? = InfoModel()
	private var lStatusBar = LStatusBarModel()

	
	@Published var state: RootState = .info {
		didSet {
			lStatusBar.setStats(goodCounter: 0, badCounter: 0)
			switch state {
			case .info:
				model = InfoModel()
			case .doDoMiK:
				model = DomExerciseModel(withDomMode: DomMode(), andLStatusBar: lStatusBar)
			case .doCadances:
				model = CadanceModel(withLStatusBar: lStatusBar)
			}
		}
	}
	
	func getPanelSubView() -> AnyView {
		guard model != nil else {return AnyView( HStack{} ) }
		return model!.getPanelSubView()
	}
	func getMainView( geometry: GeometryProxy ) -> AnyView {
		guard model != nil else {return AnyView( NilView() ) }
		return model!.getMainView(geometry: geometry)
	}
	func getLStatusBarView(geometry: GeometryProxy) -> AnyView {
		lStatusBar.getLStatusBarView(geometry: geometry)
	}
	func getLStatusBarWidth() -> Double {
		lStatusBar.getWidth()
	}
}

struct NilView: View {
	
	var body: some View {
		VStack{
			Spacer()
			HStack{
				Spacer()
				Text("nil View 😵")
				Spacer()
			}
			Spacer()
		}
	}
}

enum ExerciseModelState {
	case undef
	case startPhase
	case playTonic
	case playQuest
	case waitAnswer
	case getIncorrectAnswer
	case getCorrectAnser
	
}
