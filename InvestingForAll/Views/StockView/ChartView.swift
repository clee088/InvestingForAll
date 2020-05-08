//
//  ChartView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/23/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct ChartView: View {
	
	@ObservedObject var historicalPricesViewModel: HistoricalPricesViewModel = HistoricalPricesViewModel()
	
//	@Binding var symbol: String
	
	var geometry: GeometryProxy
	
	@State var magnifyScale: CGFloat = 1
	
	@State var dateMagnifyScale: CGFloat = 1
	
	@State var testingData: [Double] = [30, 31, 30.5, 32, 35, 37, 34, 38, 40, 45, 50, 54, 52, 38]
	
	@State var rangeSelection: ChartRange = .oneYear {
		
		didSet {
			self.historicalPricesViewModel.dataIsLoaded = false
			self.historicalPricesViewModel.getHistoricalData(symbol: "ENPH", range: self.rangeSelection, useDate: false, date: "", sandbox: true)
		}
		
	}
	
	@State var rangeList: [ChartRange] = [.max, .fiveYear, .twoYear, .oneYear, .yearToDate, .sixMonth, .threeMonth, .oneMonthDefault, .oneMonthThirty, .fiveDay, .fiveDayTenMinute, .date, .dynamic]
	
	@State var isSelectingRange: Bool = false
	
	private var chartSpaceMidY: CGFloat {
		get {
			let max: CGFloat = CGFloat(self.historicalPricesViewModel.results.map({$0.close ?? 0}).max() ?? 0)
			
			let min: CGFloat = CGFloat(self.historicalPricesViewModel.results.map({$0.close ?? 0}).min() ?? 0)
			
			let yRange: CGFloat = max + min
			
			let scale: CGFloat = self.geometry.size.height * 0.3 / yRange
			
			return self.geometry.frame(in: .named("ChartSpace")).midY / scale
		}
	}
	
	private var priceArray: [HistoricalPrice] {
		
		get {
			var array: [HistoricalPrice] = []
			
			array.append(self.historicalPricesViewModel.results.min(by: {a, b in a.close ?? 0 < b.close ?? 0}) ?? HistoricalPrice())
			array.append(self.historicalPricesViewModel.results.max(by: {a, b in a.close ?? 0 < b.close ?? 0}) ?? HistoricalPrice())
			
			array.append(contentsOf: self.historicalPricesViewModel.results.dropFirst().dropLast().evenlySpaced(length: 2 * Int(self.dateMagnifyScale) / 2))
			
			return array
		}
		
	}
	
	private func feedbackSuccess() {
		let generator = UINotificationFeedbackGenerator()
		generator.notificationOccurred(.warning)
	}
	
	enum DragState {
		
		case inactive
		case pressing
		case magnifying(value: CGFloat)
		case draggingMove(translation: CGSize)
		case draggingSelect
		
		var translation: CGSize {
			switch self {
			case .inactive, .pressing, .draggingSelect, .magnifying:
				return .zero
			case .draggingMove(let translation):
				return translation
			}
			
		}
		
		var magnifyScale: CGFloat {
			switch self {
				
			case .magnifying(let value):
				return value
				
			default:
				return 1
			}
		}
		
		var isSelecting: Bool {
			switch self {
			case .draggingSelect:
				return true
			default:
				return false
			}
		}
		
		
		
	}
	
	@GestureState var dragState = DragState.inactive
	
	@State var viewState: CGSize = .zero
	
	@State var selectionPosition: CGPoint = .zero
	
	@State var pricesIndex: Int? = nil
	
	var dragGesture: some Gesture {
		
		DragGesture(coordinateSpace: .local)
			.updating(self.$dragState) { value, state, transaction in
				
				switch state {
				case .draggingSelect:
					return
				default:
					state = .draggingMove(translation: value.translation)
				}
				
		}
		.onEnded { (value) in
			
			withAnimation {
				self.viewState.width += value.translation.width
			}
		}
	}
	
	var longPressDrag: some Gesture {
		
		LongPressGesture(minimumDuration: 0.3)
			//			.onChanged({ (value) in
			//				self.feedbackSuccess()
			//
			//			})
			.sequenced(before: self.selectGesture)
			.updating(self.$dragState) { (value, state, transaction) in
				switch value {
				case .first(true):
					state = .pressing
					
				case .second(true, _):
					state = .draggingSelect
					
				default:
					state = .inactive
				}
		}
		.simultaneously(with:
			TapGesture(count: 2)
				.onEnded({ (value) in
					withAnimation {
						self.magnifyScale = 1
						self.dateMagnifyScale = 1
						self.viewState = .zero
					}
				})
		)
		
	}
	
	var selectGesture: some Gesture {
		
		DragGesture(minimumDistance: 0, coordinateSpace: .local)
			.onChanged { (value) in
				let location = value.location
				
				self.selectionPosition = location
				
				let index = (location.x / self.magnifyScale) / (self.geometry.size.width / CGFloat(self.historicalPricesViewModel.results.count))
				
				if index >= 0 && index < CGFloat(self.historicalPricesViewModel.results.count) {
					self.pricesIndex = Int(index)
				}
					
				else {
					self.pricesIndex = nil
				}
		}
		.onEnded { (value) in
			self.selectionPosition = value.location
			self.pricesIndex = nil
			self.feedbackSuccess()
		}
		
	}
	
	var magnification: some Gesture {
		
		MagnificationGesture()
			.updating(self.$dragState, body: { (value, state, transaction) in
				print("Is magnifying")
				state = .magnifying(value: value)
			})
			.onChanged({ (value) in
				self.magnifyScale = value
				if value > 1 {
					self.dateMagnifyScale = value
				}
			})
			.onEnded { (value) in
				if value > 1 && value < 5 {
					self.magnifyScale = value
					self.dateMagnifyScale = value
				}
				else {
					print("Too Large")
					self.magnifyScale = 1
					self.dateMagnifyScale = 1
					self.viewState = .zero
				}
		}
		.simultaneously(with: self.dragGesture)
	}
	
	var body: some View {
		
		VStack {
			HStack {
				Text("Chart")
				
				Spacer()
				
				if self.historicalPricesViewModel.dataIsLoaded {
					Text(String(format: "%.2f", self.historicalPricesViewModel.results.map({$0.close ?? 0})[self.pricesIndex ?? self.historicalPricesViewModel.results.count - 1]))
				}
				
				Spacer()
				
				VStack {
					Button(action: {
						self.isSelectingRange.toggle()
					}) {
						Text(self.rangeSelection.rawValue)
					}
					
					if self.isSelectingRange {
						
						ForEach(self.rangeList, id: \.self) { range in
							
							Button(action: {
								self.isSelectingRange.toggle()
								self.rangeSelection = range
							}) {
								Text(range.rawValue)
							}
							
						}
						
					}
					
				}
				
			}
			
			ZStack {
				
				if self.historicalPricesViewModel.dataIsLoaded {

							//Linear Gradient will be inverse
							ZStack {
								
								if self.dragState.isSelecting {
									
									Rectangle()
										.fill(Color(.systemGray))
										.frame(width: self.geometry.size.width * 0.01, height: self.geometry.frame(in: .named("ChartSpace")).height, alignment: .center)
										.position(x: self.selectionPosition.x, y: self.chartSpaceMidY)
								}
								
								ChartLine(geometry: geometry, data: self.historicalPricesViewModel.results.map({$0.close ?? 0}))
									.stroke(LinearGradient(gradient: Gradient(colors: [Color.green, Color.red]), startPoint: .bottom, endPoint: .top), style: StrokeStyle(lineWidth: 2, lineJoin: .round))
									.rotationEffect(.degrees(180), anchor: .center)
									.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
								
								ForEach(self.historicalPricesViewModel.results.evenlySpaced(length: 4 * Int(self.dateMagnifyScale)), id: \.date) { object in

									ZStack {
										self.createDateLabel(historicalPrice: object)
											.padding(.top)
									}
									
								}
								
//								ForEach(self.createPriceArray(), id: \.date) { object in
//
//									ZStack {
//										self.createPriceLabel(historicalPrice: object)
//									}
//								}
								
							}
							.frame(width: self.geometry.size.width * self.magnifyScale, height: self.geometry.size.height * 0.3)
							.background(Color("Card Background"))
							.coordinateSpace(name: "ChartSpace")
							.gesture(self.longPressDrag)
							.animation(nil)
							.offset(x: self.viewState.width + self.dragState.translation.width, y: 0)
						
//					}
					
				}
				else {
					
					ActivityIndicator(isLoading: self.$historicalPricesViewModel.dataIsLoaded)
						.frame(width: self.geometry.size.width * 0.9, height: self.geometry.size.height * 0.3, alignment: .center)
					
				}
				
				
			}
			.frame(width: self.geometry.size.width * 0.9, height: self.geometry.size.height * 0.3, alignment: .center)
			.background(Color("Card Background"))
			.clipShape(RoundedRectangle(cornerRadius: 20))
			.shadow(color: Color("Card Background"), radius: 8)
//			.gesture(self.longPressDrag)
			.gesture(self.magnification)
			.animation(.spring())
		}
		.padding()
		.onAppear {
			self.historicalPricesViewModel.dataIsLoaded = false
			self.historicalPricesViewModel.getHistoricalData(symbol: "ENPH", range: self.rangeSelection, useDate: false, date: "", sandbox: true)
		}
		
		
	}
	
	/*
	private func calculateStep(data: [Double], geometry: GeometryProxy) -> CGFloat{
		
		let step: CGFloat = CGFloat(Double(geometry.size.width) / Double(data.count))
		
		return CGFloat(step * self.magnifyScale * CGFloat(data.count))
		
	}
	*/
	
	private func createDateLabel(historicalPrice: HistoricalPrice) -> some View {
		
		let width: CGFloat = self.geometry.size.width
		
		let dataCount: CGFloat = CGFloat(self.historicalPricesViewModel.results.count)
		
		let step: CGFloat = width / dataCount
		
//		let yStep: CGFloat = self.geometry.size.height * 0.3 / dataCount
		
		let max: CGFloat = CGFloat(self.historicalPricesViewModel.results.map({$0.close ?? 0}).max() ?? 0)
		
		let min: CGFloat = CGFloat(self.historicalPricesViewModel.results.map({$0.close ?? 0}).min() ?? 0)
		
		let yRange: CGFloat = max + min
		
		let scale: CGFloat = self.geometry.size.height * 0.3 / yRange
		
		return ZStack {
			Text("\(historicalPrice.label ?? "")")
				.font(.subheadline)
				.fontWeight(.light)
				.opacity(0.7)
				.position(x: step * self.magnifyScale * CGFloat(self.historicalPricesViewModel.results.map({$0.label}).firstIndex(of: historicalPrice.label ?? "") ?? 0), y: max * scale)
			
			VerticalLine(x: step * self.magnifyScale * CGFloat(self.historicalPricesViewModel.results.map({$0.label}).firstIndex(of: historicalPrice.label ?? "") ?? 0), yStep: self.geometry.size.height * 0.01)
				.stroke(Color(.systemGray).opacity(0.5))
			
		}
		
	}
	
