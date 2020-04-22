//
//  StatisticsView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/20/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
	
	@ObservedObject var quote: QuoteModel
	
	var geometry: GeometryProxy
	
	private func roundedNumberString(number: Double) -> String {
		
		var rn: String = ""
		
		//MARK: Thousand
		//1,000 -> 1,000,000
		if number >= 1000 && number < 1000000 {
			let n = number / 1000
			
			rn = "\(String(format: "%.2f", n))K"
			
		}
			
			//MARK: Million
			//1,000,000 -> 1,000,000,000
		else if number >= 1000000 && number < 1000000000 {
			let n = number / 1000000
			
			rn = "\(String(format: "%.2f", n))M"
			
		}
			
			//MARK: Billion
			//1,000,000,000 -> 1,000,000,000,000
		else if number >= 1000000000 && number < 1000000000000 {
			let n = number / 1000000000
			
			rn = "\(String(format: "%.2f", n))B"
			
		}
			
			//MARK: Trillion
			//1,000,000,000,000 -> 1,000,000,000,000,000
		else if number >= 1000000000000 && number < 1000000000000000 {
			let n = number / 1000000000000
			
			rn = "\(String(format: "%.2f", n))T"
			
		}
			
		else {
			rn = String(format: "%.0f", number)
		}
		
		return rn
		
	}
	
	var body: some View {
		
		VStack(alignment: .leading) {
			
			HStack {
				VStack(alignment: .leading) {
					Text("Market Cap:")
						.font(.subheadline)
					
					Text(self.roundedNumberString(number: Double(self.quote.quoteResult?.marketCap ?? 3990000000)))
						.font(.subheadline)
						.bold()
					
					Spacer()
				}
				
				Spacer()
				
				VStack(alignment: .trailing) {
					Text("Prev Close/Open:")
						.font(.subheadline)
					
					
					Text("\(String(format: "%.2f", self.quote.quoteResult?.previousClose ?? 36.13))/\(String(format: "%.2f", self.quote.quoteResult?.open ?? 34.05))")
						.font(.subheadline)
						.bold()
					
					Spacer()
				}
			}
			
			HStack {
				VStack(alignment: .leading) {
					Text("Volume:")
						.font(.subheadline)
					
					
					Text(self.roundedNumberString(number: self.quote.quoteResult?.volume ?? 5000000))
						.font(.subheadline)
						.bold()
					
					
					Spacer()
				}
				
				Spacer()
				
				VStack(alignment: .trailing) {
					Text("Day's Range:")
						.font(.subheadline)
					
					
					Text("\(String(format: "%.2f", self.quote.quoteResult?.low ?? 31.27)) - \(String(format: "%.2f", self.quote.quoteResult?.high ?? 34.49))")
						.font(.subheadline)
						.bold()
					
					
					Spacer()
				}
				
			}
			
			HStack {
				VStack(alignment: .leading) {
					Text("PE Ratio:")
						.font(.subheadline)
					
					
					Text(String(self.quote.quoteResult?.peRatio ?? 26.65))
						.font(.subheadline)
						.bold()
					
					
					Spacer()
				}
				
				Spacer()
				
				VStack(alignment: .trailing) {
					Text("52 Week Range:")
						.font(.subheadline)
					
					
					Text("\(String(format: "%.2f", self.quote.quoteResult?.week52Low ?? 9.06)) - \(String(format: "%.2f", self.quote.quoteResult?.week52High ?? 59.15))")
						.font(.subheadline)
						.bold()
					
					
					Spacer()
				}
			}
			
		}
		.padding()
		.frame(width: self.geometry.size.width * 0.9, height: self.geometry.size.height * 0.2)
		.animation(.spring())
		.transition(AnyTransition.move(edge: .top).combined(with: .opacity))
		.background(Color("Stock View Card"))
		.mask(RoundedRectangle(cornerRadius: 25))
		.shadow(color: Color("Card Shadow"), radius: 5, x: 0, y: 5)
		
	}
	
}
