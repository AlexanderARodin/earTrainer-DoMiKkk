//
//  DomCadance.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 21.01.2022.
//

struct DomCadance {
	let midiTonic: Int
	let stepA: DomikStep
	let stepB: DomikStep

	
	func getTonic( onVoice: MIDIVoice? ) -> NoteTask {
		let tonic = RawNote(midiTonic, withLength: .half, withVolume: .din)
		return NoteTask(rawNote: tonic, voice: onVoice)
	}
	func getAll( onVoice: MIDIVoice? ) -> [NoteTask] {
		let A = RawNote(midiTonic + stepA.getToTonicInterval(), withLength: .half, withVolume: .di)
		let B = RawNote(midiTonic + stepB.getToTonicInterval(), withLength: .half, withVolume: .li)
		let tonic = RawNote(midiTonic, withLength: .half, withVolume: .din)
		return [NoteTask(rawNote: A, voice: onVoice), NoteTask(rawNote: B, voice: onVoice), NoteTask(rawNote: tonic, voice: onVoice)]
	}
}
