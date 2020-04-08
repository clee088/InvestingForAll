//
//  AddButtonView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/6/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct AddButtonView: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@State var showMenu: Bool = false
	
	@State private var response: Double = 0.3
	@State private var dampingFraction: Double = 0.6
	@State private var blendDuration: Double = 0.3
	
	private var size: CGFloat = 0.2
	
	private var offset: CGFloat = 0.4
	
	var body: some View {
		GeometryReader { geometry in
			
			ZStack {
				
				VStack {
					Spacer()
					
					HStack {
						Spacer()
						
						ZStack {
							
							Circle()
								.fill(Color("Floating Menu Background"))
								.frame(width: geometry.size.width * 0.74, height: geometry.size.width * 0.74, alignment: .center)
//								.shadow(color: Color("Card Dark"), radius: 8)
							
							Group {
								
								ZStack {
									Circle()
										.fill(Color("Floating Action"))
										.frame(width: geometry.size.width * 0.14, height: geometry.size.width * 0.14, alignment: .center)
									
									Image(systemName: "square.and.arrow.up")
										.resizable()
										.aspectRatio(contentMode: .fit)
										.padding()
									
								}
								.frame(width: geometry.size.width * 0.14, height: geometry.size.width * 0.14, alignment: .center)
								.foregroundColor(self.colorScheme == .light ? Color.white : Color.black)
								.clipShape(Circle())
								.shadow(color: Color("Floating Action"), radius: 5)
								.offset(x: geometry.size.width * -0.01, y: geometry.size.width * -0.24)
								
								ZStack {
									Circle()
										.fill(Color("Floating Action"))
										.frame(width: geometry.size.width * 0.14, height: geometry.size.width * 0.14, alignment: .center)
									
									Image(systemName: "creditcard")
										.resizable()
										.aspectRatio(contentMode: .fit)
										.padding()
									
								}
								.frame(width: geometry.size.width * 0.14, height: geometry.size.width * 0.14, alignment: .center)
								.foregroundColor(self.colorScheme == .light ? Color.white : Color.black)
								.clipShape(Circle())
								.shadow(color: Color("Floating Action"), radius: 5)
								.offset(x: geometry.size.width * -0.16, y: geometry.size.width * -0.16)
								
								ZStack {
									Circle()
										.fill(Color("Floating Action"))
									
									Image(systemName: "star")
										.resizable()
										.aspectRatio(contentMode: .fit)
										.padding()
									
								}
								.frame(width: geometry.size.width * 0.14, height: geometry.size.width * 0.14, alignment: .center)
								.foregroundColor(self.colorScheme == .light ? Color.white : Color.black)
								.clipShape(Circle())
								.shadow(color: Color("Floating Action"), radius: 5)
								.offset(x: geometry.size.width * -0.24, y: geometry.size.width * -0.01)
							}
							
						}
						.scaleEffect(self.showMenu ? 1 : 0)
						.clipShape(Circle())
						.offset(x: geometry.size.width * 0.3, y: geometry.size.width * 0.3)
						.shadow(color: Color("Floating Menu Background"), radius: 8)
						
					}
				}
				.padding(.horizontal)
				
				VStack {
					Spacer()
					
					HStack {
						Spacer()
						
						ZStack {
							Circle()
								.fill(LinearGradient(gradient: Gradient(colors: [Color("Floating Button Light"), Color("Floating Button Dark")]), startPoint: .topLeading, endPoint: .bottomTrailing))
								.frame(width: geometry.size.width * 0.16, height: geometry.size.width * 0.16, alignment: .center)
							
							Image(systemName: "plus")
								.resizable()
								.aspectRatio(contentMode: .fit)
								.frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1, alignment: .center)
							
						}
						.foregroundColor(Color.white)
						.rotationEffect(.degrees(self.showMenu ? 135 : 0))
						.onTapGesture {
							withAnimation(.interactiveSpring(response: self.response, dampingFraction: self.dampingFraction, blendDuration: self.blendDuration)) {
								self.showMenu.toggle()
							}
						}
						.clipShape(Circle())
						.shadow(color: Color("Floating Button Light"), radius: 5)
						.scaleEffect(self.showMenu ? 1.2 : 1)
						
					}
				}
				.padding(.horizontal)
				
			}
			.padding(.bottom)
		}
		//			VStack {
		//
		//				Spacer()
		//
		//				HStack {
		//
		//					Spacer()
		//
		//					ZStack {
		//
		//						Circle()
		//							.fill(Color("Add Menu Background"))
		//							.frame(width: geometry.size.width * 0.55, height: geometry.size.width * 0.55, alignment: .center)
		//							.padding(.top)
		//							.shadow(color: Color("Add Menu Background"), radius: 8)
		//							.scaleEffect(self.showMenu ? 1 : 0)
		//
		//						Group {
		//
		//							Circle()
		//								.fill(Color("Secondary Button"))
		//								.frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12, alignment: .center)
		//								.offset(x: 0, y: self.showMenu ? geometry.size.width * -0.16 : 0)
		//								.shadow(color: Color("Secondary Button"), radius: 4)
		//
		//							Circle()
		//								.fill(Color("Secondary Button"))
		//								.frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12, alignment: .center)
		//								.offset(x: self.showMenu ? geometry.size.width * -0.16 : 0, y: self.showMenu ? geometry.size.width * -0.08 : 0)
		//								.shadow(color: Color("Secondary Button"), radius: 4)
		//
		//							Circle()
		//								.fill(Color("Secondary Button"))
		//								.frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12, alignment: .center)
		//								.offset(x: self.showMenu ? geometry.size.width * 0.16 : 0, y: self.showMenu ? geometry.size.width * -0.08 : 0)
		//								.shadow(color: Color("Secondary Button"), radius: 4)
		//						}
		//
		//						ZStack {
		//							Circle()
		//								.fill(Color("Add Button"))
		//
		//							VStack {
		//								Image(systemName: self.showMenu ? "chevron.compact.down" : "chevron.compact.up")
		//									.resizable()
		//									.aspectRatio(contentMode: .fit)
		//									.padding([.top, .horizontal])
		////									.rotationEffect(.degrees(self.showMenu ? 180 : 0))
		//
		//								Spacer()
		//							}
		//						}
		//						.frame(width: geometry.size.width * self.size, height: geometry.size.width * self.size, alignment: .center)
		//						.clipShape(Circle())
		//						.onTapGesture {
		//
		//							withAnimation(.interactiveSpring(response: self.response, dampingFraction: self.dampingFraction, blendDuration: self.blendDuration)) {
		//								self.showMenu.toggle()
		//							}
		//						}
		//						.padding([.top, .horizontal])
		//						.shadow(color: Color("Add Button"), radius: 8)
		//
		//					}
		//					.offset(x: 0, y: geometry.size.width * 0.275)
		//
		//					Spacer()
		//
		//				}
		//
		//			}
		//			.edgesIgnoringSafeArea(.bottom)
		//
		//		}
	}
}

struct AddButtonView_Previews: PreviewProvider {
	static var previews: some View {
		AddButtonView()
	}
}
