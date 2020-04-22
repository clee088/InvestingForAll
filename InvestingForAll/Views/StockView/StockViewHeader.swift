//
//  StockViewHeader.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/20/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct StockViewHeader: View {
	
	@Binding var isPresented: Bool
	
	@ObservedObject var image: LogoModel
	@ObservedObject var quote: QuoteModel
	
	@State var companyName: String
	@State var symbol: String
	
	@Binding var showStatistics: Bool
	
	var geometry: GeometryProxy
	
	var body: some View {
		
		VStack {
			HStack {
				
				VStack(alignment: .leading) {
					HStack {
						Image(uiImage: UIImage(data: self.image.imageData ?? Data()) ?? UIImage(systemName: "exclamationmark.triangle")!)
							.resizable()
							.frame(width: self.geometry.size.width * 0.1, height: self.geometry.size.width * 0.1, alignment: .center)
							.mask(Circle())
						
						Text("\(self.symbol)")
							.font(.title)
							.fontWeight(.semibold)
							.foregroundColor(Color.white)
						//									.bold()
						
						Spacer()
						
						Button(action: {
							self.isPresented.toggle()
						}) {
							Image(systemName: "magnifyingglass")
								.imageScale(.large)
								.foregroundColor(Color.white)
							
						}
						
					}
					
					Text("\(self.companyName)")
						.font(.subheadline)
						.fontWeight(.medium)
						.foregroundColor(Color.white)
					//								.bold()
				}
				
			}
			.padding(.horizontal)
			
			
			//					if self.quote.dataIsLoaded {
			HStack {
				
				Text("$\(String(format: "%.2f", self.quote.quoteResult?.latestPrice ?? 32.38))")
					.bold()
					.font(.title)
					.foregroundColor(Color.white)
				//								.font(.system(size: 22))
				
				VStack(alignment: .leading) {
					
					Text(String(format: "%.2f", self.quote.quoteResult?.change ?? -3.75))
						.font(.system(size: 15))
						.foregroundColor((self.quote.quoteResult?.change ?? -3.75) > 0 ? Color.green : Color.red)
					
					Text("\(String(format: "%.2f", (self.quote.quoteResult?.changePercent ?? -0.1038) * 100))%")
						.font(.system(size: 15))
						.foregroundColor((self.quote.quoteResult?.change ?? -3.75) > 0 ? Color.green : Color.red)
					
				}
				
				Spacer()
				
				Button(action: {
					
					self.showStatistics.toggle()
					
				}) {
					HStack {
						
						Text(self.showStatistics ? " Hide Statistics" : "Statistics")
							.font(.caption)
						
						Image(systemName: "arrow.down.square")
							.imageScale(.medium)
							.rotationEffect(.degrees(self.showStatistics ? -180 : 0))
					}
					.foregroundColor(Color.white)
				}
				
			}
			.padding(.horizontal)
			//					} else {
			//						Text("Unavailable... Reloading")
			//							.bold()
			//							.padding()
			//							.onAppear() {
			//
			//								if self.news.dataIsLoaded == false {
			//									DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
			//										if self.news.dataIsLoaded == false {
			//											self.news.getNewsData(symbol: self.symbol, sandbox: self.developer.sandboxMode)
			//										}
			//									}
			//								}
			//
			//								if self.quote.dataIsLoaded == false {
			//									DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
			//										if self.quote.dataIsLoaded == false {
			//											self.quote.getData(symbol: self.symbol, sandbox: self.developer.sandboxMode)
			//										}
			//									}
			//								}
			//						}
			//					}
			
		}
		
	}
	
}
