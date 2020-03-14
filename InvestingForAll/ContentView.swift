//
//  ContentView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/9/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	
	@State var index: Int = 0
	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
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
							Text("Favorites")
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
						
						Spacer()
						
					}
					.padding(.top)
					.padding(.horizontal)
					
					if self.index == 0 {
						OverviewView(width: geometry.size.width * 0.4, height: geometry.size.height * 0.2)
					}
					
					if self.index == 3 {
						StockView()
					}
					
					else {
						/*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
					}
					
					Spacer()
					
					customTabView(index: self.$index, width: geometry.size.width, height: geometry.size.height * 0.075)
						.background(Color.white)
						.clipped()
						.shadow(radius: 5)
					
				}
				.edgesIgnoringSafeArea(.bottom)
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}

//MARK: Views

//struct OverviewView: View {
//	
//	var width: CGFloat?
//	var height: CGFloat?
//	
//	var body: some View {
//		ZStack {
//			ScrollView(.vertical) {
//				horizontalCardView(title: "Sectors", contentName: "Consumer Discretionary", contentPerformance: -5.19 , width: self.width, height: self.height, color: Color("Pink"))
//				
//				horizontalCardView(title: "Indices", contentName: "Consumer Discretionary", contentPerformance: -5.19 , width: self.width, height: self.height, color: Color("Light Blue"))
//			}
//		}
//	}
//}

//MARK: Sub-views

struct customTabView: View {
	
	@Binding var index: Int
	
	var width: CGFloat?
	var height: CGFloat?
	
	var imageNames: [String] = ["house", "person", "waveform.path.ecg", "briefcase", "gear"]
	
	var body: some View {
		
		HStack {
			ForEach(0..<self.imageNames.count) { item in
				
				Spacer(minLength: 0)
				
				if item == self.index {
					
					Image(systemName: self.imageNames[item])
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: ((self.width ?? 0) / 16), height: ((self.width ?? 0) / 16), alignment: .center)
						.foregroundColor(Color("Light Blue"))
						.animation(.easeOut)
						.onTapGesture {
							self.index = item
					}
					
				}
				else {
					Image(systemName: self.imageNames[item])
						.resizable()
						.aspectRatio(contentMode: .fit)
						.frame(width: ((self.width ?? 0) / 16), height: ((self.width ?? 0) / 16), alignment: .center)
						.foregroundColor(Color("Purple"))
						.onTapGesture {
							self.index = item
					}
				}
				
				Spacer(minLength: 0)
				
			}
			
		}
		.frame(width: self.width, height: self.height, alignment: .center)
		.padding(.bottom)
		
	}
	
}
