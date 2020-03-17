//
//  SymbolListModel.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/16/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct SymbolList: Decodable {
	var description: String
	var displaySymbol: String
	var symbol: String
}

class SymbolListModel: ObservableObject {
	
	@Published var symbolListResults: [SymbolList]?
	
	init() {
		self.getSymbolListData()
	}
	
	private func getSymbolListData() {
//		let jsonUrlString = "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=bpjsg9nrh5r9328echa0"
		let path = Bundle.main.url(forResource: "USSymbols", withExtension: "json")
		guard let url = path else {
			print("Unable to get data")
			return
		}
		URLSession.shared.dataTask(with: url) { (data, response, err) in
			
			guard let data = data else {
				print("Error getting data")
				return
			}

			do {
				let symbolListData = try JSONDecoder().decode([SymbolList].self, from: data)

				DispatchQueue.main.async {
					self.symbolListResults = symbolListData
//					print(self.symbolListResults)
				}


			}catch let jsonErr{
				print("Error serializing json:", jsonErr)
				}
		}.resume()
	}
	
}

