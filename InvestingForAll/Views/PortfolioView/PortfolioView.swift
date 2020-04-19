//
//  PortfolioView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/12/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct PortfolioView: View {
	
	//	@ObservedObject private var userBalance: UserBalance = UserBalance()
	
	@FetchRequest(entity: Portfolio.entity(), sortDescriptors: []) var portfolio: FetchedResults<Portfolio>
	
	@FetchRequest(entity: Portfolio.entity(), sortDescriptors: [], predicate: NSPredicate(format: "name == %@", "Cash")) var cash: FetchedResults<Portfolio>
	
	@Environment(\.managedObjectContext) var moc
	
	@EnvironmentObject var developer: DeveloperModel
	
	//	@ObservedObject var quote: QuoteBatchViewModel = QuoteBatchViewModel()
	
	@State private var selectedIndex: Int = 0
	
	private func convertColor(data: Data) -> Color {
		
		do {
			return try Color(NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) ?? UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1))
		} catch {
			print(error)
		}
		
		return Color.clear
		
	}
	
	private func createDonutSlice(geometry: GeometryProxy, index: Int, color: Color) -> some View {
		
		let sum: Double = self.portfolio.map( {$0.currentValue} ).reduce(0, +)
		
		let values: [Double] = self.portfolio.map( { $0.currentValue / sum } ).sorted(by: >)
		
		let offset: Double = values.prefix(upTo: index).reduce(0, +)
		
		switch index == 0 {
		case true:
			return Circle()
				.trim(from: CGFloat(0), to: CGFloat(offset + values[index]))
				.stroke(color, style: StrokeStyle(lineWidth: geometry.size.width * 0.06, lineCap: .butt, lineJoin: .miter))
			//				.frame(width: circleWidth, height: circleWidth, alignment: .center)
			
		default:
			return Circle()
				.trim(from: CGFloat(offset), to: CGFloat(offset + values[index]))
				.stroke(color, style: StrokeStyle(lineWidth: geometry.size.width * 0.06, lineCap: .butt, lineJoin: .miter))
			//				.frame(width: circleWidth, height: circleWidth, alignment: .center)
			
		}
		
	}
	
	//	private func updateValues() {
	//
	//		let portfolioNoCash: Slice<FetchedResults> = self.portfolio.dropFirst()
	//
	//		DispatchQueue.main.async {
	//			for index in 1..<portfolioNoCash.count {
	//
	//				let lp: Double = self.quote.results?.values.map({$0.quote?.latestPrice ?? 0})[index] ?? 0
	//				let shares: Double = portfolioNoCash.map({$0.shares})[index]
	//
	//				portfolioNoCash[index].currentValue = lp * shares
	//
	//				portfolioNoCash[index].currentPrice = lp
	//
	//				try? self.moc.save()
	//
	//			}
	//
	//			print(portfolioNoCash)
	//		}
	//
	//	}
	
	var body: some View {
		
		let accValue: Double = self.portfolio.map( { $0.currentValue } ).reduce(0, +)
		
		let percent: Double = (accValue-1000)/1000 * 100
		
		return GeometryReader { geometry in
			VStack {
				
				HStack {
					
					ZStack {
						
						VStack {
							
							Text("\(self.portfolio[self.selectedIndex].symbol ?? "Unavailable")")
								.font(.headline)
								.fontWeight(.semibold)
							
							HStack {
								
								RoundedRectangle(cornerRadius: 5)
									.fill(self.convertColor(data: self.portfolio[self.selectedIndex].color ?? Data()))
									.frame(width: geometry.size.width * 0.05, height: geometry.size.width * 0.05)
								
								Text("$\(String(format: "%.2f", self.portfolio[self.selectedIndex].currentValue))")
							}
						}
						
						ZStack {
							ForEach(0..<self.portfolio.count, id: \.self) { index in
								
								ZStack {
									
									self.createDonutSlice(geometry: geometry, index: index, color: self.convertColor(data: self.portfolio[index].color ?? Data()))
										.frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4, alignment: .center)
										.onTapGesture {
											self.selectedIndex = index
									}
									
								}
								
							}
						}
						.frame(width: geometry.size.width * 0.5, height: geometry.size.width * 0.5)
						.rotationEffect(.radians(-.pi / 2))
						
					}
					
					Spacer()
					
					VStack(alignment: .trailing) {
						
						Text("Account Value")
							.font(.headline)
							.fontWeight(.medium)
						
						//						Text("$\(String(format: "%.2f", self.quote.results?.values.map({$0.quote?.latestPrice ?? 0}).reduce(0, +) ?? 0))")
						Text("$\(String(format: "%.2f", self.portfolio.map( { $0.currentValue } ).reduce(0, +)))")
							.font(.title)
							.fontWeight(.bold)
						
						HStack {
							
							Image(systemName: percent > 0 ? "chevron.up.circle" : "chevron.down.circle")
								.imageScale(.large)
								.aspectRatio(contentMode: .fit)
								.foregroundColor(percent > 0 ? Color.green : Color.red)
							
							Text("$\(String(format: "%.2f", accValue-1000)) (\(String(format: "%.2f", percent))%)")
								.font(.headline)
								.fontWeight(.light)
								.foregroundColor(percent > 0 ? Color.green : Color.red)
							
						}
						
						Spacer()
					}
					
					//					Spacer()
					
				}
				.frame(height: geometry.size.width * 0.5)
				
				Divider()
				
				HStack {
					
					//					Spacer(minLength: geometry.size.width * 0.06)
					
					Text("Symbol")
						.font(.subheadline)
						.fontWeight(.light)
						.frame(maxWidth: geometry.size.width * 0.3, alignment: .leading)
					
					Text("Shares")
						.font(.subheadline)
						.fontWeight(.light)
						.frame(maxWidth: geometry.size.width * 0.2, alignment: .leading)
					
					//					Spacer()
					
					Spacer()
				}
				.padding(.horizontal)
				
				ScrollView(.vertical) {
					VStack(alignment: .leading) {
						ForEach(self.portfolio, id: \.id) { object in
							
							PortfolioRow(asset: object, geometry: geometry)
							
						}
					}
					.frame(width: geometry.size.width * 0.9, alignment: .center)
				}
				.background(Color("Card Background"))
				.clipShape(RoundedRectangle(cornerRadius: 20))
				
				Spacer(minLength: geometry.size.height * 0.1)
				
			}
			.padding()
			//			.onAppear() {
			//
			//				print(self.portfolio.map( { ($0.symbol ?? "") } ).dropFirst().joined(separator: ","))
			//
			//				self.quote.getData(symbol: self.portfolio.map( { ($0.symbol ?? "") } ).dropFirst().joined(separator: ","), sandbox: self.developer.sandboxMode)
			//
			//				self.updateValues()
			//
			//			}
		}
		
	}
}

struct PortfolioView_Previews: PreviewProvider {
	static var previews: some View {
		
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
		return PortfolioView()
			.environment(\.managedObjectContext, context)
			.environmentObject(DeveloperModel())
	}
}

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
	
	private func convertColor(data: Data) -> Color {
		
		do {
			return try Color(NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) ?? UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1))
		} catch {
			print(error)
		}
		
		return Color.clear
		
	}
	
	var body: some View {
		
		VStack {
			
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
				
				Spacer()
			}
			.padding([.vertical, .trailing])
			
		}
		.onAppear() {
			self.updateValues()
			print("loaded")
		}
		//		.background(self.convertColor(data: self.asset.color ?? Data()))
		
	}
	
	
	
}
