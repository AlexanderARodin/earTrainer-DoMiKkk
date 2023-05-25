//
//  DomSteps.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 15.01.2022.
//

import SwiftUI

enum DomikShapeType {
	case upTriangle
	case downTriangle
	case simpleSquare
}


enum DomikStep: Int {
	case uZo	=	19 // 7
	case Ni	=	18 // 6
	case Na	=	17 // 5
	case Vi	=	16 // 4
	case Vu	=	15 // 3
	case Le	=	14 // 2
	case Lu	=	13 // 1
	case Yo	=	12 // 0
	case Ti	=	11 //-1
	case Tu	=	10 //-2
	case Ra	=	 9 //-3
	case Ru	=	 8 //-4
	case dZo	=	 7 //-5
	
	init( relativeInterval: Int) {
		var interval: Int = relativeInterval % 12
		if interval > 7 {
			interval -= 12
		}else if interval < -5 {
			interval += 12
		}
		switch interval {
		case 7:
			self = .uZo
		case 6:
			self = .Ni
		case 5:
			self = .Na
		case 4:
			self = .Vi
		case 3:
			self = .Vu
		case 2:
			self = .Le
		case 1:
			self = .Lu
		case 0:
			self = .Yo
		case -1:
			self = .Ti
		case -2:
			self = .Tu
		case -3:
			self = .Ra
		case -4:
			self = .Ru
		case -5:
			self = .dZo
			
		default:
			self = .Yo
		}
	}
	
	func getToTonicInterval() -> Int {
		return rawValue - 12
	}
	
	func color() -> Color {
		switch self {
		case .uZo, .dZo:
			return .init(red: 173.0/255, green: 1, blue: 47.0/255)
		case .Ni:
			return .init(red: 1, green: 36.0/255, blue: 0)
		case .Na:
			return .init(red: 46.0/255, green: 232.0/255, blue: 187.0/255)
		case .Vi:
			return .init(red: 1, green: 165.0/255, blue: 0)
		case .Vu:
			return .init(red: 0, green: 0, blue: 1)
		case .Le:
			return .init(red: 253.0/255, green: 233.0/255, blue: 16.0/255) //253 233 16
		case .Lu:
			return .init(red: 0.5, green: 0, blue: 0.5)
		case .Yo:
			return .init(red: 173.0/255/2, green: 1.0/2, blue: 47.0/255/2)
		case .Ti:
			return .init(red: 0.8, green: 0, blue: 0)
		case .Tu:
			return .init(red: 128.0/255, green: 166.0/255, blue: 1) //128 166 255
		case .Ra:
			return .init(red: 0.85, green: 0.8, blue: 0)
		case .Ru:
			return .init(red: 0.5, green: 0, blue: 1)
		}
	}
	
	func name() -> String {
		switch self {
		case .uZo, .dZo:
			return "Зо"
		case .Ni:
			return "Ни"
		case .Na:
			return "На"
		case .Vi:
			return "Ви"
		case .Vu:
			return "Ву"
		case .Le:
			return "Ле"
		case .Lu:
			return "Лу"
		case .Yo:
			return "Ë" //"йО"
		case .Ti:
			return "Ти"
		case .Tu:
			return "Ту"
		case .Ra:
			return "Ра"
		case .Ru:
			return "Ру"
		}
	}
	
	func shapeType() -> DomikShapeType {
		switch self {
		case .uZo, .dZo, .Yo:
			return .simpleSquare
		case .Ni, .Vi, .Ti, .Ra, .Le:
			return .upTriangle
		case .Na, .Vu, .Tu, .Ru, .Lu:
			return .downTriangle
		}
	}
}



func getDomikStep(fromStepName name: String) -> DomikStep? {
	switch name {
	case "uZo", "Zo", "Зо":
		return .uZo
	case "Ni", "Ни":
		return .Ni
	case "Na", "На":
		return .Na
	case "Vi", "Ви":
		return .Vi
	case "Vu", "Ву":
		return .Vu
	case "Le", "Ле":
		return .Le
	case "Lu", "Лу":
		return .Lu
	case "Yo", "Ë", "ё":
		return .Yo
	case "Ti", "Ти":
		return .Ti
	case "Tu", "Ту":
		return .Tu
	case "Ra", "Ра":
		return .Ra
	case "Ru", "Ру":
		return .Ru
	case "dZo":
		return .dZo
	default:
		return nil
	}
}
