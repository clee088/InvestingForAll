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
	
	@FetchRequest(entity: Portfolio.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Portfolio.currentValue, ascending: false)]) var portfolio: FetchedResults<Portfolio>
	
	@FetchRequest(entity: OrderHistory.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \OrderHistory.date, ascending: false)]) var orderHistory: FetchedResults<OrderHistory>
	
	@FetchRequest(entity: Portfolio.entity(), sortDescriptors: [], predicate: NSPredicate(format: "name == %@", "Cash")) var cash: FetchedResults<Portfolio>
	
	@Environment(\.managedObjectContext) var moc
	
	@EnvironmentObject var developer: DeveloperModel
	
	//	@ObservedObject var quote: QuoteBatchViewModel = QuoteBatchViewModel()
	
	@State private var selectedIndex: Int? = 0
	
	@State private var isSelecting: Bool = true
	
	@State var viewIndex: Int = 0
	
	var geometry: GeometryProxy
	
	private func convertColor(data: Data) -> Color {
		
		do {
			return try Color(NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) ?? UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1))
		} catch {
			print(error)
		}
		
		return Color.clear
		
	}
	
	private func createRowView(asset: FetchedResults<Portfolio>.Element) -> AnyView {
		
		switch asset.name == "Cash" {
		case true:
			return AnyView(EmptyView())
		default:
			return AnyView(PortfolioRow(asset: asset, geometry: self.geometry))
		}
		
	}
	
	var body: some View {
		
		let accValue: Double = self.portfolio.map( { $0.currentValue } ).reduce(0, +)
		
		let percent: Double = (accValue-1000)/1000 * 100
		
		return GeometryReader { geometry in
			VStack(alignment: .leading) {
				
				HStack {
					
					ZStack {
						
						if self.selectedIndex != nil {
							VStack {
								
								Text("\(self.portfolio[self.selectedIndex ?? 0].symbol ?? "Unavailable")")
									.font(.headline)
									.fontWeight(.semibold)
								
								HStack {
									
									RoundedRectangle(cornerRadius: 5)
										.fill(self.convertColor(data: self.portfolio[self.selectedIndex ?? 0].color ?? Data()))
										.frame(width: geometry.size.width * 0.05, height: geometry.size.width * 0.05)
									
									Text("$\(String(format: "%.2f", self.portfolio[self.selectedIndex ?? 0].currentValue))")
								}
							}
						}
						
						ZStack {
							
							ForEach(self.portfolio, id: \.id) { asset in
								
								DonutSliceView(geometry: geometry, portfolio: self.portfolio, index: self.portfolio.firstIndex(of: asset) ?? 0, color: self.convertColor(data: asset.color ?? Data()), selectedIndex: self.$selectedIndex, isSelecting: self.$isSelecting, values: self.portfolio.map({$0.currentValue / accValue}))
									.frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4, alignment: .center)
									.onTapGesture {
										
										if self.isSelecting && self.selectedIndex == self.portfolio.firstIndex(of: asset) ?? 0 {
											self.selectedIndex = nil
											self.isSelecting.toggle()
										}
											
										else {
											self.selectedIndex = self.portfolio.firstIndex(of: asset) ?? 0
											
											if !self.isSelecting {
												self.isSelecting.toggle()
											}
											
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
						
						Text("$\(String(format: "%.2f", self.portfolio.map( { $0.currentValue } ).reduce(0, +)))")
							.font(.title)
							.fontWeight(.bold)
						
						HStack {
							
							Image(systemName: percent > 0 ? "arrowtriangle.up.circle" : "arrowtriangle.down.circle")
								.imageScale(.large)
								.aspectRatio(contentMode: .fit)
								.foregroundColor(percent > 0 ? Color.green : Color.red)
							
							Text("\(String(format: "%.2f", accValue-1000)) (\(percent > 0 ? "+" : "")\(String(format: "%.2f", percent))%)")
								.font(.headline)
								.fontWeight(.light)
								.foregroundColor(percent > 0 ? Color.green : Color.red)
							
						}
						
						Spacer()
					}
					.padding()
					.background(Color("Account Value Background"))
					.mask(AccountValueShape(cornerRadius: 20, style: .circular))
					.shadow(color: Color("Account Value Background"), radius: 8)
					
				}
				.padding(.bottom)
				.frame(height: geometry.size.width * 0.5)
				
				Divider()
				
				ContentSelectorView(geometry: geometry, selectionIndex: self.$viewIndex)
				
				if self.viewIndex == 0 {
					if self.portfolio.count == 1 && self.portfolio.first?.name == "Cash" {
						Spacer()
						HStack {
							Spacer()
							Text("Your Portfolio is Empty!")
								.font(.headline)
								.fontWeight(.semibold)
							Spacer()
						}
					}
					
					else {
						HStack {
							
							Spacer(minLength: geometry.size.width * 0.02)
							
							Text("Symbol")
								.font(.subheadline)
								.fontWeight(.light)
								.frame(maxWidth: geometry.size.width * 0.3, alignment: .leading)
							
							Text("Cost Per Share/Total Cost")
								.font(.subheadline)
								.fontWeight(.light)
								.frame(maxWidth: geometry.size.width * 0.2, alignment: .leading)
							
							Text("Last Price/Current Value")
								.font(.subheadline)
								.fontWeight(.light)
								.frame(maxWidth: geometry.size.width * 0.2, alignment: .leading)
							
							Text("P/L")
								.font(.subheadline)
								.fontWeight(.light)
								.frame(maxWidth: geometry.size.width * 0.2, alignment: .leading)
							
						}
						.padding(.horizontal)
						
						ScrollView(.vertical) {
							VStack(alignment: .leading) {
								ForEach(self.portfolio, id: \.id) { object in
									
									self.createRowView(asset: object)
									
								}
							}
							.frame(width: geometry.size.width * 0.95, alignment: .center)
						}
					}
				}
				
				if self.viewIndex == 1 {
					
					if self.orderHistory.isEmpty {
						Spacer()
						HStack {
							Spacer()
							Text("You Haven't Made Any Orders!")
								.font(.headline)
								.fontWeight(.semibold)
							Spacer()
						}
					}
					else {
						ScrollView(.vertical) {
							ForEach(self.orderHistory, id: \.date) { order in
								OrderHistoryRow(geometry: geometry, order: order)
							}
						}
					}
					
				}
				
				Spacer()
				
			}
			.padding(.top)
		}
		
	}
}

private struct AccountValueShape: Shape {
	
	var cornerRadius: CGFloat
	var style: RoundedCornerStyle
	
	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
		return Path(path.cgPath)
	}
}

struct PortfolioView_Previews: PreviewProvider {
	static var previews: some View {
		
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
		return GeometryReader { geometry in
			PortfolioView(geometry: geometry)
				.environment(\.managedObjectContext, context)
				.environmentObject(DeveloperModel())
		}
	}
}
