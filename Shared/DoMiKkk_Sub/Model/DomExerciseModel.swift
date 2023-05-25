//
//  DomExerciseModel.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 15.01.2022.
//

import SwiftUI


class DomMode: ObservableObject {
	@Published var tonic: Int = 66
	@Published var domSet: Set<DomikStep> = [.Yo, .uZo, .dZo]
}


class DomExerciseModel: TaskReceiver, ObservableObject, ModelProtocol {
	func getPanelSubView() -> AnyView {
		AnyView( DomContextPanelView(model: self) )
	}
	func getMainView(geometry: GeometryProxy) -> AnyView {
		AnyView( DoMiKkkMainView(geometry: geometry, model: self) )
	}
	
	private let mainVoice = MIDIVoice()
	private let taskRunner = TaskRunner()
	
	private var state: ExerciseModelState = .undef {
		didSet {
			processStateTransition( state, from: oldValue)
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
	private var quest: DomResolver
	private var scaleRandomizer: DomScaleRandomizer
	private var singleStepCounter: Int = 0
	
	
	@Published var playedStep: DomikStep?
	@Published var stepUpdater: Int = 0
	@Published var isSingleStepAnswer: Bool = false {
		didSet {
			if isSingleStepAnswer {
				singleStepCounter = 0
			}
		}
	}
	@Published var isFreezed: Bool = false
	@Published var isMultiOctave: Bool = false {
		didSet {
			scaleRandomizer.isMultiOctave = isMultiOctave
		}
	}
	
	var scaleSet:Set<DomikStep> {
		get {
			scaleRandomizer.scaleSet
		}
		set {
			scaleRandomizer.scaleSet = newValue
			stepUpdater += 1
			state = .undef
		}
	}
	var scaleInfo:DomScaleRandomizer {
		get {
			scaleRandomizer
		}
	}
	
	func getState() -> ExerciseModelState {
		state
	}
	
	func startExercise() {
		print("restart questioning..")
		goodCounter = 0
		badCounter = 0
		scaleRandomizer.isMultiOctave = isMultiOctave
		reGenerateQuest()
		state = .startPhase
	}
	func playTonic() {
		guard state != .undef else {return}
		state = .playTonic
	}
	func playQuest() {
		guard state != .undef else {return}
		state = .playQuest
	}
	func checkAnswer(withStep: DomikStep) {
		guard state == .waitAnswer else {return}
		print("checkAnswer")
		if withStep == quest.step {
			scaleRandomizer.changeProgressOf(aStep: withStep, up: true)
			state = .getCorrectAnser
			return
		}
		scaleRandomizer.changeProgressOf(aStep: withStep, up: false)
		state = .getIncorrectAnswer
	}
	
	init( withDomMode: DomMode, andLStatusBar: LStatusBarProtocol ) {
		print("DomExerciseModel INIT..")
		
		lStatusBar = andLStatusBar
		scaleRandomizer = DomScaleRandomizer(withStepSet: withDomMode.domSet, withTonic: withDomMode.tonic)
		quest = DomResolver(aTonic: withDomMode.tonic, aStep: .Yo)
		state = .undef
		
		taskRunner.receiver = self
		reloadMainVoiceSF()
	}
	deinit {
		self.state = .undef
		taskRunner.abort()
		taskRunner.receiver = nil
		
		print("..DEINIT DomExerciseModel")
	}
	func reloadMainVoiceSF() {
		mainVoice?.load( fileName: audioSetup.instrumentName )
	}

	private func processStateTransition(_ aState: ExerciseModelState, from oldState: ExerciseModelState) {
		var taskList: [TaskItem] = []
		
		switch (aState, oldState) {
		case (.startPhase, _):
			taskList.append(contentsOf: quest.getTonic(onVoice: mainVoice))
			taskList.append(PauseTask(withNoteLength:.half))
			taskList.append(contentsOf: quest.getQuest(onVoice: mainVoice))
		case (.waitAnswer, .startPhase):
			print("statistics begining")
			
		case (.waitAnswer, .playTonic), (.waitAnswer, .playQuest), (.waitAnswer, .getIncorrectAnswer):
			break
			
		case (.playTonic, _):
			taskList.append(contentsOf: quest.getTonic(onVoice: mainVoice))
			
		case (.playQuest, _):
			taskList.append(contentsOf: quest.getQuest(onVoice: mainVoice))
			
		case (.getIncorrectAnswer, .waitAnswer):
			badCounter += 1
			taskList.append(PauseTask(withNoteLength:.zero))
			print("statistics should go worse")
			
		case (.getCorrectAnser, .waitAnswer):
			print("statistics should go better")
			goodCounter += 1
			if isSingleStepAnswer {
				singleStepCounter += 1
			}
			taskList.append( contentsOf: isSingleStepAnswer ? quest.getQuest(onVoice: mainVoice) : quest.getAnswer(onVoice: mainVoice) )
			taskList.append(PauseTask(withNoteLength:.half))
			
		case (.waitAnswer, .waitAnswer):
			print("retap :-/.. just ignore it")
			return
			
		default:
			print("default XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
		}
		taskRunner.runOver(tasks: taskList)
		
	}
	
	
	
	internal func onTaskEvent( aCount: Int, anIndex: Int, current: TaskItem?, previous: TaskItem? ) {
		playedStep = nil
		if let noteTask = current as? NoteTask {
			if state == .getCorrectAnser {
				playedStep = DomikStep(relativeInterval: noteTask.rawNote.midiNote - quest.midiTonic )
			}
		}
	}
	internal func onTasksEnded( forced: Bool ) {
		switch state {
		case .undef:
			print("state = \(state)")
		case .startPhase:
			print("state = \(state)")
			state = .waitAnswer
		case .playTonic, .playQuest, .getIncorrectAnswer:
			state = .waitAnswer
		case .waitAnswer:
			break
		case .getCorrectAnser:
			stepUpdater += 1
			scaleRandomizer.isMultiOctave = isMultiOctave
			reGenerateQuest()
			isMultiOctave = scaleRandomizer.isMultiOctave
			state = .playQuest
		}
	}
	
	fileprivate func reGenerateQuest() {
		var newQuest: (step:DomikStep, tonic: Int)
		if isSingleStepAnswer {
			if singleStepCounter >= 3 {
				singleStepCounter = 0
				newQuest = (step: .Yo, tonic: quest.midiTonic)
			}else{
				newQuest = scaleRandomizer.extractRandomStep( autoLVLup: !isFreezed )
				if newQuest.step == .Yo {
					newQuest = scaleRandomizer.extractRandomStep( autoLVLup: !isFreezed )
				}
			}
		}else{
			newQuest = scaleRandomizer.extractRandomStep( autoLVLup: !isFreezed )
		}

		quest = DomResolver(aTonic: newQuest.tonic, aStep: newQuest.step)
	}
}

fileprivate func rndOctaveAround( aTonic: Int ) -> Int {
	let currOct = aTonic % 12
	return Int.random(in: (5-currOct)...(8-currOct))
}

