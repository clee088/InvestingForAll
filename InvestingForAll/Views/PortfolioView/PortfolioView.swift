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
	
	@State private var selectedIndex: Int? = nil
	
	@State private var isSelecting: Bool = false
	
	var geometry: GeometryProxy
	
	private func convertColor(data: Data) -> Color {
		
		do {
			return try Color(NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) ?? UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1))
		} catch {
			print(error)
		}
		
		return Color.clear
		
	}
	
	var body: some View {
		
		let accValue: Double = self.portfolio.map( { $0.currentValue } ).reduce(0, +)
		
		let percent: Double = (accValue-1000)/1000 * 100
		
		return GeometryReader { geometry in
			VStack {
				
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
							ForEach(0..<self.portfolio.count, id: \.self) { index in
								
								ZStack {
									
//									self.createDonutSlice(geometry: geometry, index: index, color: self.convertColor(data: self.portfolio[index].color ?? Data()))
									DonutSliceView(geometry: geometry, portfolio: self.portfolio, index: index, color: self.convertColor(data: self.portfolio[index].color ?? Data()), selectedIndex: self.$selectedIndex, isSelecting: self.$isSelecting)
										.frame(width: geometry.size.width * 0.4, height: geometry.size.width * 0.4, alignment: .center)
										.onTapGesture {
											
											if self.isSelecting && self.selectedIndex == index {
												self.selectedIndex = nil
												self.isSelecting.toggle()
											}
											
//											if self.isSelecting && self.selectedIndex != index {
//												self.selectedIndex = index
//											}
												
											else {
												self.selectedIndex = index
												
												if !self.isSelecting {
													self.isSelecting.toggle()
												}
												
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
							
							Image(systemName: percent > 0 ? "chevron.up.circle" : "chevron.down.circle")
								.imageScale(.large)
								.aspectRatio(contentMode: .fit)
								.foregroundColor(percent > 0 ? Color.green : Color.red)
							
							Text("\(String(format: "%.2f", accValue-1000)) (\(String(format: "%.2f", percent))%)")
								.font(.headline)
								.fontWeight(.light)
								.foregroundColor(percent > 0 ? Color.green : Color.red)
							
						}
						
						Spacer()
					}
					.padding()
					.background(Color("Card Background"))
					.mask(AccountValueShape(cornerRadius: 20, style: .circular))
					.shadow(color: Color("Card Background"), radius: 8)
//				.cornerRadius(2, co)
					
				}
				.padding(.bottom)
				.frame(height: geometry.size.width * 0.5)
				
				Divider()
				
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
						ForEach(self.portfolio.dropFirst(), id: \.id) { object in
							
							PortfolioRow(asset: object, geometry: geometry)
								.frame(maxHeight: geometry.size.height * 0.2)
							
						}
					}
					.frame(width: geometry.size.width * 0.9, alignment: .center)
				}
				.background(Color("Card Background"))
				.clipShape(RoundedRectangle(cornerRadius: 20))
				
				Spacer(minLength: geometry.size.height * 0.1)
				
			}
			.padding(.vertical)
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
