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
	
	@EnvironmentObject var developer: DeveloperModel
	
	private func updateValues() {
		
		switch self.asset.symbol != "Cash" {
		case true:
			
			self.quote.getData(symbol: self.asset.symbol ?? "", sandbox: self.developer.sandboxMode, asset: asset)
			
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
			.font(.headline)
			.fontWeight(.semibold)
		
	}
	
	fileprivate func calculatePLPercent(asset: FetchedResults<Portfolio>.Element) -> Text {
		
		let initial: Double = asset.valuePurchased
		let current: Double = asset.currentValue
		
		let difference: Double = current - initial
		
		return Text("\(String(format: "%.2f", (difference/initial)*100))%")
			.foregroundColor(difference > 0 ? Color.green : Color.red)
			.font(.headline)
			.fontWeight(.semibold)
		
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
					.frame(width: geometry.size.width * 0.025)
				
				VStack(alignment: .leading) {
					
					Text(String(self.asset.symbol ?? "Unknown"))
						.font(.headline)
						.fontWeight(.semibold)
					
					Text(String(self.asset.name ?? "Unknown"))
						.font(.subheadline)
						.fontWeight(.light)
					
				}
				.frame(maxWidth: geometry.size.width * 0.3, alignment: .leading)
				
				//			Spacer()
				
				VStack(alignment: .leading) {
					
					Text(String(format: "%.2f", self.asset.shares))
						.font(.headline)
						.fontWeight(.medium)
					
//					Text(String(format: "%.2f", self.asset.valuePurchased))
//						.font(.headline)
//						.fontWeight(.regular)
					
				}
				.frame(maxWidth: geometry.size.width * 0.2, alignment: .leading)
				
				VStack(alignment: .leading) {
					
					Text("$\(String(format: "%.2f", self.asset.currentPrice))")
						.font(.headline)
						.fontWeight(.medium)
					
//					Text(String(format: "%.2f", self.asset.currentValue))
//						.font(.headline)
//						.fontWeight(.regular)
					
				}
				.frame(maxWidth: geometry.size.width * 0.2, alignment: .leading)
				
				VStack(alignment: .leading) {
					
					self.calculatePL(asset: asset)
					
					self.calculatePLPercent(asset: asset)
					
				}
				.frame(maxWidth: geometry.size.width * 0.2, alignment: .leading)
					
				Image(systemName: self.asset.currentValue - self.asset.valuePurchased > 0 ? "arrowtriangle.up.circle" : "arrowtriangle.down.circle")
					.imageScale(.large)
					.aspectRatio(contentMode: .fit)
					.foregroundColor(self.asset.currentValue - self.asset.valuePurchased > 0 ? Color.green : Color.red)
				
			}
			.padding([.vertical, .trailing])
			
		}
		.background(Color("Card Background"))
		.clipShape(RoundedRectangle(cornerRadius: 20))
		.frame(idealHeight: self.geometry.size.height * 0.12)
		.padding(.leading)
		.shadow(color: Color("Card Background"), radius: 5)
		.clipped()
		.onAppear() {
			self.updateValues()
		}
		//		.background(self.convertColor(data: self.asset.color ?? Data()))
		
	}
	
	
	
}
