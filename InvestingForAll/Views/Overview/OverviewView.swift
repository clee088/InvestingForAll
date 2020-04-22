//
//  OverviewView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/9/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct OverviewView: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@Environment(\.managedObjectContext) var moc
	
	@EnvironmentObject var developer: DeveloperModel
	
	var sectorETFS: [String : [String]] = [
		"Communication Services" : ["XLC", "phone"],
		"Consumer Discretionary" : ["XLY", "car"],
		"Consumer Staples" : ["XLP", "cart"],
		"Energy" : ["XLE", "battery.0"],
		"Financials" : ["XLF", "dollarsign.circle"],
		"Health Care" : ["XLV", "staroflife"],
		"Industrials" : ["XLI", "gear"],
		"Information Technology" : ["XLK", "desktopcomputer"],
		"Materials" : ["XLB", "cube.box"],
		"Real Estate" : ["XLRE", "house"],
		"Utilities" : ["XLU", "lightbulb"],
	]
	
	var indices: [String : [String]] = [
		"SPDR S&P 500 ETF Trust" : ["SPY", "chart.bar"],
		"SPDR Dow Jones Industrial Average ETF Trust" : ["DIA", "chart.bar"],
		"Invesco QQQ Trust" : ["QQQ", "chart.bar"],
		"iShares Russell 2000 ETF" : ["IWM", "chart.bar"]
	]
	
	var geometry: GeometryProxy
	
	var body: some View {
		
		let sortedSector = sectorETFS.sorted(by: {$0.0 < $1.0} )

		let sectorName = sortedSector.map { $0.key }
		let sectorTickers = sortedSector.map { $0.value.first ?? "N/A" }
		let sectorImage = sortedSector.map { $0.value.last ?? "N/A" }
		
		let sortedIndices = indices.sorted(by: {$0.0 < $1.0} )

		let indexName = sortedIndices.map { $0.key }
		let indexTickers = sortedIndices.map { $0.value.first ?? "N/A" }
		let indexImage = sortedIndices.map { $0.value.last ?? "N/A" }
		
//		return GeometryReader { geometry in
			return ZStack {
				
				ScrollView(.vertical, showsIndicators: false) {
					
					VStack {
						
						
						horizontalCardView(title: "Sectors", color: Color("Card Background"), shadowColor: Color("Card Shadow"), showImage: true, showPrices: false, symbolName: sectorName, symbolTicker: sectorTickers, symbolImageName: sectorImage, geometry: self.geometry)
//							.background(Color("Card View Background"))
											
						horizontalCardView(title: "Indices", color: Color("Card Background"), shadowColor: Color("Card Shadow"), showImage: true, showPrices: true, symbolName: indexName, symbolTicker: indexTickers, symbolImageName: indexImage, geometry: self.geometry)
//							.background(Color("Card View Background"))
							
						WatchlistView(geometry: geometry)
							.padding()
							.frame(height: geometry.size.height * 0.45)
						
						Spacer(minLength: geometry.size.height * 0.15)
						
					}
				}
			}
//			.background(Color(.))
//		}
	}
}

struct OverviewView_Previews: PreviewProvider {
	
	static var previews: some View {
		
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
		return Group {
			
			GeometryReader { geometry in
				OverviewView(geometry: geometry)
					.environment(\.colorScheme, .light)
					.environment(\.managedObjectContext, context)
					.environmentObject(DeveloperModel())
			}
			
//			GeometryReader { geometry in
//				OverviewView(width: geometry.size.width * 0.4, height: geometry.size.height * 0.2)
//					.colorScheme(.dark)
//			}
			
		}
	}
}

struct horizontalCardView: View {
	
	@EnvironmentObject var developer: DeveloperModel
	
	var title: String
	var color: Color
	var linearGradient: LinearGradient?
	var shadowColor: Color
	
	@State var showImage: Bool
	@State var showPrices: Bool
	
	@ObservedObject var quote: QuoteBatchViewModel = QuoteBatchViewModel()
	
//	@ObservedObject var quoteViewModel: QuotesViewModel
	
	var symbolName: [String]
	var symbolTicker: [String]
	var symbolImageName: [String]
	
	var geometry: GeometryProxy
	