//	private func createPriceArray() -> Array<HistoricalPrice> {
//
//		var array: [HistoricalPrice] = []
//
//		array.append(self.historicalPricesViewModel.results.min(by: {a, b in a.close ?? 0 < b.close ?? 0}) ?? HistoricalPrice())
//		array.append(self.historicalPricesViewModel.results.max(by: {a, b in a.close ?? 0 < b.close ?? 0}) ?? HistoricalPrice())
//
//		array.append(contentsOf: self.historicalPricesViewModel.results.dropFirst().dropLast().evenlySpaced(length: 2 * Int(self.dateMagnifyScale) / 2))
//
//		return array
//
//	}
	
	private func createPriceLabel(historicalPrice: HistoricalPrice) -> some View {
		
		let width: CGFloat = self.geometry.size.width
		
		let dataCount: CGFloat = CGFloat(self.historicalPricesViewModel.results.count)
		
//		let step: CGFloat = width / dataCount
		
//		let yStep: CGFloat = self.geometry.size.height * 0.3 / dataCount
		
		//Inverse
		let max: CGFloat = CGFloat(self.historicalPricesViewModel.results.map({$0.close ?? 0}).max() ?? 0)
		
		let min: CGFloat = CGFloat(self.historicalPricesViewModel.results.map({$0.close ?? 0}).min() ?? 0)
		
		let yRange: CGFloat = max + min
		
		let scale: CGFloat = self.geometry.size.height * 0.3 / yRange
		
		return ZStack {
			Text(String(format: "%.2f", historicalPrice.close ?? 0))
				.font(.subheadline)
				.fontWeight(.light)
				.opacity(0.7)
				.position(x: 0, y: yRange * scale - CGFloat(historicalPrice.close ?? 0) * scale)
			
//			VerticalLine(x: step * self.magnifyScale * CGFloat(self.historicalPricesViewModel.results.map({$0.label}).firstIndex(of: historicalPrice.label ?? "") ?? 0), yStep: self.geometry.size.height * 0.01)
//				.stroke(Color(.systemGray).opacity(0.5))
			
		}
		
	}
	
}

