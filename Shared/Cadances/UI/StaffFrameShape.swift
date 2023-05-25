//
//  StaffFrameShape.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 18.01.2022.
//

import SwiftUI


struct StaffFrameShape: Shape {
	let appendLines: Bool
	let verticalLine: Bool
	
	func path(in rect: CGRect) -> Path {
		var path = Path()
		let deltaY = (rect.maxY - rect.minY) / 16.0
		let deltaX = (rect.maxX - rect.minX) / 5.0
		for line in 1...15 {
			let curY = rect.minY + deltaY * CGFloat(line)
			var stX: CGFloat
			var enX: CGFloat
			switch line {
			case 1, 2, 8, 14, 15:
				stX = rect.minX + deltaX
				enX = rect.maxX - deltaX
				if appendLines {
					inserLineInPath( &path, stX: stX, enX: enX, curY: curY )
				}
			default:
				stX = rect.minX
				enX = rect.maxX
				inserLineInPath( &path, stX: stX, enX: enX, curY: curY )
			}
		}
		if verticalLine {
			//
		}
		return path
	}
	
	private func inserLineInPath( _ path: inout Path, stX: CGFloat, enX: CGFloat, curY: CGFloat ) {
		path.move(to: CGPoint(x: stX, y: curY) )
		path.addLine(to: CGPoint(x: enX, y: curY) )
	}
}



