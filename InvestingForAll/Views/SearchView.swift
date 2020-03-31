//
//  StockView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/9/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct SearchView: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@EnvironmentObject var developer: DeveloperModel
	
	@State var ticker: String = ""
	
	@State private var searchResults: SupportedSymbols = []
	
	@Binding var isPresented: Bool
	
	@State var presentStock: Bool = false
	
	@State private var selectedStock: SupportedSymbol?
	
	var body: some View {
		
		GeometryReader { geometry in
			ZStack {
				VStack {
					
					HStack {
						
						ZStack {
							Capsule()
								.foregroundColor(Color.clear)
								.background(LinearGradient(gradient: Gradient(colors: [Color("Search Dark"), Color("Search Light")]), startPoint: .leading, endPoint: .trailing))
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
						.onTapGesture {
							withAnimation(.spring()) {
								self.isPresented.toggle()
							}
						}
						.frame(width: geometry.size.width * 0.25, height: geometry.size.height * 0.05)
						.offset(x: geometry.size.width * -0.125, y: 0)
						
						Spacer()
						
						SearchBar(text: self.$ticker, searchResults: self.$searchResults, isPresented: self.$isPresented)
							.frame(width: geometry.size.width * 0.75)
							.offset(x: geometry.size.width * -0.125, y: 0)
					}
					
					
					ScrollView(.vertical) {
						if self.ticker != "" {
							VStack {
								
								ForEach(self.searchResults, id: \.self.iexId) { result in
									
									ZStack {
										HStack {
											Text(result.symbol)
												.font(.subheadline)
											
											Text(result.name)
												.font(.subheadline)
											
											Spacer()
										}
										.padding(.horizontal)
									}
									.frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.08, alignment: .center)
									.background(self.colorScheme == .light ? Color("Card Light") : Color("Card Dark"))
									.mask(RoundedRectangle(cornerRadius: 25))
									.padding(.vertical)
									.onTapGesture {
										self.selectedStock = result
										self.presentStock.toggle()
									}
								}
							}
							.sheet(isPresented: self.$presentStock) {
								StockView(companyName: self.selectedStock?.name ?? "", symbol: self.selectedStock?.symbol ?? "", image: LogoModel(symbol: self.selectedStock?.symbol ?? "", sandbox: self.developer.sandboxMode), quote: QuoteModel(symbol: self.selectedStock?.symbol ?? "", sandbox: true), news: NewsModel(symbol: self.selectedStock?.symbol ?? "", sandbox: self.developer.sandboxMode)).environmentObject(self.developer)
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
		SearchView(isPresented: .constant(true))
	}
}

struct SearchBar: UIViewRepresentable {
	
	@Binding var text: String
	@Binding var searchResults: SupportedSymbols
	@Binding var isPresented: Bool
	
	class Coordinator: NSObject, UISearchBarDelegate {
		
		@Binding var text: String
		@Binding var searchResults: SupportedSymbols
		@ObservedObject var symbolList: SupportedSymbolModel = SupportedSymbolModel()
		
		init(text: Binding<String>, searchResults: Binding<SupportedSymbols>) {
			_text = text
			_searchResults = searchResults
		}
		
		func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
			text = searchText
			
			DispatchQueue.main.async {
				
				if self.text != "" && self.text.count >= 2 {
					
					self.searchResults = self.symbolList.supportedSymbolsResults?.filter {
						$0.symbol.hasPrefix(self.text.uppercased()) || $0.name.contains(self.text.capitalized)
						} ?? []
				}
				
				
			}
			
		}
		
		func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
			searchBar.showsCancelButton.toggle()
		}
		
		func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
			searchBar.resignFirstResponder()
		}
		
		func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
			searchBar.showsCancelButton.toggle()
			searchBar.resignFirstResponder()
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
		searchBar.placeholder = "Quote Lookup"
		return searchBar
	}
	
	func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
		uiView.text = text
		if self.isPresented == false {
			uiView.resignFirstResponder()
		}
	}
}
