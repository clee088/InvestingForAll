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
/*

{
  "symbol": "TWTR",
  "companyName": "Twitter, Inc.",
  "primaryExchange": "Nwoha xkYEken gccter oS",
  "calculationPrice": "tops",
  "open": null,
  "openTime": null,
  "close": null,
  "closeTime": null,
  "high": null,
  "low": null,
  "latestPrice": 26.9,
  "latestSource": "IEX real time price",
  "latestTime": "12:30:00 PM",
  "latestUpdate": 1618565190986,
  "latestVolume": null,
  "iexRealtimePrice": 26.55,
  "iexRealtimeSize": 102,
  "iexLastUpdated": 1601996594607,
  "delayedPrice": null,
  "delayedPriceTime": null,
  "oddLotDelayedPrice": null,
  "oddLotDelayedPriceTime": null,
  "extendedPrice": null,
  "extendedChange": null,
  "extendedChangePercent": null,
  "extendedPriceTime": null,
  "previousClose": 30.27,
  "previousVolume": 29338701,
  "change": -3.14,
  "changePercent": -0.10594,
  "volume": null,
  "iexMarketPercent": 0.03079308043574499,
  "iexVolume": 361632,
  "avgTotalVolume": 25948713,
  "iexBidPrice": 26,
  "iexBidSize": 262,
  "iexAskPrice": 26.4,
  "iexAskSize": 103,
  "marketCap": 21237200218,
  "peRatio": 13.81,
  "week52High": 47.3,
  "week52Low": 26.98,
  "ytdChange": -0.19856,
  "lastTradeTime": 1650231071302,
  "isUSMarketOpen": true
}

struct Quote: Decodable {
	
	var symbol: String?
	var companyName: String?
	var latestPrice: Double?
	var change: Double?
	var changePercent: Double?
	var marketCap: Int?
	var peRatio: Double?
	var ytdChange: Double?
	
}
*/

struct Quote: Decodable {
	
	var o: Double?
	var h: Double?
	var l: Double?
	var c: Double?
	var pc: Double?
	var t: Int?
	
}


class QuoteModel: ObservableObject {
	
	@Published var quoteResult: Quote?
	
	init(symbol: String) {
		self.getQuoteData(symbol: symbol)
	}
	
	private func getQuoteData(symbol: String) {
		
//		var jsonUrlString: String
		
//		switch sandbox {
//		case true:
//			jsonUrlString = "https://sandbox.iexapis.com/stable/stock/\(symbol)/quote?token=Tpk_40e51a7eb9b442aa87834a5071daed31"
//		case false:
//			jsonUrlString = "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=pk_ced9c1fec27547ca92d6333afe3adf60"
//		}
		
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
