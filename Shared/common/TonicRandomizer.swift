//
//  TonicRandomizer.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 17.01.2022.
//

import Foundation

fileprivate let minTonic = 43
fileprivate let maxTonic = 77+1+12

class TonicRandomizer {
	let mainTonic: Int
	let allTonics: [Int]
	private var rndSequence: [Int] = []
	var top:Int {
		get {
			if let res = rndSequence.first {
				return res
			}
			reshuffle()
			let res = rndSequence.first
			return res!
		}
	}
	
	init(mainTonic theTonic: Int) {
		mainTonic = theTonic
		var resAllTonics: [Int] = []
		for oct in -10...10 {
			let altTonic = mainTonic + 12 * oct
			if altTonic >= minTonic && altTonic <= maxTonic {
				resAllTonics.append(altTonic)
			}
		}
		allTonics = resAllTonics
		reshuffle()
		if top != mainTonic {
			rndSequence.insert(mainTonic, at: 0)
		}
		rndSequence.insert(mainTonic, at: 0)
	}

	private func reshuffle() {
		rndSequence.removeAll()
		rndSequence.append(contentsOf: allTonics)
		rndSequence.append(contentsOf: allTonics)
		rndSequence.append(contentsOf: allTonics)
		rndSequence.shuffle()
		correctRepetitions()
	}
	func stepToNext() {
		if rndSequence.count <= 1 {
			reshuffle()
		}else{
			rndSequence.remove(at: 0)
		}
	}
	
	func correctRepetitions() {
		for _ in 0..<rndSequence.count {
			for i in 1..<(rndSequence.count-1) {
				if rndSequence[i] == rndSequence[i-1] {
					let a = rndSequence[i]
					rndSequence[i] = rndSequence[i+1]
					rndSequence[i+1] = a
				}
			}
		}
	}
	
}
