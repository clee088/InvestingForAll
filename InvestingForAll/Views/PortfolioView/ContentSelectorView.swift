//
//  ContentSelectorView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 5/3/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct ContentSelectorView: View {
	
	@State var geometry: GeometryProxy
	@Binding var selectionIndex: Int
	
    var body: some View {
		VStack {
			
			HStack {
				SelectorButton(title: "Positions", setIndex: 0, selectionIndex: self.$selectionIndex, geometry:  self.geometry)
				Spacer()
				SelectorButton(title: "Orders", setIndex: 1, selectionIndex: self.$selectionIndex, geometry: self.geometry)
			}
			
			Capsule()
				.fill(LinearGradient(gradient: Gradient(colors: [Color("Card Dark GL"), Color("Card Dark GD")]), startPoint: .leading, endPoint: .trailing))
				.frame(width: self.geometry.size.width * 0.45, height: self.geometry.size.height * 0.01, alignment: .center)
				.offset(x: self.selectionIndex == 0 ? -self.geometry.frame(in: .local).midX / 2.1 : self.geometry.frame(in: .local).midX / 2.1)
				.shadow(color: Color("Card Dark GL"), radius: 3)

		}
		.padding()
		.frame(height: self.geometry.size.height * 0.1)
		
    }
}

struct ContentSelectorView_Previews: PreviewProvider {
	
    static var previews: some View {
		
		GeometryReader { geometry in
			ContentSelectorView(geometry: geometry, selectionIndex: .constant(0))
		}
    }
}

struct SelectorButton: View {
	
	@State var title: String
	@State var setIndex: Int
	@Binding var selectionIndex: Int
	var geometry: GeometryProxy
	
	var body: some View {
		
		Button(action: {
			withAnimation(.linear) {
				self.selectionIndex = self.setIndex
			}
		}) {
			ZStack {
				
				RoundedRectangle(cornerRadius: 15)
					.fill(Color("SelectionPicker Background"))
				
				Text(self.title)
					.font(.headline)
					.fontWeight(.medium)
					.foregroundColor(Color.white)
				
			}
		}
		.frame(width: self.geometry.size.width * 0.45, height: self.geometry.size.height * 0.05, alignment: .center)
		.shadow(color: Color("SelectionPicker Background").opacity(self.selectionIndex == self.setIndex ? 1 : 0.8), radius: 3)
		.opacity(self.selectionIndex == self.setIndex ? 1 : 0.8)
		
	}
	
}
