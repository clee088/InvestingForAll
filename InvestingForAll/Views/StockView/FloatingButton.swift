//
//  AddButtonView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/6/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct FloatingButton: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@Environment(\.managedObjectContext) var moc
	
	@State var showMenu: Bool = false
	@Binding var showTradeMenu: Bool
	
	@State private var response: Double = 0.2
	@State private var dampingFraction: Double = 0.55
	@State private var blendDuration: Double = 0.3
	
	@Binding var viewState : CGSize
	
	var body: some View {
		GeometryReader { geometry in
			
			VStack {
				
				Spacer()
				
				HStack {
					Spacer()
					
					ZStack {
						
						//MARK: Menu
						
						ZStack {
							
							Circle()
//								.fill(RadialGradient(gradient: Gradient(colors: [Color("Floating Menu Background"), Color("Floating Menu Background Dark")]), center: .center, startRadius: 100, endRadius: 0))
								.fill(LinearGradient(gradient: Gradient(colors: [Color("Floating Menu Background"), Color("Floating Menu Background Dark")]), startPoint: .topLeading, endPoint: .bottomTrailing))
								//.fill(Color("Floating Menu Background"))
								.frame(width: geometry.size.width * 0.72, height: geometry.size.width * 0.72, alignment: .center)
								.shadow(color: self.showMenu ? Color("Floating Menu Background").opacity(1) : Color("Floating Menu Background").opacity(0), radius: 10)
							
							Group {
								Button(action: {
									print("Share")
								}) {
									ZStack {
										Circle()
											.fill(Color("Floating Action"))
										
										Image(systemName: "square.and.arrow.up")
											.resizable()
											.aspectRatio(contentMode: .fit)
											.padding()
										
									}
								}
								.frame(width: geometry.size.width * 0.14, height: geometry.size.width * 0.14, alignment: .center)
								.clipShape(Circle())
								.offset(x: 0, y: geometry.size.width * -0.245)

								
								Button(action: {
									withAnimation(.interactiveSpring(response: 0.35, dampingFraction: 0.6, blendDuration: 0.3)) {
										self.viewState = .zero
										self.showMenu.toggle()
										self.showTradeMenu.toggle()
									}
									
								}) {
									ZStack {
										Circle()
											.fill(Color("Floating Action"))
										
										Image(systemName: "arrow.up.arrow.down")
											.resizable()
											.aspectRatio(contentMode: .fit)
											.padding()
									}
									
								}
								.frame(width: geometry.size.width * 0.14, height: geometry.size.width * 0.14, alignment: .center)
								.clipShape(Circle())
								.offset(x: geometry.size.width * -0.175, y: geometry.size.width * -0.175)
//								.sheet(isPresented: self.$showTradeMenu) {
//									TradeMenu(showTradeMenu: self.$showTradeMenu)
//								}

								
								Button(action: {
									print("Add to Favorites")
									
//									let portfolio = Portfolio(context: self.moc)
									
								}) {
									ZStack {
										Circle()
											.fill(Color("Floating Action"))
										
										Image(systemName: "star")
											.resizable()
											.aspectRatio(contentMode: .fit)
											.padding()
									}
								}
								.frame(width: geometry.size.width * 0.14, height: geometry.size.width * 0.14, alignment: .center)
								.clipShape(Circle())
								.offset(x: geometry.size.width * -0.245, y: 0)

							}
							.shadow(color: Color("Floating Action"), radius: 5)
							.foregroundColor(Color.white)
							
						}
						.scaleEffect(self.showMenu ? 1 : 0.25)
						
						//MARK: Button
						Button(action: {
							withAnimation(.interactiveSpring(response: self.response, dampingFraction: self.dampingFraction, blendDuration: self.blendDuration)) {
								self.showMenu.toggle()
							}
						}) {
							ZStack {
								
								Circle()
									.fill(LinearGradient(gradient: Gradient(colors: [Color("Floating Button Light"), Color("Floating Button Dark")]), startPoint: .topLeading, endPoint: .bottomTrailing))
								
								Image(systemName: "plus")
									.resizable()
									.aspectRatio(contentMode: .fit)
									.padding()
								
							}
						}
						.frame(width: geometry.size.width * 0.18, height: geometry.size.width * 0.18, alignment: .center)
						.foregroundColor(Color.white)
						.rotationEffect(.degrees(self.showMenu ? 135 : 0))
						.scaleEffect(self.showMenu ? 1.2 : 1)
						.clipShape(Circle())
						.shadow(color: Color("Floating Button Light"), radius: 5)
						
					}
					.offset(x: geometry.size.width * 0.27, y: geometry.size.width * 0.27)
					
				}
				.padding(.horizontal)
			}
		}
	}
	
}

struct FloatingButtonView_Previews: PreviewProvider {
	static var previews: some View {
		FloatingButton(showTradeMenu: .constant(false), viewState: .constant(.zero))
			
	}
}
