//
//  InfoView.swift
//  DoMiKkk_4.00
//
//  Created by the Dragon on 13.01.2022.
//

import SwiftUI


class InfoModel: ModelProtocol {
	
	func getPanelSubView() -> AnyView {
		AnyView( HStack{} )
	}
	
	func getMainView(geometry: GeometryProxy) -> AnyView {
		return AnyView( InfoView(geometry: geometry) )
	}
}

fileprivate struct InfoView: View {
	let geometry: GeometryProxy
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("size: \(Int(geometry.size.width)) x \(Int(geometry.size.height))")
			Spacer()
			Text("ABOUT:\nhttp://brainin.org")
				.padding()
			Text("in Moscow:\nhttp://moscow.brainin.org")
				.padding()
			Text("on FB:\nhttps://www.facebook.com/groups/110746525627977/")
				.padding()
			Text("on VK:\nhttps://vk.com/moscowbrainin")
				.padding()
			Spacer()
		}
	}
}





fileprivate struct TstView: View {
	var body: some View {
		GeometryReader { g in
			InfoView(geometry: g)
		}
	}
}

struct InfoView_Previews: PreviewProvider {
	static var previews: some View {
		TstView()
	}
}
