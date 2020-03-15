//
//  QuoteModel.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/9/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct Quote: Decodable {
	
	var c: Double
	var h: Double
	var l: Double
	var o: Double
	var pc: Double
	var t: Int
	
}

class QuoteModel: ObservableObject {
	
	@Published var quoteResult: Quote?
	
	init(symbol: String) {
		self.getQuoteData(symbol: symbol)
	}
	
	private func getQuoteData(symbol: String) {
		let jsonUrlString = "https://finnhub.io/api/v1/quote?symbol=\(symbol)&token=bpjsg9nrh5r9328echa0"
		
		guard let url = URL(string: jsonUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
			print("Unable to get data")
			return
		}
		URLSession.shared.dataTask(with: url) { (data, response, err) in

			guard let data = data else {
				print("Error getting data")
				return
			}

			do {
				let quoteData = try JSONDecoder().decode(Quote.self, from: data)

				DispatchQueue.main.async {
					self.quoteResult = quoteData
				}


			}catch let jsonErr{
				print("Error serializing json:", jsonErr)
				}
		}.resume()
	}
	
}