struct ChartView_Previews: PreviewProvider {
	
	static var previews: some View {
		
		GeometryReader { geometry in
			ChartView(geometry: geometry)
		}
		
	}
	
}

struct VerticalLine: Shape {
	
	@State var x: CGFloat
	
	@State var yStep: CGFloat
	
	func path(in rect: CGRect) -> Path {
		var path = Path()
		
		var yCoord: CGFloat = 0
		
		for _ in 0..<Int(self.yStep * 2) {
			path.move(to: CGPoint(x: self.x, y: yCoord))
			
			yCoord += self.yStep
			
			path.addLine(to: CGPoint(x: self.x, y: yCoord))
			
			yCoord += self.yStep

		}
		
		return path
	}
}

struct ChartLine: Shape {
	
	var geometry: GeometryProxy
	
	@State var data: [Double]
	
	func path(in rect: CGRect) -> Path {
		var path = Path()
		
		let step: CGFloat = CGFloat(Double(rect.size.width) / Double(self.data.count))
		
		let yRange: CGFloat = CGFloat((self.data.max() ?? 0) + (self.data.min() ?? 0))
		
//		print(yRange)
		
		let scale: CGFloat = rect.size.height / yRange
		
//		print("step: \(step) | scale: \(scale)")
		
		var x: CGFloat = 0
		
		path.move(to: CGPoint(x: x * step, y: CGFloat(self.data.first ?? 0) * scale))
		
		self.data.forEach { price in
			
			path.addLine(to: CGPoint(x: x, y: CGFloat(price) * scale))
			
			x += (step)
			
		}
		
		return path
		
	}
	
}
