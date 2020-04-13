//
//  TradeMenu.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/9/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI
import Combine

struct TradeMenu: View {
	
	@Environment(\.managedObjectContext) var moc
	
	@ObservedObject var quote: QuoteModel
	
	@Binding var showTradeMenu: Bool
	
	@Binding var symbol: String
	@Binding var companyName: String
	
	@State var numberOfShares: String = ""
	
	@State private var keyboardHeight: CGFloat = .zero
	
	@State private var isEditing: Bool = false
	
	@State private var buySide: Bool = true
	
	@State private var reviewTradeText: String = "Review Trade"
	
	@ObservedObject private var userBalance: UserBalance = UserBalance()
	
	@State private var confirmingTrade: Bool = true
	
	@State private var orderButtonFill: LinearGradient = LinearGradient(gradient: Gradient(colors: [Color("Floating Button Light"), Color("Floating Button Dark")]), startPoint: .leading, endPoint: .trailing)
	
	@Binding var viewState: CGSize
	
	@FetchRequest(entity: Portfolio.entity(), sortDescriptors: []) var portfolio: FetchedResults<Portfolio>
	
	@FetchRequest(entity: Balance.entity(), sortDescriptors: []) var balance: FetchedResults<Balance>
	
	@State private var numberFormatter = NumberFormatter()
	
	private func estimatedCostString(marketPrice: Double, quantity: Double) -> String {
		
		let estimatedCost: Double = (marketPrice * quantity)
		
		return self.numberFormatter.string(for: estimatedCost) ?? ""
		
	}
	
	private func configureFormatter() {
		numberFormatter.numberStyle = .decimal
		numberFormatter.groupingSeparator = ","
	}
	
	private func confirmOrder() {
		
		let buyingPower: Double = self.userBalance.balance - (self.quote.quoteResult?.latestPrice ?? 0) * (Double(self.numberOfShares) ?? 0)
		
		switch buyingPower > 0{
		
		case true:
			self.reviewTradeText = "\(self.buySide ? "BUY" : "SELL") \(self.numberOfShares) shares of \(self.symbol) for $\(self.estimatedCostString(marketPrice: self.quote.quoteResult?.latestPrice ?? 0, quantity: Double(self.numberOfShares) ?? 0))"
			
			self.confirmingTrade.toggle()
			
		case false:
			
			self.reviewTradeText = "Insufficient Funds"
			
		}
		
	}
	
