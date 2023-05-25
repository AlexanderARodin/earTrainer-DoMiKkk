//
//  DomScales.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 19.01.2022.
//

import Foundation


enum DomScales: String, CaseIterable {
	case majorNatural = "Major (Ionian)"
	case minorNatural = "Minor (Aeolian)"
	case majorHarmonic = "Major (Harmonic)"
	case minorHarmonic = "Minor (Harmonic)"
	case dorian = "Dorian"
	case phrygian = "Phrygian"
	case lydian = "Lydian"
	case mixolydian = "Mixolydian"
	case chromatic = "Chromatic"
	
	func getDomScaleSet() -> Set<DomikStep> {
		var result = domSet_Zero
		
		switch self {
		case .majorNatural:
			result = domSet_MAJ
		case .minorNatural:
			result = domSet_MIN
		case .majorHarmonic:
			result = domSet_MAJ
			result.remove(.Ra)
			result.insert(.Ru)
		case .minorHarmonic:
			result = domSet_MIN
			result.remove(.Tu)
			result.insert(.Ti)
		case .dorian:
			result = domSet_MIN
			result.remove(.Ru)
			result.insert(.Ra)
		case .phrygian:
			result = domSet_MIN
			result.remove(.Le)
			result.insert(.Lu)
		case .lydian:
			result = domSet_MAJ
			result.remove(.Na)
			result.insert(.Ni)
		case .mixolydian:
			result = domSet_MAJ
			result.remove(.Ti)
			result.insert(.Tu)
		case .chromatic:
			return domSet_Chrom
		}
		
		return result
	}
}

func getSorted( scaleSet: Set<DomikStep>) -> [DomikStep] {
	return scaleSet.sorted(by: { a,b in a.rawValue > b.rawValue })
}


let domSet_Zero: Set<DomikStep> =											[.Yo, .uZo, .dZo]
let domSet_simple: Set<DomikStep> =			domSet_Zero.union(		[.Ti, .Le]						)
let domSet_MAJwoIV: Set<DomikStep> =		domSet_simple.union(		[.Vi, .Ra]						)
let domSet_MAJ: Set<DomikStep> =				domSet_MAJwoIV.union(	[.Na]								)
let domSet_MIN: Set<DomikStep> =				domSet_Zero.union(		[.Tu, .Le, .Vu, .Ru, .Na]	)
let domSet_Chrom: Set<DomikStep> =			domSet_MAJ.union(
																domSet_MIN.union(	[.Ni, .Lu]						))

