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
	
	@State var sectorETFS: [String : [String]] = [
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
	
	@State var indices: [String : [String]] = [
		"SPDR S&P 500 ETF Trust" : ["SPY", "chart.bar"],
		"SPDR Dow Jones Industrial Average ETF Trust" : ["DIA", "chart.bar"],
		"Invesco QQQ Trust" : ["QQQ", "chart.bar"],
		"iShares Russell 2000 ETF" : ["IWM", "chart.bar"]
	]
	
	var body: some View {
		
		let sortedSector = sectorETFS.sorted(by: {$0.0 < $1.0} )

		let sectorName = sortedSector.map { $0.key }
		let sectorTickers = sortedSector.map { $0.value.first ?? "N/A" }
		let sectorImage = sortedSector.map { $0.value.last ?? "N/A" }
		
		let sortedIndices = indices.sorted(by: {$0.0 < $1.0} )

		let indexName = sortedIndices.map { $0.key }
		let indexTickers = sortedIndices.map { $0.value.first ?? "N/A" }
		let indexImage = sortedIndices.map { $0.value.last ?? "N/A" }
		
		return GeometryReader { geometry in
			ZStack {
				
				ScrollView(.vertical, showsIndicators: false) {
					
					VStack {
						
						horizontalCardView(title: "Sectors", width: geometry.size.width * 0.4, height: geometry.size.height * 0.26, color: Color("Card Background"), shadowColor: Color("Card Shadow"), showImage: true, showPrices: false, quote: QuoteBatchModel(symbol: sectorTickers.joined(separator: ","), sandbox: self.developer.sandboxMode), symbolName: sectorName, symbolTicker: sectorTickers, symbolImageName: sectorImage)
//							.background(Color("Card View Background"))
											
						horizontalCardView(title: "Indices", width: geometry.size.width * 0.4, height: geometry.size.height * 0.26, color: Color("Card Background"), shadowColor: Color("Card Shadow"), showImage: true, showPrices: true, quote: QuoteBatchModel(symbol: indexTickers.joined(separator: ","), sandbox: self.developer.sandboxMode), symbolName: indexName, symbolTicker: indexTickers, symbolImageName: indexImage)
//							.background(Color("Card View Background"))
							
						watchlistView()
							.padding()
							.frame(height: geometry.size.height * 0.45)
						
						Spacer(minLength: geometry.size.height * 0.15)
						
					}
				}
			}
//			.background(Color(.))
		}
	}
}

struct OverviewView_Previews: PreviewProvider {
	
	static var previews: some View {
		
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
		return Group {
			
			GeometryReader { geometry in
				OverviewView()
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

struct watchlistView: View {
	
	@Environment(\.managedObjectContext) var moc
	
	@FetchRequest(entity: Watchlist.entity(), sortDescriptors: []) var watchlist: FetchedResults<Watchlist>
	
	var body: some View {
		
		GeometryReader { geometry in
			VStack {
				HStack {
					Text("Watchlist")
						.font(.system(size: 20))
						.bold()
					
					Spacer()
				}
				
				Spacer()
				
				if !self.watchlist.isEmpty {
					ScrollView(.vertical) {
						VStack {
							ForEach(self.watchlist, id: \.id) { stock in
								
								VStack {
									HStack {
										
										Image(uiImage: (UIImage(data: stock.image ?? Data()) ?? UIImage(systemName: "exclamationmark.triangle"))!)
											.resizable()
											.aspectRatio(contentMode: .fit)
											.frame(width: geometry.size.width * 0.15, height: geometry.size.height * 0.15, alignment: .center)
											.clipShape(Circle())
										
										Text(stock.ticker ?? "N/A")
											.font(.headline)
											.fontWeight(.regular)
										
										
										Spacer()
										
									}
									
									HStack {
										Text(stock.companyName ?? "N/A")
											//										.font(.system(size: 15))
											.font(.subheadline)
											.fontWeight(.light)
										
										Spacer()
									}
									
								}
								.padding()
								.background(Color("Card Background"))
								.clipShape(RoundedRectangle(cornerRadius: 20))
								
							}
							
						}
					}
					
				} else {
						
					Text("Your Watchlist is Empty!")
						
				}
				
				Spacer()
				
			}
		}
		
	}
	
}

struct horizontalCardView: View {
	
	@EnvironmentObject var developer: DeveloperModel
	
	var title: String
	var width: CGFloat?
	var height: CGFloat?
	var color: Color
	var linearGradient: LinearGradient?
	var shadowColor: Color
	
	@State var showImage: Bool
	@State var showPrices: Bool
	
	@ObservedObject var quote: QuoteBatchModel
	@State var symbolName: [String]
	@State var symbolTicker: [String]
	@State var symbolImageName: [String]
	
	var body: some View {
		
		let symbolData: [QuoteBatchValue]? = self.quote.quoteResult?.map { $0.value } ?? []
		
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
							ForEach(0..<self.quote.quoteResult!.count) { item in
								
								VStack {
									
									Spacer()

									HCardView(index: item, title: self.symbolName[item], ticker: self.symbolTicker[item], imageName: self.symbolImageName[item], change: symbolData?[item].quote?.change ?? 0, percentage: (symbolData?[item].quote?.changePercent ?? 0) * 100, price: symbolData?[item].quote?.latestPrice ?? 0, width: self.width, height: self.height, color: self.color, shadowColor: self.shadowColor, showImage: self.$showImage, showPrices: self.$showPrices)
									
									Spacer()
								}
							}
						}
							
						else {
							
							Spacer()
							
							Text("Unavailable... Reloading")
								.fontWeight(.semibold)
								.frame(width: self.width, height: self.height, alignment: .center)
								.padding()
								.onAppear() {
									
									if self.quote.dataIsLoaded == false {
										DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
											if self.quote.dataIsLoaded == false {
												self.quote.getQuoteData(symbol: self.symbolTicker.joined(separator: ","), sandbox: self.developer.sandboxMode)
											}
										}
									}
							}
							
							ActivityIndicator(isLoading: self.$quote.dataIsLoaded)
							
							Spacer()
							
						}
						
					}
				}
				
			}
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
	
	var width: CGFloat?
	var height: CGFloat?
	var color: Color
	var linearGradient: LinearGradient?
	var shadowColor: Color
	
	@Binding var showImage: Bool
	@Binding var showPrices: Bool
	
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
		.frame(width: self.width, height: self.height, alignment: .center)
		.clipped()
		.shadow(color: self.shadowColor, radius: 5)
		.padding(.bottom)
		.padding(EdgeInsets(top: 0, leading: (self.width ?? 0) * 0.08, bottom: 0, trailing: (self.width ?? 0) * 0.08))
		
	}
}
