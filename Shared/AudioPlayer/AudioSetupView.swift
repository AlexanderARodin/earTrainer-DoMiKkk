//
//  AudioSetupView.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 14.01.2022.
//
import SwiftUI

fileprivate let instrumentList: [String] = [
	"default",
	"Piano Grand",
	"String Marcato",
	"Organ Cathedral",
	"Trombone",
	"World Vox",
	"Soul Ahhs",
	"Soul Oohs"
]

var audioSetup = AudioSetupObject()
class AudioSetupObject: ObservableObject {
	@Published	var playingTempo: Double = 2
	@Published	var instrumentName: String = "String Marcato"
	
	//
}



struct AudioSetupView: View {
	@Binding var popup:Bool
	@ObservedObject var setup = audioSetup
	@State private var isPlaying: Bool = false
	fileprivate let player = AudioSetupPlayer()

	var body: some View {
		
		VStack{
			Spacer()
			HStack {
				VStack(alignment: .leading) {
					HStack{
						Text("playing speed:")
							.padding(.leading)
						Slider(value: $setup.playingTempo, in: 0.33...3)
							.onTapGesture(count: 2, perform: {setup.playingTempo = 1})
					}
					Divider()
					HStack{
						Text("instrument sound:")
							.padding(.leading)
						Picker("", selection: $setup.instrumentName){
							ForEach(instrumentList, id: \.self){
								Text($0)
							}
						}
						.padding()
						.border(.gray)
					}
				}
				Image(systemName: isPlaying ? "speaker.zzz.fill" : "speaker.slash")
					.font(.largeTitle)
					.padding()
					.padding(.top)
					.padding(.bottom)
					.foregroundColor(isPlaying ? .green : .yellow)
					.shadow(color: isPlaying ? .green : .gray, radius: 2, x: 2, y: 2)
					//.background(.gray) //v12
					.clipShape(Capsule())
					.padding(5)
					.shadow(color: .blue, radius: 5, x: 5, y: 5)
					.onTapGesture {
						isPlaying.toggle()
						checkSound()
					}
			}
			Divider().scaleEffect(y:10)
			ZStack {
				Rectangle().frame(height: 30)
					.foregroundColor(.secondary)
				HStack {
					Spacer()
					Image(systemName: "return" )
						.font(.body)
						.padding()
					Spacer()
				}
			}
			.shadow(color: .blue, radius: 5, x: 5, y: 5)
			.onTapGesture {
				isPlaying = false
				checkSound()
				popup = false
			}
		}
		.onChange(of: setup.instrumentName) { newInstrumentName in
			player.mainVoice?.load(fileName: setup.instrumentName)
		}
	}
	
	private func checkSound() {
		//
		print("check sound: \(isPlaying)")
		player.setStateTo( isPlaying: isPlaying)
	}
}

private class AudioSetupPlayer: TaskReceiver {
	
	let mainVoice = MIDIVoice()
	private let taskRunner = TaskRunner()
	
	func setStateTo( isPlaying: Bool ) {
		if isPlaying {
			reStartMelody()
		}else{
			taskRunner.abort()
		}
	}
	
	func reStartMelody() {
		var tasks: [TaskItem] = []
		for i in 0...7 {
			tasks.append(NoteTask(rawNote: RawNote(66 + i, withLength: .per16), voice: mainVoice))
		}
		for i in -6...4 {
			tasks.append(NoteTask(rawNote: RawNote(66 - i, withLength: .per16), voice: mainVoice))
		}
		for i in -5...(-1) {
			tasks.append(NoteTask(rawNote: RawNote(66 + i, withLength: .per16), voice: mainVoice))
		}
		taskRunner.runOver( tasks: tasks )
	}
	
	func onTasksEnded(forced: Bool) {
		//print("....... \(forced)")
		if !forced {
			reStartMelody()
		}
	}
	
	func onTaskEvent(aCount: Int, anIndex: Int, current: TaskItem?, previous: TaskItem?) {
		//
	}
	
	init() {
		print("AudioSetupPlayer init..")
		taskRunner.receiver = self
		mainVoice?.load(fileName: audioSetup.instrumentName)
	}
	deinit {
		print("DEINIT AudioSetupPlayer")
	}
}



fileprivate struct TstVeiw: View {
	@State var popup:Bool = false
	
	var body: some View {
		VStack{
			AudioSetupView(popup: $popup)
		}
	}
}

struct AudioSetupView_Previews: PreviewProvider {
	static var previews: some View {
		TstVeiw()
	}
}
