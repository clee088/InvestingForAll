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
		"S&P 500" : ["^GSPC", "chart.bar"],
		"Dow 30" : ["^DJI", "chart.bar"],
		"Nasdaq" : ["^IXIC", "chart.bar"],
		"Russell 2000" : ["^XAX", "chart.bar"]
	]
	
	var width: CGFloat?
	var height: CGFloat?
	
	var body: some View {
		ZStack {
			ScrollView() {
				
				horizontalCardView(title: "Sectors", width: self.width, height: self.height, color: self.colorScheme == .light ? Color("Card Light") : Color("Card Dark"), shadowColor: self.colorScheme == .light ? Color("Shadow Light") : Color("Shadow Dark"), symbols: $sectorETFS, showImage: true, showPrices: false)
				
				horizontalCardView(title: "Indices", width: self.width, height: self.height, color: self.colorScheme == .light ? Color("Card Light") : Color("Card Dark"), shadowColor: self.colorScheme == .light ? Color("Shadow Light") : Color("Shadow Dark"), symbols: $indices, showImage: false, showPrices: true)
				
			}
		}
	}
}

struct OverviewView_Previews: PreviewProvider {
	static var previews: some View {
		
		Group {
			
			GeometryReader { geometry in
				OverviewView(width: geometry.size.width * 0.4, height: geometry.size.height * 0.2)
					.environment(\.colorScheme, .light)
			}
			
			GeometryReader { geometry in
				OverviewView(width: geometry.size.width * 0.4, height: geometry.size.height * 0.2)
					.colorScheme(.dark)
			}
			
		}
	}
}

struct horizontalCardView: View {
	
	var title: String
	var width: CGFloat?
	var height: CGFloat?
	var color: Color
	var shadowColor: Color
	
	@Binding var symbols: [String : [String]]
	
	@State var showImage: Bool
	@State var showPrices: Bool
	
	var body: some View {
		
		let sortedSymbols = symbols.sorted(by: {$0.0 < $1.0} )
		
		let symbolName = sortedSymbols.map { $0.key }
		let symbolTicker = sortedSymbols.map { $0.value.first ?? "N/A" }
		let symbolImage = sortedSymbols.map { $0.value.last ?? "N/A" }
		
		return ZStack {
			VStack {
				
				HStack {
					Text(title)
						.font(.system(size: 20))
						.bold()
					
					Spacer()
					
				}
				.padding(.leading)
				
				ScrollView(.horizontal) {
					HStack(spacing: 5.0) {
						ForEach(0..<sortedSymbols.count) { item in
							
							VStack {
								
								Spacer()

								HCardView(title: symbolName[item], ticker: symbolTicker[item], imageName: symbolImage[item], quote: QuoteModel(symbol: symbolTicker[item]), width: self.width, height: self.height, color: self.color, shadowColor: self.shadowColor, showImage: self.$showImage, showPrices: self.$showPrices)
								
								Spacer()
							}
						}
					}
				}
			}
		}
	}
}

struct HCardView: View {
	
	var title: String
	var ticker: String
	var imageName: String
	@ObservedObject var quote: QuoteModel
	
	var width: CGFloat?
	var height: CGFloat?
	var color: Color
	var shadowColor: Color
	
	@Binding var showImage: Bool
	@Binding var showPrices: Bool
	
	var body: some View {
		
		let change: Double = (self.quote.quoteResult?.c ?? 0) - (self.quote.quoteResult?.pc ?? 0)
		
		let percentage: Double = (change / (self.quote.quoteResult?.pc ?? 0)) * 100
		
		let price: Double = self.quote.quoteResult?.c ?? 0
		
		return ZStack {
			
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
							Text(String(format: "%0.2f", price))
								.font(.headline)
								.bold()
							
							Spacer()
						}
						
						HStack {
							Text(String(format: "%0.2f", change))
								.font(.subheadline)
								.foregroundColor(change > 0 ? Color.green : Color.red)
							
							Spacer()
						}
						
					}
				} else {
					/*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
				}
				
				HStack {
					
					
					if percentage != 0 {
						Image(systemName: change > 0 ? "arrowtriangle.up.circle" : "arrowtriangle.down.circle")
							.foregroundColor(change > 0 ? Color.green : Color.red)
							.aspectRatio(contentMode: .fit)
							.imageScale(.large)
					}
					
					else {
						Image(systemName: "arrowtriangle.right.circle")
							.foregroundColor(Color.black)
							.aspectRatio(contentMode: .fit)
							.imageScale(.large)
					}
					
					Text("\(String(format: "%0.2f", percentage))%")
						.font(.headline)
						.bold()
					
				}
				.padding(.trailing)
				
				Spacer()
			}
			.padding(.top)
			.padding(.leading)
			
		}
		.background(self.color)
		.mask(RoundedRectangle(cornerRadius: 25))
		.frame(width: self.width, height: self.height, alignment: .center)
		.clipped()
		.shadow(color: self.shadowColor, radius: 8, x: 0, y: 7)
		.padding(.bottom)
		.padding(.leading)
		
	}
}
