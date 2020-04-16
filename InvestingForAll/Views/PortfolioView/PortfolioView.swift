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
		
		let sum: Double = self.portfolio.map( {$0.valuePurchased} ).reduce(0, +)
		
		let values: [Double] = self.portfolio.map( { $0.valuePurchased / sum } ).sorted(by: >)
		
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
	
	var body: some View {
		
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
								
								Text("$\(String(format: "%.2f", self.portfolio[self.selectedIndex].valuePurchased))")
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
						
						Text("$\(String(format: "%.2f", self.portfolio.map( { $0.valuePurchased } )))")
							.font(.title)
							.fontWeight(.bold)
						
						Spacer()
					}
					
//					Spacer()
					
				}
				.frame(height: geometry.size.width * 0.5)
				
				Divider()
				
				ScrollView(.vertical) {
					VStack(alignment: .leading) {
						ForEach(self.portfolio, id: \.id) { object in
							
							HStack {
								RoundedRectangle(cornerRadius: 5)
									.fill(self.convertColor(data: object.color ?? Data()))
									.frame(width: geometry.size.width * 0.05, height: geometry.size.width * 0.05)
								
								Text(String(object.name ?? "Unavailable"))
								
								Spacer()
							}
							.padding()
							
						}
					}
				}
				.frame(width: geometry.size.width * 0.9, alignment: .center)
				.background(Color("Card Background"))
				.clipShape(RoundedRectangle(cornerRadius: 20))
				
				Spacer()
				
			}
			.padding()
		}
		
    }
}

struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
		
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
        return PortfolioView()
			.environment(\.managedObjectContext, context)
    }
}