	var body: some View {
		
		let symbolData: [QuoteBatchValue]? = self.quote.results?.map { $0.value } ?? []
		
		return ZStack {
			VStack {
				
				HStack {
					Text(self.title)
						.font(.system(size: 20))
						.bold()
					
					Spacer()
					
				}
				.padding(.leading)
				
				ScrollView(.horizontal, showsIndicators: false) {
					HStack {
						
						if self.quote.dataIsLoaded {
							ForEach(0..<(self.quote.results?.count ?? 0)) { item in
								
								VStack {
									
									Spacer()

									HCardView(index: item, title: self.symbolName[item], ticker: self.symbolTicker[item], imageName: self.symbolImageName[item], change: symbolData?[item].quote?.change ?? 0, percentage: (symbolData?[item].quote?.changePercent ?? 0) * 100, price: symbolData?[item].quote?.latestPrice ?? 0, color: self.color, shadowColor: self.shadowColor, showImage: self.$showImage, showPrices: self.$showPrices, geometry: self.geometry)
									
									Spacer()
								}
							}
						}
							
						else {
							
							Spacer()
							
							Text("Unavailable... Reloading")
								.fontWeight(.semibold)
								.frame(width: self.geometry.size.width * 0.4, height: self.geometry.size.height * 0.26, alignment: .center)
								.padding()
//								.onAppear() {
//
//									if self.quote.dataIsLoaded == false {
//										DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
//											if self.quote.dataIsLoaded == false {
//												self.quote.getData(symbol: self.symbolTicker.joined(separator: ","), sandbox: self.developer.sandboxMode)
//											}
//										}
//									}
//							}
							
							ActivityIndicator(isLoading: self.$quote.dataIsLoaded)
							
							Spacer()
							
						}
						
					}
				}
				
			}
		}
		.onAppear {
			self.quote.getData(symbol: self.symbolTicker.joined(separator: ","), sandbox: self.developer.sandboxMode)
		}
	}
}

struct HCardView: View {
	
	var index: Int
	var title: String
	var ticker: String
	var imageName: String
	
	var change: Double = 0
	var percentage: Double = 0
	var price: Double = 0
	
	var color: Color
	var linearGradient: LinearGradient?
	var shadowColor: Color
	
	@Binding var showImage: Bool
	@Binding var showPrices: Bool
	
	var geometry: GeometryProxy
	
	var body: some View {
		
		return ZStack {
			
				ZStack {
					
					VStack {
						
						if self.showImage {
							HStack {
								Image(systemName: self.imageName)
									.imageScale(.large)
								
								Spacer()
							}
						} else {
							/*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
						}
						
						HStack {
							Text(self.title)
								.font(.headline)
								.bold()
								.allowsTightening(true)
								.lineLimit(nil)
								.multilineTextAlignment(.leading)
							
							Spacer()
						}
						
						
						HStack {
							Text(self.ticker)
								.font(.subheadline)
							
							Spacer()
						}
						
						Spacer()
						
						if self.showPrices {
							VStack {
								HStack {
									Text(String(format: "%0.2f", self.price))
										.font(.headline)
										.bold()
									
									Spacer()
								}
								
								HStack {
									Text(String(format: "%0.2f", self.change))
										.font(.subheadline)
										.foregroundColor(self.change > 0 ? Color.green : Color.red)
									
									Spacer()
								}
								
							}
						} else {
							/*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
						}
						
						HStack {
							
							
							if self.percentage != 0 {
								Image(systemName: self.change > 0 ? "arrowtriangle.up.circle" : "arrowtriangle.down.circle")
									.foregroundColor(self.change > 0 ? Color.green : Color.red)
									.aspectRatio(contentMode: .fit)
									.imageScale(.large)
							}
							
							else {
								Image(systemName: "arrowtriangle.right.circle")
									.foregroundColor(Color.black)
									.aspectRatio(contentMode: .fit)
									.imageScale(.large)
							}
							
							Text("\(String(format: "%0.2f", self.percentage))%")
								.font(.headline)
								.bold()
							
						}
						.padding(.trailing)
						
						Spacer()
					}
					.padding(.top)
					.padding(.leading)
				}
			
		}
		.background(self.color)
		.mask(RoundedRectangle(cornerRadius: 25))
		.frame(width: self.geometry.size.width * 0.4, height: geometry.size.height * 0.26, alignment: .center)
		.clipped()
		.shadow(color: self.shadowColor, radius: 5)
//		.padding(.vertical)
		.padding(EdgeInsets(top: 0, leading: self.geometry.size.width * 0.02, bottom: 0, trailing: self.geometry.size.width * 0.02))
		
	}
}
