//
//  OverviewView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/9/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct OverviewView: View {
	
	@State var sectorETFS: [String : String] = [
		"Communication Services" : "XLC",
		"Consumer Discretionary" : "XLY",
		"Consumer Staples" : "XLP",
		"Energy" : "XLE",
		"Financials" : "XLF",
		"Health Care" : "XLV",
		"Industrials" : "XLI",
		"Information Technology" : "XLK",
		"Materials" : "XLB",
		"Real Estate" : "XLRE",
		"Utilities" : "XLU",
	]
	
	@State var indices: [String : String] = [
		"S&P 500" : "^GSPC",
		"Dow 30" : "^DJI",
		"Nasdaq" : "^IXIC",
		"Russell 2000" : "^XAX"
	]
	
	var width: CGFloat?
	var height: CGFloat?
	
	var body: some View {
		ZStack {
			ScrollView() {
				
				horizontalCardView(title: "Sectors", width: self.width, height: self.height, color: Color("Blue"), symbols: $sectorETFS)
				
				horizontalCardView(title: "Indices", width: self.width, height: self.height, color: Color("Blue"), symbols: $indices)
				
			}
		}
	}
}

struct OverviewView_Previews: PreviewProvider {
	static var previews: some View {
		
		GeometryReader { geometry in
			OverviewView(width: geometry.size.width * 0.4, height: geometry.size.height * 0.2)
		}
	}
}

struct horizontalCardView: View {
	
	var title: String
	var width: CGFloat?
	var height: CGFloat?
	var color: Color
	
	@Binding var symbols: [String : String]
	
	var body: some View {
		
		let sortedSymbols = symbols.sorted(by: <)
		
		let symbolName = sortedSymbols.map { $0.key }
		let symbolTicker = sortedSymbols.map { $0.value }
		
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
					HStack(spacing: 0) {
						ForEach(0..<sortedSymbols.count) { item in
							
							VStack {
								
								Spacer()

								HCardView(title: symbolName[item], ticker: symbolTicker[item], quote: QuoteModel(symbol: symbolTicker[item]), width: self.width, height: self.height, color: self.color)
								
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
	
	@ObservedObject var quote: QuoteModel
	
	var width: CGFloat?
	var height: CGFloat?
	var color: Color
	
	var body: some View {
		
		let change: Double = (self.quote.quoteResult?.c ?? 0) - (self.quote.quoteResult?.pc ?? 0)
		
		let percentage: Double = (change / (self.quote.quoteResult?.pc ?? 0)) * 100
		
		return ZStack {
			
			VStack {
				HStack {
					Text(self.title)
						.font(.headline)
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
				
				HStack {
					
					
					if percentage > 0 {
						Image(systemName: "arrowtriangle.up.circle")
							.foregroundColor(Color.green)
							.aspectRatio(contentMode: .fit)
							.imageScale(.large)
					}
					if percentage < 0 {
						Image(systemName: "arrowtriangle.down.circle")
							.foregroundColor(Color.red)
							.aspectRatio(contentMode: .fit)
							.imageScale(.large)
					}
					if percentage == 0 {
						Image(systemName: "arrowtriangle.right.circle")
							.foregroundColor(Color.black)
							.aspectRatio(contentMode: .fit)
							.imageScale(.large)
					}
					
					
					Text("\(String(format: "%0.2f", percentage))%")
						.font(.headline)
						.bold()
					
				}
				
				
				Spacer()
			}
			.padding(.top)
			.padding(.horizontal)
			
		}
		.background(self.color)
		.mask(RoundedRectangle(cornerRadius: 25))
		.frame(width: self.width, height: self.height, alignment: .center)
		.shadow(color: self.color, radius: 5)
		.padding(.leading)
		
	}
}
