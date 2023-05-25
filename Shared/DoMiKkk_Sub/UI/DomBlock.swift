//
//  DomBlock.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 15.01.2022.
//

import SwiftUI

fileprivate let preWidth: CGFloat = 200
fileprivate let preHeight: CGFloat = 70


fileprivate let strokeStylePlayed = StrokeStyle(lineWidth: 7, lineJoin: .round, dash: [15,15])
fileprivate let strokeStyleInactive = StrokeStyle(lineWidth: 2)//, lineJoin: .round, dash: [20,10])


struct DomBlock: View {
	let step: DomikStep
	let isActive: Bool
	let isPlayed: Bool
	var onClick: ((_ step: DomikStep)->Void)? = nil
	
	
	var body: some View {
		//Button(action: {onClick?(step)})
		Group{
			GeometryReader { g in
				HStack {
					Spacer()
					VStack {
						Spacer()
						ZStack {
							if isActive {
								DomFillView(step: step, dimensions: g.size)
							}
							if isPlayed {
								DomPlayedFrameView(step: step, dimensions: g.size)
							}else{
								if !isActive {
									DomInActiveFrameView(step: step, dimensions: g.size)
								}
							}
							DomTextView(step: step, isActive: isActive, dimensions: g.size)
						}
						Spacer()
					}
					Spacer()
				}
			}
		}
		.onTapGesture {
			onClick?(step)
		}
		.frame(width: preWidth, height: preHeight)
		.fixedSize()
		//.border(.red)
	}
}

struct DomFillView: View {
	let step: DomikStep
	let dimensions: CGSize
	
	var body: some View {
		DomShape(shapeType: step.shapeType())
			.foregroundColor(step.color())
			.scaleEffect(x: 1.1, y: 1.25)
	}
}

struct DomInActiveFrameView: View {
	let step: DomikStep
	let dimensions: CGSize
	
	var body: some View {
		DomShape(shapeType: step.shapeType())
			.stroke(style: strokeStyleInactive)
			.foregroundColor(step.color())
			.scaleEffect(x: 1.07, y: 1.2)
	}
}

struct DomPlayedFrameView: View {
	let step: DomikStep
	let dimensions: CGSize
	
	var body: some View {
		DomShape(shapeType: step.shapeType())
			.stroke(style: strokeStylePlayed)
			.foregroundColor(.gray)
			.scaleEffect(x: 1.1, y: 1.3)
	}
}




fileprivate let hOffst = 0.06

struct DomTextView: View {
	let step: DomikStep
	let isActive: Bool
	let dimensions: CGSize
	
	
	var body: some View {
		HStack {
			Spacer()
			VStack {
				Spacer()
				if isActive {
					Text(step.name())
						.bold()
				}else{
					Text(step.name())
						.italic()
						.scaleEffect(0.6)
				}
				Spacer()
			}
			.offset(y: step.shapeType() == .upTriangle ? dimensions.height * hOffst : 0)
			.offset(y: step.shapeType() == .downTriangle ? -dimensions.height * hOffst : 0)
			Spacer()
		}
		.foregroundColor(isActive ? .black : step.color())
		.scaleEffect(2.5)
	}
}




struct DomBlock_Previews: PreviewProvider {
	static var previews: some View {
		HStack {
			DomBlock(step: .Yo, isActive: false, isPlayed: false)
			DomBlock(step: .dZo, isActive: true, isPlayed: true)
		}
		.previewLayout(.fixed(width: preWidth*5, height: preHeight*3))
		.padding()
		HStack {
			DomBlock(step: .Le, isActive: false, isPlayed: true)
			DomBlock(step: .Na, isActive: true, isPlayed: false)
		}
		.previewLayout(.fixed(width: preWidth*5, height: preHeight*3))
		.padding()
	}
}
