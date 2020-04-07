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
	
	let numberFormatter = NumberFormatter()
	
	private func roundedNumberString(number: Double) -> String {
		
		var rn: String = ""
		
		//MARK: Thousand
		//1,000 -> 1,000,000
		if number >= 1000 && number < 1000000 {
			let n = number / 1000
			
			rn = "\(String(format: "%.2f", n))K"
			
		}
			
			//MARK: Million
			//1,000,000 -> 1,000,000,000
		else if number >= 1000000 && number < 1000000000 {
			let n = number / 1000000
			
			rn = "\(String(format: "%.2f", n))M"
			
		}
			
			//MARK: Billion
			//1,000,000,000 -> 1,000,000,000,000
		else if number >= 1000000000 && number < 1000000000000 {
			let n = number / 1000000000
			
			rn = "\(String(format: "%.2f", n))B"
			
		}
			
			//MARK: Trillion
			//1,000,000,000,000 -> 1,000,000,000,000,000
		else if number >= 1000000000000 && number < 1000000000000000 {
			let n = number / 1000000000000
			
			rn = "\(String(format: "%.2f", n))T"
			
		}
			
		else {
			rn = String(format: "%.0f", number)
		}
		
		return rn
		
	}
	
	var body: some View {
		
		numberFormatter.numberStyle = .decimal
		
		return ZStack {
			GeometryReader { geometry in
				
				VStack {
					
					VStack {
						HStack {
							
							VStack(alignment: .leading) {
								HStack {
									Image(uiImage: UIImage(data: self.image.imageData ?? Data()) ?? UIImage(systemName: "exclamationmark.triangle")!)
										.resizable()
										.frame(width: geometry.size.width * 0.1, height: geometry.size.width * 0.1, alignment: .center)
										.mask(Circle())
									
									Text("\(self.symbol)")
										.font(.title)
										.fontWeight(.semibold)
										.foregroundColor(self.colorScheme == .light ? Color.white : Color.black)
									//									.bold()
									
									Spacer()
									
									Button(action: {
										self.isPresented.toggle()
									}) {
										Image(systemName: "magnifyingglass")
											.imageScale(.large)
											.foregroundColor(self.colorScheme == .light ? Color.white : Color.black)
										
									}
									
								}
								
								Text("\(self.companyName)")
									.font(.subheadline)
									.fontWeight(.medium)
									.foregroundColor(self.colorScheme == .light ? Color.white : Color.black)
								//								.bold()
							}
							
						}
						.padding(.horizontal)
						
						
						//					if self.quote.dataIsLoaded {
						HStack {
							
							Text("$\(String(format: "%.2f", self.quote.quoteResult?.latestPrice ?? 32.38))")
								.bold()
								.font(.title)
								.foregroundColor(self.colorScheme == .light ? Color.white : Color.black)
							//								.font(.system(size: 22))
							
							VStack(alignment: .leading) {
								
								Text(String(format: "%.2f", self.quote.quoteResult?.change ?? -3.75))
									.font(.system(size: 15))
									.foregroundColor((self.quote.quoteResult?.change ?? -3.75) > 0 ? Color.green : Color.red)
								
								Text("\(String(format: "%.2f", (self.quote.quoteResult?.changePercent ?? -0.1038) * 100))%")
									.font(.system(size: 15))
									.foregroundColor((self.quote.quoteResult?.change ?? -3.75) > 0 ? Color.green : Color.red)
								
							}
							
							Spacer()
							
							Button(action: {
								withAnimation(.spring()) {
									self.showStatistics.toggle()
								}
							}) {
								HStack {
									
									Text(self.showStatistics ? " Hide Statistics" : "Statistics")
										.font(.caption)
									
									Image(systemName: "arrow.down.square")
										.imageScale(.medium)
										.rotationEffect(.degrees(self.showStatistics ? -180 : 0))
								}
								.foregroundColor(self.colorScheme == .light ? Color.white : Color.black)
							}
							
							
						}
						.padding(.horizontal)
						//					} else {
						//						Text("Unavailable... Reloading")
						//							.bold()
						//							.padding()
						//							.onAppear() {
						//
						//								if self.news.dataIsLoaded == false {
						//									DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
						//										if self.news.dataIsLoaded == false {
						//											self.news.getNewsData(symbol: self.symbol, sandbox: self.developer.sandboxMode)
						//										}
						//									}
						//								}
						//
						//								if self.quote.dataIsLoaded == false {
						//									DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
						//										if self.quote.dataIsLoaded == false {
						//											self.quote.getData(symbol: self.symbol, sandbox: self.developer.sandboxMode)
						//										}
						//									}
						//								}
						//						}
						//					}
						
					}
					.padding(.top)
					
					ZStack {
						
						ScrollView(.vertical) {
							VStack {
								
								if self.showStatistics {
									
									ZStack {
										
										VStack(alignment: .leading) {
											
											HStack {
												VStack(alignment: .leading) {
													Text("Market Cap:")
														.font(.subheadline)
													
													Text(self.roundedNumberString(number: Double(self.quote.quoteResult?.marketCap ?? 3990000000)))
														.font(.subheadline)
														.bold()
													
													Spacer()
												}
												
												Spacer()
												
												VStack(alignment: .trailing) {
													Text("Prev Close/Open:")
														.font(.subheadline)
													
													
													Text("\(String(format: "%.2f", self.quote.quoteResult?.previousClose ?? 36.13))/\(String(format: "%.2f", self.quote.quoteResult?.open ?? 34.05))")
														.font(.subheadline)
														.bold()
													
													Spacer()
												}
											}
											
											HStack {
												VStack(alignment: .leading) {
													Text("Volume:")
														.font(.subheadline)
													
													
													Text(self.roundedNumberString(number: self.quote.quoteResult?.volume ?? 5000000))
														.font(.subheadline)
														.bold()
													
													
													Spacer()
												}
												
												Spacer()
												
												VStack(alignment: .trailing) {
													Text("Day's Range:")
														.font(.subheadline)
													
													
													Text("\(String(format: "%.2f", self.quote.quoteResult?.low ?? 31.27)) - \(String(format: "%.2f", self.quote.quoteResult?.high ?? 34.49))")
														.font(.subheadline)
														.bold()
													
													
													Spacer()
												}
												
											}
											
											HStack {
												VStack(alignment: .leading) {
													Text("PE Ratio:")
														.font(.subheadline)
													
													
													Text(String(self.quote.quoteResult?.peRatio ?? 26.65))
														.font(.subheadline)
														.bold()
													
													
													Spacer()
												}
												
												Spacer()
												
												VStack(alignment: .trailing) {
													Text("52 Week Range:")
														.font(.subheadline)
													
													
													Text("\(String(format: "%.2f", self.quote.quoteResult?.week52Low ?? 9.06)) - \(String(format: "%.2f", self.quote.quoteResult?.week52High ?? 59.15))")
														.font(.subheadline)
														.bold()
													
													
													Spacer()
												}
											}
											
											Spacer()
										}
										.padding()
									}
									.padding(.top)
									.frame(minWidth: geometry.size.width * 0.9, maxHeight: geometry.size.height * 0.2)
									.transition(.move(edge: .top))
									.background(self.colorScheme == .light ? Color("Card Light") : Color("Card Dark"))
									.mask(RoundedRectangle(cornerRadius: 25))
									.shadow(color: self.colorScheme == .light ? Color("Shadow Light") : Color("Search Dark"), radius: 5, x: 0, y: 5)
									
									
								}
								
								Spacer(minLength: geometry.size.height * 0.02)
								
								//								StockChart(candle: CandlesModel(symbol: self.symbol, interval: "D", from: 1583055000, to: 1584115200), width: geometry.size.width * 0.9, height: geometry.size.height * 0.3)
								RoundedRectangle(cornerRadius: 25)
									.fill(self.colorScheme == .light ? Color("Card Light") : Color("Card Dark"))
									.frame(height: geometry.size.height * 0.3, alignment: .center)
									.animation(.spring())
									.shadow(color: self.colorScheme == .light ? Color("Shadow Light") : Color("Search Dark"), radius: 5, x: 0, y: 5)
								
								Spacer(minLength: geometry.size.height * 0.05)
								
								NewsView(height: geometry.size.height, news: self.news, showNewsArticle: self.$showNewsArticle)
									.frame(height: geometry.size.height * 0.4, alignment: .center)
									.padding()
									.background(self.colorScheme == .light ? Color("Card Light") : Color("Card Dark"))
									.mask(RoundedRectangle(cornerRadius: 25))
									.shadow(color: self.colorScheme == .light ? Color("Shadow Light") : Color("Search Dark"), radius: 5, x: 0, y: 5)
									.animation(.spring())
								
								Spacer(minLength: geometry.size.height * 0.1)
								
							}
							.padding(.horizontal)
							
						}
						.background(Color.white)
						.clipShape(RoundedRectangle(cornerRadius: 40))
						
						
						
					}
//					.edgesIgnoringSafeArea(.vertical)
					
				}
				.background(Color("Search Dark"))
				.edgesIgnoringSafeArea(.vertical)
				
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

//MARK: Stock Chart
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
		.background(self.colorScheme == .light ? Color("Card Light") : Color("Card Dark"))
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

//MARK: News View
struct NewsView: View {
	
	@State var height: CGFloat
	@ObservedObject var news: NewsModel
	@Binding var showNewsArticle: Bool
	
	@State var newsArticleURLString: String = ""
	
	var body: some View {
		
		return VStack {
			HStack {
				Text("News")
					.font(.headline)
				
				Spacer()
			}
			
			if self.news.dataIsLoaded {
				ScrollView(.vertical) {
					ForEach(self.news.newsResults ?? [], id: \.url) { newsItem in
						VStack {
							HStack {
								NewsRow(newsItem: newsItem)
							}
							
							Divider()
						}
						.frame(minHeight: self.height * 0.15)
						.onTapGesture {
							self.newsArticleURLString = newsItem.url ?? ""
							self.showNewsArticle.toggle()
						}
						
					}
				}
				.sheet(isPresented: self.$showNewsArticle) {
					SFSafariView(urlString: self.newsArticleURLString)
				}
			} else {
				VStack {
					Spacer()
					ActivityIndicator(isLoading: self.$news.dataIsLoaded)
					Spacer()
				}
			}
			
			Spacer()
		}
		
	}
}

struct NewsRow: View {
	
	@State var newsItem: NewsItem
	
	var body: some View {
		
		return GeometryReader { geometry in
			ZStack {
				VStack {
					HStack {
						Text(self.newsItem.headline ?? "N/A")
							.font(.subheadline)
							.bold()
							.lineLimit(nil)
							.multilineTextAlignment(.leading)
						
						Spacer()
						
						Image(uiImage: (UIImage(data: self.displayImage()) ?? UIImage(systemName: "exclamationmark.triangle"))!)
							.resizable()
							.aspectRatio(contentMode: .fit)
							.frame(minWidth: geometry.size.width * 0.2, minHeight: geometry.size.width * 0.2)
						//						.frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3, alignment: .center)
						
					}
					
					HStack {
						Text(self.newsItem.source ?? "N/A")
							.font(.subheadline)
						
						Spacer()
					}
				}
				.padding(.bottom)
			}
		}
		
	}
	
	func displayImage() -> Data {
		
		var data = Data()
		
		guard let imageURL: URL = URL(string: self.newsItem.image ?? "") else {
			return Data()
		}
		
		guard let imageData: Data = try? Data(contentsOf: imageURL) else {
			return Data()
		}
		
		data = imageData
		
		return data
		
	}
	
}
