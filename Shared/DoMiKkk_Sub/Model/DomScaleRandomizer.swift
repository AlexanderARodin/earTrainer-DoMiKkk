//
//  DomScaleRandomizer.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 17.01.2022.
//


class DomScaleRandomizer {
	private var scaleSetStats: [DomikStep:StepStats] = [:]
	private var tonicRandomizer: TonicRandomizer
	private var shuffledSequence: [DomikStep] = []

	var scaleSet: Set<DomikStep> {
		get {
			var result = Set<DomikStep>()
			for item in scaleSetStats.keys {
				result.insert(item)
			}
			return result
		}
		set {
			scaleSetStats.removeAll()
			for step in newValue {
				scaleSetStats[step] = StepStats()
			}
			makeShuffleSequence()
		}
	}

	private var lastAddedStep: DomikStep? = nil
	var isMultiOctave: Bool = false
	
	
	
	init( withStepSet:Set<DomikStep>, withTonic: Int ) {
		tonicRandomizer = TonicRandomizer( mainTonic: withTonic )
		scaleSet = withStepSet
		makeShuffleSequence()
	}
	convenience init(withTonic: Int) {
		self.init(withStepSet: [.Yo, .dZo, .uZo], withTonic: withTonic)
	}
	
	
	
	func extractRandomStep( autoLVLup: Bool = true ) -> (step:DomikStep, tonic: Int) {
		if shuffledSequence.isEmpty {
			fillShuffledSequence( autoLVLup: autoLVLup )
		}
		let resultStep = shuffledSequence.first
		if resultStep != .uZo && resultStep != .dZo && isMultiOctave {
			tonicRandomizer.stepToNext()
		}
		let resultTonic = isMultiOctave ? tonicRandomizer.top : tonicRandomizer.mainTonic
		
		shuffledSequence.remove(at: 0)
		if resultStep != nil {
			return (resultStep!, resultTonic)
		}
		return (.Yo, resultTonic)
	}
	
	fileprivate func fillShuffledSequence( autoLVLup: Bool = true ) {
		if isReadyToLvLup() && autoLVLup {
			doLvLup()
		}
		makeShuffleSequence()
	}
	
	fileprivate func makeShuffleSequence() {
		var result: [DomikStep] = []
		for item in scaleSet {
			for _ in 1...numFor(aStep:item) {
				result.append(item)
			}
		}
		result.shuffle()
		for _ in 0...result.count {
			reArrange(stepSeq: &result)
			result.reverse()
		}
		reArrange(stepSeq: &result)
		if result.last != .Yo {
			result.append(.Yo)
		}
		if result.first == .Yo {
			result.remove(at: 0)
		}
		if let lstStep = lastAddedStep {
			if result.first != lstStep {
				result.insert(lstStep, at: 0)
			}
			lastAddedStep = nil
		}
		shuffledSequence = result
	}
	
	
	func isReadyToLvLup() -> Bool {
		for item in scaleSetStats.values {
			if item.success < 0.95 {
				return false
			}
		}
		return true
	}
	
	func doLvLup() {
		print("lvlUP")
		resetLearnStepsStat( with: 0.5 )
		if insert(aStep: .Le) {return}
		if insert(aStep: .Ti) {return}
		if insert(aStep: .Vi) {return}
		if insert(aStep: .Ra) {return}
		if insert(aStep: .Na) {return}
		if insert(aStep: .Vu) {return}
		if insert(aStep: .Ru) {return}
		if insert(aStep: .Tu) {return}
		if insert(aStep: .Ni) {return}
		if insert(aStep: .Lu) {return}
		
		if isMultiOctave {return}
		isMultiOctave = true
		resetLearnStepsStat( with: 0.25 )
	}
	
	func changeProgressOf( aStep: DomikStep, up: Bool) {
		guard var wght = scaleSetStats[aStep]?.success else {return}
		if up {
			wght += 0.45
		}else{
			wght -= 0.33
		}
		if wght > 1 {
			wght = 1
		}
		if wght < 0 {
			wght = 0
		}
		scaleSetStats[aStep]?.success = wght
	}
	func getProgressOf( aStep: DomikStep ) -> Double {
		guard let result = scaleSetStats[aStep]?.success else {return 0}
		return result
	}
	
	private func insert( aStep: DomikStep ) -> Bool {
		guard !scaleSet.contains(aStep) else {return false}
		lastAddedStep = aStep
		scaleSetStats[aStep] = StepStats()
		return true
	}
	
	
	private func resetLearnStepsStat( with: Double ) {
		for step in scaleSetStats.keys {
			scaleSetStats[step]?.success = with
		}
	}
}


fileprivate struct StepStats {
	var success: Double = 0
	//var weight: Double = 1
}

fileprivate func numFor(aStep:DomikStep) -> Int{
		switch aStep {
		case .Yo:
			return 1
		case .uZo, .dZo:
			return 2
		default:
			return 2
		}
}

fileprivate func reArrange( stepSeq: inout [DomikStep] ) {
	guard stepSeq.count >= 3 else {return}
	
	for ind in 1..<(stepSeq.count-1) {
		if stepSeq[ind] == stepSeq[ind-1] {
			let a = stepSeq[ind]
			let b = stepSeq[ind+1]
			stepSeq[ind+1] = a
			stepSeq[ind] = b
		}
	}
}
