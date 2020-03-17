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
	
	@State var showSearch: Bool = false
	
	@State var viewState: CGSize = .zero
	
	var body: some View {
		GeometryReader { geometry in
			ZStack() {
				
				VStack {
					
					ZStack {
						
						StockPresentView(isPresented: self.$showSearch)
							.offset(x: self.showSearch ? 0 : geometry.size.width, y: 0)
							.zIndex(1)
						
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
								
								OverviewView(width: geometry.size.width * 0.4, height: geometry.size.height * 0.2)
							}
							
							if self.index == 2 {
								//						StockView(candle: CandlesModel(symbol: "AAPL", interval: "D", from: 1583055000, to: 1584115200))
								StockPresentView(isPresented: self.$showSearch)
							}
								
							else {
								/*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
							}
							
							Spacer()
							
						}
						.offset(x: self.showSearch ? geometry.size.width * -1 : 0, y: 0)
						
					}
					
					Spacer()
					
					customTabView(index: self.$index, width: geometry.size.width, height: geometry.size.height * 0.075)
						.background(Color.white)
						.clipped()
						.shadow(radius: 5)
					
				}
				.edgesIgnoringSafeArea(.bottom)
				//					.offset(x: self.showSearch ? geometry.size.width : 0, y: 0)
				
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
//		   ContentView()
//			  .previewDevice(PreviewDevice(rawValue: "iPhone SE"))
//			  .previewDisplayName("iPhone SE")
//
//			ContentView()
//				.previewDevice(PreviewDevice(rawValue: "iPhone 8"))
//				.previewDisplayName("iPhone 8")
			
		   ContentView()
			  .previewDevice(PreviewDevice(rawValue: "iPhone 11 Pro"))
			  .previewDisplayName("iPhone 11 Pro")
		}
	}
}

//MARK: Sub-views

struct customTabView: View {
	
	@Binding var index: Int
	
	var width: CGFloat?
	var height: CGFloat?
	
	var imageNames: [String] = ["house", "person", "waveform.path.ecg", "briefcase", "gear"]
	
	var body: some View {
		
		ZStack {
			HStack {
				ForEach(0..<self.imageNames.count) { item in
					
					Spacer(minLength: 0)
					
					if item == self.index {
						
						Image(systemName: self.imageNames[item])
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(width: ((self.width ?? 0) / 16), height: ((self.width ?? 0) / 16), alignment: .center)
							.foregroundColor(Color("Button"))
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
							.foregroundColor(Color.gray)
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
	
}
