//
//  CandlesModel.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/15/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct HistoricalPrice: Decodable {
	
	var date: String?
	var high: Double?
	var low: Double?
	var volume: Double?
	var open: Double?
	var close: Double?
	var uHigh: Double?
	var uLow: Double?
	var uVolume: Double?
	var uOpen: Double?
	var uClose: Double?
	var changeOverTime: Double?
	var label: String?
	var change: Double?
	var changePercent: Double?
	
}

typealias HistoricalPrices = [HistoricalPrice]

//
//class CandlesModel: ObservableObject {
//
//	@Published var candlesResult: Candles?
//
//	init(symbol: String, interval: String, from: Int, to: Int) {
//		self.getCandlesData(symbol: symbol, interval: interval, from: from, to: to)
//	}
//
//	private func getCandlesData(symbol: String, interval: String, from: Int, to: Int) {
//		let jsonUrlString = "https://finnhub.io/api/v1/stock/candle?symbol=\(symbol)&resolution=\(interval)&from=\(from)&to=\(to)&token=bpjsg9nrh5r9328echa0"
//
//		guard let url = URL(string: jsonUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
//			print("Unable to get data")
//			return
//		}
//
//		URLSession.shared.dataTask(with: url) { (data, response, err) in
//
//			guard let data = data else {
//				print("Error getting data")
//				return
//			}
//
//			do {
//				let candleData = try JSONDecoder().decode(Candles.self, from: data)
//
//				DispatchQueue.main.async {
//					self.candlesResult = candleData
//				}
//
//
//			}catch let jsonErr{
//				print("Error serializing json:", jsonErr)
//				}
//		}.resume()
//	}
//
//}
//
