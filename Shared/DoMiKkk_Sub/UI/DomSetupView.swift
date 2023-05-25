//
//  DomSetupView.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 16.01.2022.
//

import SwiftUI


fileprivate func getKeyTuple(from i: Int) -> (String, Int) {
	return (midiNoteName(from: i), i)
}
fileprivate let rootKeyList:[(String, Int)] = [
	getKeyTuple(from: 77),
	getKeyTuple(from: 71),
	getKeyTuple(from: 64),
	getKeyTuple(from: 57),
	getKeyTuple(from: 50),
	getKeyTuple(from: 43)
]



struct DomSetupView: View {
	@Binding var popup:Bool
	@ObservedObject var model: DomExerciseModel
	
	var body: some View {
		
		VStack{
			Spacer()
			HStack {
				Spacer()
				VStack(alignment: .leading) {
					Label("tonic", systemImage: "tuningfork")
					Text("      F5")
					Text("      H4")
					Text("F#4")
					Text("      E4")
					Text("      A3")
					Text("      D3")
					Text("      G2")
				}
				.padding()
				.border(.red)
				Spacer()
				Divider()
				//Spacer()
					VStack {
					Label("scale", systemImage: "music.note.list")
					VStack(spacing: 0) {
						ForEach(-7 ..< 6){
							let ind = -$0
							let preStep = DomikStep(relativeInterval: ind)
							let isActive = model.scaleSet.contains(preStep)
								ZStack{
									DomBlock(step: preStep, isActive: isActive, isPlayed: false, onClick: onClick(_:))
								}
						}
						//.border(.green)
					}
					.frame(width:100, height:500)
					.scaleEffect(0.5)
					.border(.red)
				}
				Spacer()
				VStack{
					Text("Chrom").onTapGesture {
						model.scaleSet = domSet_Chrom
					}
					Text("min").onTapGesture {
						model.scaleSet = domSet_MIN
					}
					Text("MAJ").onTapGesture {
						model.scaleSet = domSet_MAJ
					}
					Text("Simple").onTapGesture {
						model.scaleSet = domSet_simple
					}
					Text("Zero").onTapGesture {
						model.scaleSet = domSet_Zero
					}
				}
				Spacer()
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
				popup = false
			}
		}
	}
	private func onClick(_ step: DomikStep) {
		guard step != .Yo && step != .dZo && step != .uZo else {return}
		var curSet = model.scaleSet
		if curSet.contains(step) {
			curSet.remove(step)
		}else{
			curSet.insert(step)
		}
		model.scaleSet = curSet
	}
}


fileprivate struct TstView: View {
	@State var popup = false
	var body: some View {
		DomSetupView(popup: $popup, model: DomExerciseModel(withDomMode: DomMode(), andLStatusBar: LStatusBarModel()) )
	}
}

struct DomSetupView_Previews: PreviewProvider {
	static var previews: some View {
		TstView()
	}
}
