//
//  DoMiKkkView.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 15.01.2022.
//

import SwiftUI

fileprivate let preWidth: CGFloat = 170
fileprivate let preHeight: CGFloat = 70


struct DoMiKkkView: View {
	let scaleSet:Set<DomikStep>
	let fromStep:Int
	let toStep:Int
	let playedStep:DomikStep?
	//
	@Binding var clickedStep: DomikStep?
	weak var scaleInfo:DomScaleRandomizer?
	
	var body: some View {
		VStack(spacing: 0) {
			ForEach(-toStep ..< (-fromStep+1)){
				let ind = -$0
				let preStep = DomikStep(relativeInterval: ind)
				let isPlayed:Bool = preStep == playedStep
				let isActive = scaleSet.contains(preStep)
				let wght:Double = (scaleInfo != nil) ? scaleInfo!.getProgressOf(aStep: preStep) : 0
				if ind <= 7 && ind >= -5 {
					ZStack{
						DomBlock(step: preStep, isActive: isActive, isPlayed: isPlayed, onClick: onClick(_:))
							.disabled(!isActive)
						HStack{
							Spacer()
							if isActive {
								Image(systemName: getNameFor(wght))
									.padding(2)
									.foregroundColor(.black)
									.background(Color.gray)
									.clipShape(Capsule())
									.rotationEffect(.degrees(-90))
									.scaleEffect(1.5)
								//Text("\(wght)")
							}
						}
						
					}
				}else {
					DomBlock(step: preStep, isActive: false, isPlayed: false, onClick: nil)
						.disabled(true)
						.opacity(0.3)
				}
			}
		}
		.frame(width: preWidth * 1.3,height: CGFloat(toStep-fromStep ) * (70 + 2) )
		.clipped()
		//.fixedSize()
		.scaledToFill()
	}
	private func onClick(_ step: DomikStep) {
		clickedStep = step
	}
}

fileprivate func getNameFor( _ aSuccess: Double ) -> String {
	if aSuccess >= 0.90 {
		return "battery.100"
	}
	if aSuccess >= 0.66 {
		return "battery.75"
	}
	if aSuccess >= 0.33 {
		return "battery.50"
	}
	if aSuccess >= 0.10 {
		return "battery.25"
	}
	
	return "battery.0"
}




fileprivate struct tmp: View {
	@State var tmp: DomikStep?
	
	var body: some View {
		DoMiKkkView(scaleSet: domSet_MAJ, fromStep: -6, toStep: 12, playedStep: .Ni, clickedStep: $tmp)
	}
}


struct DoMiKkkView_Previews: PreviewProvider {
	static var previews: some View {
		tmp()
			.border(.red)
			.previewLayout(.fixed(width: preWidth*2.5, height: preHeight*20))
			.padding()
		tmp()
			.previewDevice(PreviewDevice(rawValue: "iPhone 8 Plus"))
		tmp()
			.previewLayout(.fixed(width: 600, height: 400))
	}
}
