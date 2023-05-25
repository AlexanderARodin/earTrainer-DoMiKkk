//
//  LStatusBarModel.swift
//  DoMiKkk_5.00
//
//  Created by the Dragon on 23.01.2022.
//

import SwiftUI


fileprivate let minCounter: CGFloat = 7

protocol LStatusBarProtocol {
	func getLStatusBarView( geometry: GeometryProxy ) -> AnyView
	func setWidth( _ width: Double)
	//
	func setStats( goodCounter: Int, badCounter: Int)
	func informThub( up: Bool )
	func informLvL( up: Bool )
}


class LStatusBarModel: LStatusBarProtocol, ObservableObject {
	func getLStatusBarView(geometry: GeometryProxy) -> AnyView {
		AnyView( LStatusBarView( geometry: geometry, width: width, model: self) )
	}
	
	func setWidth(_ aWidth: Double ) {
		width = aWidth
	}
	
	func setStats( goodCounter good: Int, badCounter bad: Int ) {
		goodCounter = good
		badCounter = bad
	}
	
	func informThub(up: Bool) {
		//
	}
	
	func informLvL(up: Bool) {
		//
	}
	
	private var width: Double = 25
	private var goodCounter: Int = 0 {
		didSet {
			updateHeightFractions()
		}
	}
	private var badCounter: Int = 0 {
		didSet {
			updateHeightFractions()
		}
	}

	@Published var goodHeightFraction: CGFloat = 0
	@Published var badHeightFraction: CGFloat = 0
	func getWidth() -> Double {
		width
	}
	
	init() {
		updateHeightFractions()
	}

	
	private func updateHeightFractions() {
		var sum = CGFloat( goodCounter + badCounter )
		if sum < minCounter {
			sum = minCounter
		}
		goodHeightFraction = CGFloat(goodCounter) / sum
		badHeightFraction = CGFloat(badCounter) / sum
	}
}
