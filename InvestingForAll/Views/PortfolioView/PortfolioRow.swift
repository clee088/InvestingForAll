//
//  PortfolioRow.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/20/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct PortfolioRow: View {
	
	@State var asset: FetchedResults<Portfolio>.Element
	
	@State var geometry: GeometryProxy
	
	@ObservedObject var quote: QuoteViewModel = QuoteViewModel()
	
	@Environment(\.managedObjectContext) var moc
	
	private func updateValues() {
		
		switch self.asset.symbol != "Cash" {
		case true:
			
			self.quote.getData(symbol: self.asset.symbol ?? "", sandbox: true, asset: asset)
			
		default:
			self.asset.currentValue = self.asset.shares
			self.asset.currentPrice = 1
		}
		
	}
	
	fileprivate func calculatePL(asset: FetchedResults<Portfolio>.Element) -> Text {
		
		let initial: Double = asset.valuePurchased
		let current: Double = asset.currentValue
		
		let difference: Double = current - initial
		
		return Text(String(format: "%.2f", difference))
			.foregroundColor(difference > 0 ? Color.green : Color.red)
		
	}
	
	fileprivate func calculatePLPercent(asset: FetchedResults<Portfolio>.Element) -> Text {
		
		let initial: Double = asset.valuePurchased
		let current: Double = asset.currentValue
		
		let difference: Double = current - initial
		
		return Text("\(String(format: "%.2f", (difference/initial)*100))%")
			.foregroundColor(difference > 0 ? Color.green : Color.red)
		
	}
	
	private func convertColor(data: Data) -> Color {
		
		do {
			return try Color(NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) ?? UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1))
		} catch {
			print(error)
		}
		
		return Color.clear
		
	}
	
	var body: some View {
		
		VStack(alignment: .leading) {
			
			HStack {
				
				RoundedRectangle(cornerRadius: 5)
					.fill(self.convertColor(data: self.asset.color ?? Data()))
					.frame(width: geometry.size.width * 0.02)
				
				VStack(alignment: .leading) {
					
					Text(String(self.asset.symbol ?? "Unknown"))
						.font(.headline)
						.fontWeight(.semibold)
					
					Text(String(self.asset.name ?? "Unknown"))
						.font(.headline)
						.fontWeight(.regular)
					
				}
				.frame(maxWidth: geometry.size.width * 0.3, alignment: .leading)
				
				//			Spacer()
				
				VStack(alignment: .leading) {
					
					Text(String(format: "%.2f", self.asset.shares))
						.font(.headline)
						.fontWeight(.regular)
					
					Text(String(format: "%.2f", self.asset.valuePurchased))
						.font(.headline)
						.fontWeight(.regular)
					
				}
				.frame(maxWidth: geometry.size.width * 0.2, alignment: .leading)
				
				VStack(alignment: .leading) {
					
					Text(String(format: "%.2f", self.asset.currentPrice))
						.font(.headline)
						.fontWeight(.regular)
					
					Text(String(format: "%.2f", self.asset.currentValue))
						.font(.headline)
						.fontWeight(.regular)
					
				}
				.frame(maxWidth: geometry.size.width * 0.2, alignment: .leading)
				
				VStack(alignment: .leading) {
					
					self.calculatePL(asset: asset)
					
					self.calculatePLPercent(asset: asset)
					
				}
				.frame(maxWidth: geometry.size.width * 0.2, alignment: .leading)
				
//				Spacer()
			}
			.padding([.vertical, .trailing])
			
		}
		.onAppear() {
			self.updateValues()
		}
		//		.background(self.convertColor(data: self.asset.color ?? Data()))
		
	}
	
	
	
}
