//
//  StockView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/9/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct SearchView: View {
	
	@State var ticker: String = ""
	
	@State private var searchResults: [SymbolList] = []
	
	@Binding var isPresented: Bool
	
	@State var presentStock: Bool = false
	
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
						
						SearchBar(text: self.$ticker, searchResults: self.$searchResults)
							.frame(width: geometry.size.width * 0.75)
							.offset(x: geometry.size.width * -0.125, y: 0)
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
										.onTapGesture {
											self.presentStock.toggle()
										}
									}
									.frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.08, alignment: .center)
									.background(Color("Card Light"))
									.mask(RoundedRectangle(cornerRadius: 25))
									.padding(.vertical)
									.sheet(isPresented: self.$presentStock) {
										StockView(companyName: result.description, symbol: result.symbol)
									}
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
		SearchView(isPresented: .constant(true))
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
	}
}
