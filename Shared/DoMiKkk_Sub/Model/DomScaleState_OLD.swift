//
//  DomScaleState.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 15.01.2022.
//


class DomScaleState_OLD {
	private var scaleSetStats: [DomikStep:StepStats] = [:]
	private var lastAddedStep: DomikStep? = nil
	private var shuffledSequence: [DomikStep] = []
	private var tonicRandomizer: TonicRandomizer
	var isMultiOctave: Bool = false
	var scaleSet: Set<DomikStep> {
		get {
			var result = Set<DomikStep>()
			for item in scaleSetStats.keys {
				result.insert(item)
			}
			return result
		}
	}
	
	init( withStepSet:Set<DomikStep>, withTonic: Int ) {
		tonicRandomizer = TonicRandomizer( mainTonic: withTonic )
		for step in withStepSet {
			scaleSetStats[step] = StepStats()
		}
		makeShuffleSequence()
		reFreshStats()
	}
	convenience init(withTonic: Int) {
		self.init(withStepSet: [.Yo, .dZo, .uZo], withTonic: withTonic)
	}
	

	func extractRandomStep( autoLVLup: Bool = true ) -> DomikStep {
		if shuffledSequence.isEmpty {
			fillShuffledSequence( autoLVLup: autoLVLup )
		}
		let result = shuffledSequence.first
		shuffledSequence.remove(at: 0)
		if result != nil {
			return result!
		}
		return .Yo
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
		//result = [.Yo, .Yo, .dZo, .uZo, .dZo, .Yo, .Yo]
		for _ in 0...result.count {
			reArrange(stepSeq: &result)
			result.reverse()
		}
		reArrange(stepSeq: &result)
		if result.last != .Yo {
			result.append(.Yo)
		}
		//		if result.first != .Yo {
		//			result.insert(.Yo, at: 0)
		//		}
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
		//print("isReadyToLvLup ????\n\(scaleSet.description)")
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
		reFreshStats()
		return true
	}
	
	private func reFreshStats() {
		print("reFreshStats ????")
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
	return 1
	//	switch aStep {
	//	case .Yo:
	//		return 1
	//	case .uZo:
	//		return 2
	//	case .dZo:
	//		return 3
	//	case .Le:
	//		return 3
	//	case .Vi:
	//		return 4
	//	case .Vu:
	//		return 4
	//	case .Ra:
	//		return 4
	//	case .Ru:
	//		return 4
	//	case .Ti:
	//		return 5
	//	case .Tu:
	//		return 5
	//	case .Na:
	//		return 4
	//	case .Ni:
	//		return 4
	//	case .Lu:
	//		return 5
	//	}
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
