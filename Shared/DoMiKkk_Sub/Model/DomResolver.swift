//
//  DomResolver.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 15.01.2022.
//


struct DomResolver {
	let midiTonic: Int
	let step: DomikStep
	
	init( aTonic: Int, aStep: DomikStep ) {
		self.midiTonic = aTonic
		self.step = aStep
	}
	
	func getTonic( onVoice: MIDIVoice? ) -> [NoteTask] {
		let tonic = RawNote(midiTonic, withLength: .half, withVolume: .din)
		return [NoteTask(rawNote: tonic, voice: onVoice)]
	}
	func getQuest( onVoice: MIDIVoice? ) -> [NoteTask] {
		return [NoteTask(rawNote: RawNote(midiTonic + step.getToTonicInterval(), withLength: .per4, withVolume: .di), voice: onVoice)]
	}
	func getAnswer( onVoice: MIDIVoice? ) -> [NoteTask] {
		let tonic = RawNote(midiTonic, withLength: .half, withVolume: .din)
		var result = NoteSequence()
		switch step {
		case .uZo:
			result = result.addRawNote(
				RawNote(midiTonic + step.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
		case .Ni:
			result = result.addRawNote(
				RawNote(midiTonic + step.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
			result = result.addRawNote(
				RawNote(midiTonic + DomikStep.uZo.getToTonicInterval(), withLength: .per8, withVolume: .di)
			)
			result = result.addRawNote(
				RawNote(midiTonic + DomikStep.dZo.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
		case .Na:
			result = result.addRawNote(
				RawNote(midiTonic + step.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
			result = result.addRawNote(
				RawNote(midiTonic + DomikStep.uZo.getToTonicInterval(), withLength: .per8, withVolume: .di)
			)
			result = result.addRawNote(
				RawNote(midiTonic + DomikStep.dZo.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
		case .Vi:
			result = result.addRawNote(
				RawNote(midiTonic + step.getToTonicInterval(), withLength: .per8, withVolume: .di)
			)
			result = result.addRawNote(
				RawNote(midiTonic + DomikStep.Le.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
		case .Vu:
			result = result.addRawNote(
				RawNote(midiTonic + step.getToTonicInterval(), withLength: .per8, withVolume: .di)
			)
			result = result.addRawNote(
				RawNote(midiTonic + DomikStep.Le.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
		case .Le:
			result = result.addRawNote(
				RawNote(midiTonic + step.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
		case .Lu:
			result = result.addRawNote(
				RawNote(midiTonic + step.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
		case .Yo:
			break
		case .Ti:
			result = result.addRawNote(
				RawNote(midiTonic + step.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
		case .Tu:
			result = result.addRawNote(
				RawNote(midiTonic + step.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
		case .Ra:
			result = result.addRawNote(
				RawNote(midiTonic + step.getToTonicInterval(), withLength: .per8, withVolume: .di)
			)
			result = result.addRawNote(
				RawNote(midiTonic + DomikStep.dZo.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
		case .Ru:
			result = result.addRawNote(
				RawNote(midiTonic + step.getToTonicInterval(), withLength: .per8, withVolume: .di)
			)
			result = result.addRawNote(
				RawNote(midiTonic + DomikStep.dZo.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
		case .dZo:
			result = result.addRawNote(
				RawNote(midiTonic + step.getToTonicInterval(), withLength: .per8, withVolume: .li)
			)
		}
		
		result = result.addRawNote(
			RawNote(tonic.midiNote, withLength: .per4, withVolume: .din)
		)
		var resultArray: [NoteTask] = []
		for item in result.sequence {
			resultArray.append(NoteTask(rawNote: item, voice: onVoice ) )
		}
		return resultArray
	}
}

