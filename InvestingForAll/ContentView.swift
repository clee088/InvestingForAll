//
//  ContentView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/9/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@EnvironmentObject var developer: DeveloperModel
	
	@State var index: Int = 0
	
	@State var showSearch: Bool = false
	
	@State var viewState: CGSize = .zero
	
	@State private var response: Double = 0.3
	@State private var dampingFraction: Double = 0.7
	@State private var blendDuration: Double = 0.3
	
	var body: some View {
		NavigationView {
			GeometryReader { geometry in
				ZStack {
					
					VStack {
						
						ZStack {
							
							SearchView(isPresented: self.$showSearch)
								.offset(x: self.showSearch ? self.viewState.width : self.viewState.width + geometry.size.width, y: 0)
								.zIndex(1)
								.animation(.interactiveSpring(response: self.response, dampingFraction: self.dampingFraction, blendDuration: self.blendDuration))
								.gesture(
									DragGesture()
										.onChanged() { value in
											
											if value.translation.width > 0 && self.showSearch == true {
												self.viewState.width = value.translation.width
//												print(value.translation.width)
											}
											
											if value.translation.width < 0 && self.showSearch == false {
												self.viewState.width = value.translation.width
											}
												
											else {
												self.viewState = .zero
											}
											
									}
									.onEnded() { value in
										
										if value.predictedEndTranslation.width > geometry.size.width * 0.5 && self.showSearch == true {
											
											self.showSearch.toggle()
											self.viewState = .zero
											
										}
										
										if value.predictedEndTranslation.width < 0 && self.showSearch == false {
											
											self.showSearch.toggle()
											self.viewState = .zero
											
										}
											
										else {
											self.viewState = .zero
										}
								})
							
							VStack {
								HStack {
									
									if self.index == 0 {
										Text("Overview")
											.font(.title)
											.bold()
									}
									
									if self.index == 1 {
										Text("Profile")
											.font(.title)
											.bold()
									}
									
									if self.index == 2 {
										Text("Explore")
											.font(.title)
											.bold()
									}
									
									if self.index == 3 {
										Text("Portfolio")
											.font(.title)
											.bold()
									}
									
									if self.index == 4 {
										Text("Settings")
											.font(.title)
											.bold()
									}
									
									Spacer(minLength: 0)
									
								}
								.padding(.top)
								.padding(.leading)
								
								if self.index == 0 {
									
									OverviewView()
//										.frame(width: geometry.size.width)
								}
								
								if self.index == 2 {
//									StockView()
									EmptyView()
								}
									
								if self.index == 4 {
									SettingsView()
								}
									
								else {
									/*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
								}
								
								Spacer()
								
							}
							.animation(.interactiveSpring(response: self.response, dampingFraction: self.dampingFraction, blendDuration: self.blendDuration))
							.offset(x: self.showSearch ? (geometry.size.width * -1) + self.viewState.width : self.viewState.width, y: 0)
							
						}
						
						Spacer()
						
//						VStack {
//
//							Spacer()
//						}
//						.padding(.bottom)
//						.clipShape(RoundedRectangle(cornerRadius: 25))
//						.background(self.colorScheme == .light ? Color.white : Color.black)
//						.frame(height: geometry.size.height * 0.1)
//						.shadow(color: self.colorScheme == .light ? Color(.systemGray6) : Color("Search Dark"), radius: 8, x: 0, y: -2)
						
					}
				}
				.edgesIgnoringSafeArea(.bottom)
				.navigationBarTitle("")
				.navigationBarHidden(true)
				.overlay(
					
					VStack {
						
						Spacer()
						
						customTabView(index: self.$index, width: geometry.size.width, height: geometry.size.height * 0.1)
					}
//					.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
					.edgesIgnoringSafeArea(.bottom)
					
				)
			}
		}
	}
}

//MARK: Previews
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			//			ContentView()
			//				.previewDevice(PreviewDevice(rawValue: "iPhone SE"))
			//				.previewDisplayName("iPhone SE")
			//
			//			ContentView()
			//				.previewDevice(PreviewDevice(rawValue: "iPhone 8"))
			//				.previewDisplayName("iPhone 8")
			
			ContentView()
				.previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
				.previewDisplayName("iPhone 11 Pro (Light Mode)")
				.environment(\.colorScheme, .light)
			
//			ContentView()
//				.previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
//				.previewDisplayName("iPhone 11 Pro (Dark Mode)")
//				.environment(\.colorScheme, .dark)
		}
	}
}

//MARK: Sub-views

struct customTabView: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@Binding var index: Int
	
	var width: CGFloat?
	var height: CGFloat?
	
	var imageNames: [String] = ["house", "person", "globe", "briefcase", "gear"]
	
	var body: some View {
		
		ZStack {
			HStack {
				ForEach(0..<self.imageNames.count) { item in
					
					Spacer(minLength: 0)
					
					Image(systemName: self.imageNames[item])
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: ((self.width ?? 0) / 16), height: ((self.width ?? 0) / 16), alignment: .center)
						.foregroundColor(item == self.index ? Color("Button") : Color.gray)
						.animation(.easeOut)
						.onTapGesture {
							self.index = item
					}
					
					Spacer(minLength: 0)
					
				}
				
			}
			.frame(height: self.height, alignment: .center)
			
		}
		.padding(.bottom)
		.background(self.colorScheme == .light ? Color.white : Color.black)
		.clipShape(RoundedRectangle(cornerRadius: 35))
		.shadow(color: self.colorScheme == .light ? Color(.systemGray4) : Color("Search Dark"), radius: 10, x: 0, y: 0)
		
	}
	
}
