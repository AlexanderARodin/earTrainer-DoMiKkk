//
//  DomShape.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 15.01.2022.
//

import SwiftUI


struct DomShape: Shape {
	
	let shapeType: DomikShapeType
	
	func path(in rect: CGRect) -> Path {
		switch shapeType {
		case .simpleSquare:
			return rectanglePath(rect: rect)
		case .downTriangle:
			return downTrianglePath(rect: rect)
		case .upTriangle:
			return upTrianglePath(rect: rect)
		}
	}
	
	func rectanglePath(rect: CGRect) -> Path {
		var path = Path()
		path.move(to: CGPoint(x: rect.midX, y: rect.minY))
		path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
		path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
		path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
		path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
		path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
		return path
	}
	func upTrianglePath(rect: CGRect) -> Path {
		var path = Path()
		path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
		path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
		path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
		path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
		path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
		return path
	}
	func downTrianglePath(rect: CGRect) -> Path {
		var path = Path()
		path.move(to: CGPoint(x: rect.midX, y: rect.minY))
		path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
		path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
		path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
		path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
		return path
	}
}


