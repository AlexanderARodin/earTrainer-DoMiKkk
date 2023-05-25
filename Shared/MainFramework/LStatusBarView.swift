//
//  LStatusBarView.swift
//  DoMiKkk_5.00
//
//  Created by the Dragon on 23.01.2022.
//

import SwiftUI

struct LStatusBarView: View {
	let geometry: GeometryProxy
	let width: Double
	@ObservedObject var model: LStatusBarModel

	var body: some View {
		VStack(spacing: 0.2) {
			Rectangle()
				.foregroundColor(.red)
				.frame(height: model.badHeightFraction * geometry.size.height)
			Rectangle()
				.foregroundColor(.gray.opacity(0.3))
			Rectangle()
				.foregroundColor(.green)
				.frame(height: model.goodHeightFraction * geometry.size.height)
		}
//		.frame(minWidth: 5, maxWidth: width)
		.opacity(0.8)
	}
}

fileprivate struct TstView: View {
	var body: some View {
		GeometryReader { g in
			LStatusBarView(geometry: g, width: 10, model: LStatusBarModel())
		}
	}
}

struct LStatusBarView_Previews: PreviewProvider {
	static var previews: some View {
		TstView()
	}
}
