//
//  AddButtonView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/6/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct AddButtonView: View {
	
	@State var showMenu: Bool = false
	
	@State private var response: Double = 0.3
	@State private var dampingFraction: Double = 0.7
	@State private var blendDuration: Double = 0.3
	
	private var size: CGFloat = 0.2
	
    var body: some View {
		GeometryReader { geometry in
			VStack {
				
				Spacer()
				
				HStack {
					
					Spacer()
					
					ZStack {
						
						Circle()
							.fill(Color("Add Menu Background"))
							.frame(width: geometry.size.width * 0.55, height: geometry.size.width * 0.55, alignment: .center)
							.padding(.top)
							.shadow(color: Color("Add Menu Background"), radius: 8)
							.scaleEffect(self.showMenu ? 1 : 0)
						
						Group {
							
							Circle()
								.fill(Color("Secondary Button"))
								.frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12, alignment: .center)
								.offset(x: 0, y: self.showMenu ? geometry.size.width * -0.16 : 0)
								.shadow(color: Color("Secondary Button"), radius: 4)
							
							Circle()
								.fill(Color("Secondary Button"))
								.frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12, alignment: .center)
								.offset(x: self.showMenu ? geometry.size.width * -0.16 : 0, y: self.showMenu ? geometry.size.width * -0.08 : 0)
								.shadow(color: Color("Secondary Button"), radius: 4)
							
							Circle()
								.fill(Color("Secondary Button"))
								.frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12, alignment: .center)
								.offset(x: self.showMenu ? geometry.size.width * 0.16 : 0, y: self.showMenu ? geometry.size.width * -0.08 : 0)
								.shadow(color: Color("Secondary Button"), radius: 4)
						}
						
						ZStack {
							Circle()
								.fill(Color("Add Button"))
							
							VStack {
								Image(systemName: self.showMenu ? "chevron.compact.down" : "chevron.compact.up")
									.resizable()
									.aspectRatio(contentMode: .fit)
									.padding([.top, .horizontal])
//									.rotationEffect(.degrees(self.showMenu ? 180 : 0))
								
								Spacer()
							}
						}
						.frame(width: geometry.size.width * self.size, height: geometry.size.width * self.size, alignment: .center)
						.clipShape(Circle())
						.onTapGesture {
							
							withAnimation(.interactiveSpring(response: self.response, dampingFraction: self.dampingFraction, blendDuration: self.blendDuration)) {
								self.showMenu.toggle()
							}
						}
						.padding([.top, .horizontal])
						.shadow(color: Color("Add Button"), radius: 8)

					}
					.offset(x: 0, y: geometry.size.width * 0.275)
					
					Spacer()

				}
				
			}
			.edgesIgnoringSafeArea(.bottom)
			
		}
    }
}

struct AddButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AddButtonView()
    }
}

struct PlusShape: Shape {
	func path(in rect: CGRect) -> Path {
		var path = Path()
		
		path.addRect(CGRect(x: rect.width / 2 - 50, y: rect.height / 2 - 50, width: 100, height: 100))
		
		return path
	}
	
}
