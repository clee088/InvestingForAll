//
//  StockView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/17/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct StockView: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@Environment(\.managedObjectContext) var moc
	
	@EnvironmentObject var developer: DeveloperModel
	
	@Binding var isPresented: Bool
	
	@State var companyName: String
	@State var symbol: String
	
	@ObservedObject var image: LogoModel
	@ObservedObject var quote: QuoteModel
	@ObservedObject var news: NewsModel
	
	@State var showStatistics: Bool = false
	@State var showNewsArticle: Bool = false
	
	@State var showTradeMenu: Bool = false
	
	@State var viewState: CGSize = .zero
	
	var body: some View {
		
		return GeometryReader { geometry in
				
			ZStack {
				VStack {
					
					StockViewHeader(isPresented: self.$isPresented, image: self.image, quote: self.quote, companyName: self.companyName, symbol: self.symbol, showStatistics: self.$showStatistics, geometry: geometry)
						.padding(.top)
					
					ScrollView(.vertical) {
						VStack {
							
							if self.showStatistics {
								
								StatisticsView(quote: self.quote, geometry: geometry)
								
								Spacer(minLength: geometry.size.height * 0.02)
								
							}
							//								StockChart(candle: CandlesModel(symbol: self.symbol, interval: "D", from: 1583055000, to: 1584115200), width: geometry.size.width * 0.9, height: geometry.size.height * 0.3)
							RoundedRectangle(cornerRadius: 25)
								.fill(Color("Stock View Card"))
								.frame(height: geometry.size.height * 0.3, alignment: .center)
								.animation(.spring())
								.shadow(color: Color("Card Shadow"), radius: 5, x: 0, y: 5)
							
							Spacer(minLength: geometry.size.height * 0.05)
							
							NewsView(height: geometry.size.height, news: self.news, showNewsArticle: self.$showNewsArticle, geometry: geometry)
								.frame(height: geometry.size.height * 0.4, alignment: .center)
								.padding()
								.background(Color("Stock View Card"))
								.mask(RoundedRectangle(cornerRadius: 25))
								.shadow(color: Color("Card Shadow"), radius: 5, x: 0, y: 5)
								.animation(.spring())
							
							Spacer(minLength: geometry.size.height * 0.15)
							
						}
						.animation(.spring())
						.padding()
						
					}
					.background(Color("Stock View Background"))
					.clipShape(RoundedRectangle(cornerRadius: 40))
					.edgesIgnoringSafeArea(.bottom)
					//					.edgesIgnoringSafeArea(.vertical)
					
				}
//				.padding(.top)
				.background(LinearGradient(gradient: Gradient(colors: [Color("Header Light"), Color("Header Dark")]), startPoint: .leading, endPoint: .trailing))
				.edgesIgnoringSafeArea(.top)
				
				FloatingButton(showTradeMenu: self.$showTradeMenu, viewState: self.$viewState, ticker: self.$symbol, name: self.$companyName)
					.environment(\.colorScheme, self.colorScheme)
				
				TradeMenu(quote: self.quote, showTradeMenu: self.$showTradeMenu, symbol: self.$symbol, companyName: self.$companyName, imageData: self.$image.imageData, viewState: self.$viewState)
					.environment(\.managedObjectContext, self.moc)
				
			}
			
		}
		
	}
	
}

//MARK: Previews
struct StockView_Previews: PreviewProvider {
	static var previews: some View {
		StockView(isPresented: .constant(true), companyName: "Enphase Energy", symbol: "ENPH", image: LogoModel(symbol: "ENPH", sandbox: true), quote: QuoteModel(symbol: "ENPH", sandbox: true), news: NewsModel(symbol: "ENPH", sandbox: true))
	}
}
//
////MARK: Stock Chart
//struct StockChart: View {
//
//	@Environment(\.colorScheme) var colorScheme: ColorScheme
//
//	@ObservedObject var candle: CandlesModel
//
//	@State var width: CGFloat
//	@State var height: CGFloat
//
//	@State var colorIsRed: Bool = false
//
//	var body: some View {
//
//		let data: [Double] = self.candle.candlesResult?.c ?? []
//
//		let time: [Int] = self.candle.candlesResult?.t ?? []
//
//		return ZStack {
//			//			GeometryReader { geometry in
//			ScrollView(.horizontal) {
//
//				if self.candle.candlesResult?.c.isEmpty ?? true {
//					EmptyView()
//				}
//				else {
//					self.drawChart(data: data, width: self.width, height: self.height)
//						.stroke(self.colorIsRed ? Color.green : Color.red, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
//						.onAppear() {
//							if data.last ?? 0 > data.first ?? 0 {
//								self.colorIsRed = true
//							}
//					}
//				}
//
//			}
//		}
//		.rotationEffect(.degrees(180), anchor: .center)
//		.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
//		.background(self.colorScheme == .light ? Color("Card Light") : Color("Card Dark"))
//		.mask(RoundedRectangle(cornerRadius: 25))
//		.shadow(color: self.colorScheme == .light ? Color("Shadow Light") : Color("Search Dark"), radius: 5, x: 0, y: 5)
//	}
//
//	func drawChart(data: [Double], width: CGFloat, height: CGFloat) -> Path {
//		var path = Path()
//
//		let step: CGFloat = CGFloat(Double(width) / Double(data.count))
//
//		let yRange: CGFloat = CGFloat((data.max() ?? 0) + (data.min() ?? 0))
//
//		let scale: CGFloat = height / yRange
//
//		print("step: \(step) | scale: \(scale)")
//
//		var x: CGFloat = 0
//
//		path.move(to: CGPoint(x: x * step, y: CGFloat(data.first ?? 0) * scale))
//
//		data.forEach { price in
//
//			path.addLine(to: CGPoint(x: x, y: CGFloat(price) * scale))
//
//			x += step
//
//		}
//
//		return path
//
//	}
//
//}
