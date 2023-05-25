//
//  someToolClasses.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 14.01.2022.
//

import Foundation



fileprivate let tempoMOD: Double = 0.35

struct NoteTask: TaskItem {
	let rawNote: RawNote
	weak var voice: MIDIVoice?
	
	func startAndGetDelay() -> Double {
		voice?.startNote( UInt8(rawNote.midiNote), withVelocity: UInt8(rawNote.midiVolume) )
		return rawNote.midiLength / audioSetup.playingTempo / tempoMOD
	}
	func stop( forced: Bool ) {
		voice?.stopNote()
		if forced {
			print("######################## FORCED")
		}
	}
}

struct PauseTask: TaskItem {
	let length: Double
	init(withNoteLength: NoteRelativeLength = .zero) {
		length = withNoteLength.rawValue
	}
	func startAndGetDelay() -> Double {
		return length / audioSetup.playingTempo / tempoMOD
	}
	func stop( forced: Bool ) {
	}
}

struct DbgTask: TaskItem {
	let length: Double
	let text: String
	
	func startAndGetDelay() -> Double {
		print("startAndGetDelay - \(text)")
		return length / audioSetup.playingTempo / tempoMOD
	}
	func stop( forced: Bool ) {
		print("stop - \(text) \(forced)")
	}
}