	private func executeOrder() {
		
		var balanceAfterTrade: Double = self.userBalance.balance
		
		switch self.buySide {
		case true:
			balanceAfterTrade = self.userBalance.balance - (self.quote.quoteResult?.latestPrice ?? 0) * (Double(self.numberOfShares) ?? 0)
		case false:
			balanceAfterTrade = self.userBalance.balance + (self.quote.quoteResult?.latestPrice ?? 0) * (Double(self.numberOfShares) ?? 0)
		}
		
		switch balanceAfterTrade > 0 {
		case true:
			//Execute Order
			
			withAnimation(.spring()) {
				self.userBalance.balance = balanceAfterTrade
				self.reviewTradeText = "Order Placed!"
				self.orderButtonFill = LinearGradient(gradient: Gradient(colors: [Color("Green GL"), Color("Green GD")]), startPoint: .leading, endPoint: .trailing)
				
				//Reset Colors and Text
				DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
					self.reviewTradeText = "Review Trade"
					self.orderButtonFill = LinearGradient(gradient: Gradient(colors: [Color("Floating Button Light"), Color("Floating Button Dark")]), startPoint: .leading, endPoint: .trailing)
				}
				self.confirmingTrade.toggle()
			}
			
		case false:
			
			print("Insufficient Funds")
			
		}
		
	}
	
	var body: some View {
		
//		if self.balance.first?.buyingPower.isNaN ?? false {
//			let balance = Balance(context: self.moc)
//			
//			balance.buyingPower = 1000
//			
//			try? self.moc.save()
//			
//		}
		
		self.configureFormatter()
		
		return GeometryReader { geometry in
			VStack {
				
				Spacer()
				
				if self.showTradeMenu {
					ZStack {
						
						VStack {
							HStack {
								Spacer()
								
								Button(action: {

									withAnimation(.interactiveSpring(response: 0.35, dampingFraction: 0.6, blendDuration: 0.3)) {
										self.showTradeMenu.toggle()
										self.isEditing = false
										UIApplication.shared.endEditing()
									}
								}) {
									Image(systemName: "xmark")
										.aspectRatio(contentMode: .fit)
										.imageScale(.large)

								}

								.frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.05, alignment: .center)
								.foregroundColor(Color.red)
								.background(Color("Secondary Button"))
								.mask(CloseShape(radius: geometry.size.width * 0.1))
							}
							
							Spacer()
						}
						
						VStack {
							
							HStack {
								
								Text(self.symbol)
									.font(.title)
									.fontWeight(.bold)
								
								Spacer()
								
								Group {
									Button(action: {
//										withAnimation() {
											self.buySide = true
//										}
									}) {
										ZStack {
											
											RoundedRectangle(cornerRadius: 15)
												.fill(self.buySide ? Color("Buy Color") : Color(.systemGray))
											
											Text("Buy")
												.foregroundColor(Color.white)
										}
									}
									.shadow(color: self.buySide ? Color("Buy Color") : Color(.systemGray), radius: 3)
									
									Button(action: {
//										withAnimation() {
											self.buySide = false
//										}
									}) {
										ZStack {
											
											RoundedRectangle(cornerRadius: 15)
												.fill(self.buySide ? Color(.systemGray) : Color("Sell Color"))
											
											Text("Sell")
												.foregroundColor(Color.white)
										}
									}
									.shadow(color: self.buySide ? Color(.systemGray) : Color("Sell Color"), radius: 3)
								}
								.frame(width: geometry.size.width * 0.2, height: geometry.size.height * 0.05)
								
								Spacer()
								
								Spacer()
								
							}
							
							HStack {
								
								Text("Buying Power")
									.font(.subheadline)
									.fontWeight(.light)
								
								Spacer()
								
								Button(action: {
									self.userBalance.balance = 1000
								}) {
									Text("RESET")
								}
								
								Text("$\(self.numberFormatter.string(for: self.userBalance.balance) ?? "")")
									.font(.subheadline)
									.fontWeight(.light)
								
							}
							
							Spacer()
							
							HStack {
								
								Text("Quantity")
									.font(.headline)
									.fontWeight(.light)
								
								Spacer()
								
								TextField("0", text: self.$numberOfShares, onEditingChanged: { change in
									withAnimation(.spring()) {
										self.isEditing.toggle()
									}
								})
									.padding(.horizontal)
									.keyboardType(.decimalPad)
									.multilineTextAlignment(.trailing)
									.frame(maxWidth: geometry.size.width * 0.5, maxHeight: geometry.size.height * 0.04)
									.background(Color("Quantity Background"))
									.clipShape(RoundedRectangle(cornerRadius: 5))
									.onReceive(Just(self.numberOfShares)) { newValue in
										let filtered = newValue.filter { "0123456789.".contains($0) }
										if filtered != newValue {
											self.numberOfShares = filtered
										}
								}
								
								if self.isEditing {
									Button(action: {
										UIApplication.shared.endEditing()
									}) {
										Text("Done")
									}
									.transition(AnyTransition.move(edge: .trailing).combined(with: .opacity))
								}
								
							}
							
							Spacer()
							
							HStack {
								
								Text("Market Price")
									.font(.headline)
									.fontWeight(.light)

								Spacer()
								
								Text("$\(String(format: "%.2f", self.quote.quoteResult?.latestPrice ?? 0.00))")
								
							}
							
							Spacer()
							
							HStack {
								
								Text("Estimated Cost")
									.font(.headline)
									.fontWeight(.semibold)
								
								Spacer()
								
								Text("$\(self.estimatedCostString(marketPrice: self.quote.quoteResult?.latestPrice ?? 0, quantity: Double(self.numberOfShares) ?? 0))")
									.font(.headline)
									.fontWeight(.semibold)
								
							}
							
							Spacer()
							
							ZStack {
								if !self.numberOfShares.isEmpty {
									Button(action: {
										
										switch self.confirmingTrade {
										case true:
											self.confirmOrder()
										case false:
											
											print("Will Execute")
											self.executeOrder()
										}
										
									}) {
										
										ZStack {
											
											Capsule()
												.fill(self.orderButtonFill)
											
											Text(self.reviewTradeText)
//												.font(.title)
												.fontWeight(.semibold)
												.foregroundColor(Color.white)
										}
										.padding(.horizontal)
										.transition(AnyTransition.slide.combined(with: .opacity))
										
									}
									.clipShape(Capsule())
									.frame(height: geometry.size.height * 0.06)
									.transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
								}
								else {
									EmptyView()
								}
							}
							.animation(.spring())
							
						}
						.padding()
						
					}
					.background(LinearGradient(gradient: Gradient(colors: [Color("Trade Light"), Color("Trade Dark")]), startPoint: .topLeading, endPoint: .bottomTrailing))
					.frame(height: geometry.size.height * 0.4)
					.mask(TradeMenuShape(cornerRadius: 40, style: .circular))
					.shadow(color: Color("Trade Light"), radius: 8)
					.transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
					.onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0 }
					.offset(y: self.isEditing ? -self.keyboardHeight : self.viewState.height)
					.gesture(
						DragGesture(coordinateSpace: .global)
							.onChanged { value in
								
								withAnimation(.spring()) {
									if value.translation.height > -geometry.size.height * 0.08 {
										self.viewState.height = value.translation.height
									}
										
									else {
										
										self.viewState = .zero
										
									}
								}
								
						}
						.onEnded { value in
							withAnimation(.spring()) {
								
								if value.predictedEndTranslation.height > geometry.size.height * 0.3 {
									self.showTradeMenu.toggle()
									//									UIApplication.shared.endEditing()
								}
								else {
									self.viewState = .zero
								}
							}
						}
					)
					
				} else {
					/*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
				}
				
			}
			.edgesIgnoringSafeArea(.bottom)
		}
	}
}

struct TradeMenuShape: Shape {
	
	var cornerRadius: CGFloat
	var style: RoundedCornerStyle
	
	func path(in rect: CGRect) -> Path {
		let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
		return Path(path.cgPath)
	}
}

struct CloseShape: Shape {
	
	@State var radius: CGFloat
	
	func path(in rect: CGRect) -> Path {
		var path = Path()
		
		path.addArc(center: CGPoint(x: rect.midX, y: 0 + self.radius), radius: self.radius, startAngle: .degrees(0), endAngle: .degrees(270), clockwise: true)
		
		path.addArc(center: CGPoint(x: rect.midX, y: 0), radius: self.radius, startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
		
		path.addLine(to: CGPoint(x: rect.midX + self.radius, y: 0 + self.radius))
		
		return path
	}
	
}

struct TradeMenu_Previews: PreviewProvider {
	
	static var previews: some View {
		
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
		return TradeMenu(quote: QuoteModel(symbol: "ENPH", sandbox: true), showTradeMenu: .constant(true), symbol: .constant("ENPH"), companyName: .constant("Enphase Energy Inc."), viewState: .constant(.zero))
			.environment(\.managedObjectContext, context)
		
	}
}