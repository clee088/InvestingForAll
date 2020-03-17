//
//  StockView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/9/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct StockPresentView: View {
	
	@State var ticker: String = ""
	
	@State private var searchResults: [SymbolList] = []
	
	@Binding var isPresented: Bool
	
//	@State var width: CGFloat?
//	@State var heigth: CGFloat?
	
	var body: some View {
		
		GeometryReader { geometry in
			ZStack {
				VStack {
					
						HStack {
							
							ZStack {
								Capsule()
									.foregroundColor(Color.clear)
									.background(LinearGradient(gradient: Gradient(colors: [Color("Card Dark"), Color("Card")]), startPoint: .leading, endPoint: .trailing))
									.mask(Capsule())
								HStack {
									if self.isPresented {
										Spacer()
									}
									
									Image(systemName: self.isPresented ? "xmark" : "magnifyingglass")
										.foregroundColor(Color.white)
										.imageScale(.large)
										.aspectRatio(contentMode: .fit)
									
									if self.isPresented == false {
										Spacer()
									}
									
									
								}
								.padding()
								
							}
								//							.offset(x: self.viewState.width + geometryOne.size.width * 0.075, y: 0)
								//							.gesture(DragGesture()
								//							.onChanged { value in
								//								let currentLocation = value.location
								//
								////								let distance = center.distance(to:currentLocation)
								//								self.position = CGPoint(x: currentLocation.x, y: 0)
								//
								//							}
								//							.onEnded { value in
								//								self.position = value.location
								//							})
								.onTapGesture {
									withAnimation(.spring()) {
										self.isPresented.toggle()
									}
							}
							.frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.05)
							.offset(x: geometry.size.width * -0.125)
							
							Spacer()
							
							SearchBar(text: self.$ticker, searchResults: self.$searchResults)
						}
					
					
					ScrollView(.vertical) {
						if self.ticker != "" {
							VStack {
								ForEach(self.searchResults, id: \.self.symbol) { result in
									ZStack {
										HStack {
											Text(result.symbol)
												.font(.subheadline)
											
											Text(result.description)
												.font(.subheadline)
											
											Spacer()
										}
										.padding(.horizontal)
									}
									.frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.08, alignment: .center)
									.background(Color("Card"))
									.mask(RoundedRectangle(cornerRadius: 25))
									.padding(.vertical)
								}
							}
						}
					}
					
					Spacer()
					
				}
				
			}
			.padding(.bottom)
		}
	}
	
}

struct StockPresentView_Previews: PreviewProvider {
	
	static var previews: some View {
		StockPresentView(isPresented: .constant(true))
	}
}

struct StockView: View {
	
	@ObservedObject var candle: CandlesModel
	
	var data: [Float] = [298.81,289.32,302.74,292.92,289.03,266.17,285.34,275.43,248.23,278.02,298.81,289.32,302.74,292.92,289.03,266.17,285.34,275.43,248.23,278.02,298.81,289.32,302.74,292.92,289.03,266.17,285.34,275.43,248.23,278.02,]
	
	@State var color: Bool = false
	
	var body: some View {
		
		if self.candle.candlesResult?.c.first ?? 0 > self.candle.candlesResult?.c.last ?? 0 {
			self.color.toggle()
		}
		
		return ZStack {
			GeometryReader { geometry in
				ScrollView(.horizontal) {
					
					Path { path in
						
						var x = 0
						
						path.move(to: CGPoint(x: x, y: Int(self.candle.candlesResult?.c.first ?? 0)))
						
						self.candle.candlesResult?.c.forEach { price in
							
							path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(price)))
							
							x += (Int(geometry.size.width) / (self.candle.candlesResult?.c.count ?? 0))
							
						}
						
						
					}
					.stroke(self.color ? Color.green : Color.red, style: StrokeStyle(lineWidth: 2, lineJoin: .round))
					.frame(width: geometry.size.width, height: geometry.size.height)
					
				}
			}
		}
		.rotationEffect(.degrees(180), anchor: .center)
		.rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
		.padding()
	}
}

struct SearchBar: UIViewRepresentable {

    @Binding var text: String
	@Binding var searchResults: [SymbolList]
	
    class Coordinator: NSObject, UISearchBarDelegate {

        @Binding var text: String
		@Binding var searchResults: [SymbolList]
		@ObservedObject var symbolList: SymbolListModel = SymbolListModel()
		
		init(text: Binding<String>, searchResults: Binding<[SymbolList]>) {
            _text = text
			_searchResults = searchResults
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText

			DispatchQueue.main.async {

				if self.text != "" && self.text.count >= 2 {

					self.searchResults = self.symbolList.symbolListResults?.filter {
						$0.symbol.hasPrefix(self.text.uppercased()) || $0.description.contains(self.text.uppercased())
						} ?? []
				}


			}

        }
		
		func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
			searchBar.showsCancelButton.toggle()
		}
		
		func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//			searchBar.showsCancelButton.toggle()
		}
		
		func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
			searchBar.showsCancelButton.toggle()
			searchBar.resignFirstResponder()
		}
		
    }

    func makeCoordinator() -> SearchBar.Coordinator {
		return Coordinator(text: $text, searchResults: $searchResults)
    }

    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
		searchBar.showsCancelButton = false
        return searchBar
    }

    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}
