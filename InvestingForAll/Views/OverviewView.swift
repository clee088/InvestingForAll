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
		"Communication Services" : "XLY",
		"Consumer Discretionary" : "XLP",
		"Consumer Staples" : "XLE",
		"Energy" : "XLF",
		"Financials" : "XLV",
		"Health Care" : "XLI",
		"Industrials" : "XLK",
		"Information Technology" : "XLB",
		"Materials" : "XLRE",
		"Real Estate" : "XLU",
		"Utilities" : "XLY",
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
			ScrollView(.vertical) {
				horizontalCardView(title: "Sectors", width: self.width, height: self.height, color: Color("Pink"), symbols: $sectorETFS)
				
				horizontalCardView(title: "Indices", width: self.width, height: self.height, color: Color("Light Blue"), symbols: $indices)
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
				
				ScrollView(.horizontal) {
					HStack(spacing: 10.0) {
						ForEach(0..<sortedSymbols.count) { item in
							
							HCardView(title: symbolName[item], ticker: symbolTicker[item], quote: QuoteModel(symbol: symbolTicker[item]), width: self.width, height: self.height, color: self.color)
						}
					}
					
				}
				
			}
		}
		.padding(.leading)
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
		
		let percentage: Double? = ((self.quote.quoteResult?.c ?? 0) - (self.quote.quoteResult?.pc ?? 0)) / (self.quote.quoteResult?.pc ?? 0)
		
		return ZStack {

			VStack {
				HStack {
					Text(title)
						.font(.headline)

					Spacer()
				}
				
				HStack {
					Text(ticker)
						.font(.subheadline)

					Spacer()
				}

				Spacer()

				HStack {
					
					if (percentage ?? 0) > 0 {
						Image(systemName: "arrowtriangle.up.circle")
							.foregroundColor(Color.green)
							.aspectRatio(contentMode: .fit)
							.imageScale(.large)
					}
					if (percentage ?? 0) < 0 {
						Image(systemName: "arrowtriangle.down.circle")
							.foregroundColor(Color.red)
							.aspectRatio(contentMode: .fit)
							.imageScale(.large)
					}
					else {
						Image(systemName: "arrowtriangle.right.circle")
							.foregroundColor(Color.black)
							.aspectRatio(contentMode: .fit)
							.imageScale(.large)
					}

					Text("\(String(format: "%0.2f", (percentage ?? 0) * 100))%")
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
		.shadow(radius: 3)
	}
}
