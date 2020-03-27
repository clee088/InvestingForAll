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
	
	@State var companyName: String
	@State var symbol: String
	
    var body: some View {
		return ZStack {
			GeometryReader { geometry in
				
					ScrollView(.vertical) {
						VStack {
							
							HStack {
								Text("\(self.companyName) | \(self.symbol)")
									.font(.headline)
									.bold()
								Spacer()
							}
							.padding(.horizontal)
							
							Spacer()
							
							StockChart(candle: CandlesModel(symbol: self.symbol, interval: "D", from: 1583055000, to: 1584115200), width: geometry.size.width * 0.9, height: geometry.size.height * 0.3)
								.frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.3, alignment: .center)
							
//							StockChart(width: geometry.size.width * 0.9, height: geometry.size.height * 0.3)
//								.frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.3, alignment: .center)
							
						}
					}
				
			}
		}
		.padding(.bottom)
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
		StockView(companyName: "Enphase Energy", symbol: "ENPH")
    }
}

struct StockChart: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@ObservedObject var candle: CandlesModel
	
	@State var width: CGFloat
	@State var height: CGFloat
	
	@State var colorIsRed: Bool = false
	
	var body: some View {
		
		let data: [Double] = self.candle.candlesResult?.c ?? []
		
		let time: [Int] = self.candle.candlesResult?.t ?? []
		
		return ZStack {
			//			GeometryReader { geometry in
			ScrollView(.horizontal) {
				
				if self.candle.candlesResult?.c.isEmpty ?? true {
					EmptyView()
				}
				else {
					self.drawChart(data: data, width: self.width, height: self.height)
						.stroke(self.colorIsRed ? Color.green : Color.red, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
						.onAppear() {
							if data.last ?? 0 > data.first ?? 0 {
								self.colorIsRed = true
							}
					}
				}
				
			}
		}
		.rotationEffect(.degrees(180), anchor: .center)
		.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
		.background(Color("Card Light"))
		.mask(RoundedRectangle(cornerRadius: 25))
		.shadow(color: self.colorScheme == .light ? Color("Shadow Light") : Color("Search Dark"), radius: 5, x: 0, y: 5)
	}
	
	func drawChart(data: [Double], width: CGFloat, height: CGFloat) -> Path {
		var path = Path()
		
		let step: CGFloat = CGFloat(Double(width) / Double(data.count))
		
		let yRange: CGFloat = CGFloat((data.max() ?? 0) + (data.min() ?? 0))
		
		let scale: CGFloat = height / yRange
		
		print("step: \(step) | scale: \(scale)")
		
		var x: CGFloat = 0
		
		path.move(to: CGPoint(x: x * step, y: CGFloat(data.first ?? 0) * scale))
		
		data.forEach { price in
			
			path.addLine(to: CGPoint(x: x, y: CGFloat(price) * scale))
			
			x += step
			
		}
		
		return path
		
	}
	
}
