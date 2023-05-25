//
//  CadanceModel.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 18.01.2022.
//

import SwiftUI


class CadanceModel: TaskReceiver, ObservableObject, ModelProtocol {
	func getPanelSubView() -> AnyView {
		AnyView( CadanceCntxPanelView(model: self) )
	}
	func getMainView(geometry: GeometryProxy) -> AnyView {
		AnyView( Cadance_MainView(geometry: geometry, model: self) )
	}
	
	private var state: ExerciseModelState = .undef {
		didSet {
			processStateTransition( state, from: oldValue)
			updateCounter += 1
		}
	}
	private var lStatusBar: LStatusBarProtocol
	private var goodCounter: Int = 0 {
		didSet {
			lStatusBar.setStats(goodCounter: goodCounter, badCounter: badCounter)
		}
	}
	private var badCounter: Int = 0 {
		didSet {
			lStatusBar.setStats(goodCounter: goodCounter, badCounter: badCounter)
		}
	}
	private let mainVoice = MIDIVoice()
	private let taskRunner = TaskRunner()
	private var tonicMode: Int = 0
	private var scale: DomScales = .majorNatural
	
	private var cadance: DomCadance
	var scaleSet:Set<DomikStep> {
		get {
			scale.getDomScaleSet()
		}
	}
	func getState() -> ExerciseModelState {
		return state
	}
	@Published var updateCounter: Int = 0
	
	init( withLStatusBar: LStatusBarProtocol ) {
		print("CadanceModel INIT..")
		
		lStatusBar = withLStatusBar
		//scaleRandomizer = DomScaleRandomizer(withStepSet: withDomMode.domSet, withTonic: withDomMode.tonic)
		cadance = DomCadance(midiTonic: 66, stepA: .Yo, stepB: .Yo)
		state = .undef
		
		taskRunner.receiver = self
		reloadMainVoiceSF()
	}
	deinit {
		self.state = .undef
		taskRunner.abort()
		taskRunner.receiver = nil
		
		print("..DEINIT CadanceModel")
	}
	func reloadMainVoiceSF() {
		mainVoice?.load( fileName: audioSetup.instrumentName )
	}
	
	
	func startExcersise() {
		goodCounter = 0
		badCounter = 0
		cadance = DomCadance(midiTonic: cadance.midiTonic, stepA: .Yo, stepB: .Yo)
		state = .startPhase
	}
	func playTonic() {
		state = .playTonic
	}
	func playQuest() {
		state = .playQuest
	}
	func checkAnswer(withStepA step_A: DomikStep, andStepB step_B: DomikStep) {
		guard state == .waitAnswer else {return}
		print("checkAnswer")
		if step_A == cadance.stepA && step_B == cadance.stepB  {
			//scaleRandomizer.changeProgressOf(aStep: withStep, up: true)
			state = .getCorrectAnser
			return
		}
		//scaleRandomizer.changeProgressOf(aStep: withStep, up: false)
		state = .getIncorrectAnswer
	}

	
	private func processStateTransition(_ aState: ExerciseModelState, from oldState: ExerciseModelState) {
		var taskList: [TaskItem] = []
		
		switch (aState, oldState) {
		case (.startPhase, _):
			taskList.append(cadance.getTonic(onVoice: mainVoice))
			taskList.append(PauseTask(withNoteLength:.half))
			print("startPhase")
		case (.waitAnswer, .startPhase):
			print("statistics begining")
			
		case (.waitAnswer, .playTonic), (.waitAnswer, .playQuest), (.waitAnswer, .getIncorrectAnswer):
			break
			
		case (.playTonic, _):
			taskList.append(cadance.getTonic(onVoice: mainVoice))
			print("playTonic")

		case (.playQuest, _):
			taskList.append(contentsOf: cadance.getAll(onVoice: mainVoice))
			print("playQuest")

		case (.getIncorrectAnswer, .waitAnswer):
			badCounter += 1
			taskList.append(PauseTask(withNoteLength:.zero))
			print("statistics should go worse")
			
		case (.getCorrectAnser, .waitAnswer):
			print("statistics should go better")
			goodCounter += 1
			taskList.append(contentsOf: cadance.getAll(onVoice: mainVoice))
			taskList.append(PauseTask(withNoteLength:.half))
			
		case (.waitAnswer, .waitAnswer):
			print("retap :-/.. just ignore it")
			return
			
		default:
			print("default XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
		}
		taskRunner.runOver(tasks: taskList)
		
	}

	
	func onTasksEnded(forced: Bool) {
		switch state {
		case .undef:
			print("state = \(state)")
		case .startPhase:
			print("state = \(state)")
			state = .playQuest
		case .playTonic, .playQuest, .getIncorrectAnswer:
			state = .waitAnswer
		case .waitAnswer:
			break
		case .getCorrectAnser:
			reGenerateQuest()
			state = .playQuest
		}
		updateCounter += 1
	}
	func onTaskEvent(aCount: Int, anIndex: Int, current: TaskItem?, previous: TaskItem?) {
		//
	}
	
	func reGenerateQuest() {
		print("reGenerateQuest ......... ")
		let isAorB = Bool.random()
		var subScaleSet = scaleSet
		subScaleSet.remove(isAorB ? cadance.stepA : cadance.stepB)
		let newStep = subScaleSet.randomElement() ?? .Yo
		var stepA = cadance.stepA
		var stepB = cadance.stepB
		if isAorB {
			stepA = newStep
		}else{
			stepB = newStep
		}
		cadance = DomCadance(midiTonic: cadance.midiTonic, stepA: stepA, stepB: stepB)
	}
}



