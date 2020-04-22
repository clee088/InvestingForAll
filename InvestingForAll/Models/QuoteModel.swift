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

// MARK: - QuoteBatchValue
struct QuoteBatchValue: Decodable {
    var quote: Quote?
}

// MARK: - Quote
struct Quote: Decodable {
    var symbol, companyName, primaryExchange: String?
    var calculationPrice: String?
    var openSource: String?
    var open, close, closeTime: Double?
    var closeSource: String?
    var high: Double?
    var highTime: Int?
    var highSource: String?
    var low: Double?
    var lowTime: Int?
    var lowSource: String?
    var latestPrice: Double?
    var latestSource: String?
    var latestTime: String?
    var latestUpdate: Int?
    var latestVolume: Double?
    var iexRealtimePrice: Double?
    var iexRealtimeSize, iexLastUpdated: Int?
    var delayedPrice, delayedPriceTime, oddLotDelayedPrice, oddLotDelayedPriceTime: Double?
    var extendedPrice, extendedChange, extendedChangePercent, extendedPriceTime: Double?
    var previousClose: Double?
    var previousVolume: Int?
    var change, changePercent: Double?
    var volume: Double?
    var iexMarketPercent: Double?
    var iexVolume, avgTotalVolume: Int?
    var iexBidPrice: Double?
    var iexBidSize: Int?
    var iexAskPrice: Double?
    var iexAskSize: Int?
    var iexOpen, iexOpenTime: Double?
    var iexClose: Double?
    var iexCloseTime, marketCap: Int?
    var peRatio: Double?
    var week52High, week52Low, ytdChange: Double?
    var lastTradeTime: Int?
    var isUsMarketOpen: Bool?

    enum CodingKeys: String, CodingKey {
        case symbol, companyName, primaryExchange, calculationPrice
        case openSource, open, close, closeTime, closeSource, high, highTime, highSource, low, lowTime, lowSource, latestPrice, latestSource, latestTime, latestUpdate, latestVolume, iexRealtimePrice, iexRealtimeSize, iexLastUpdated, delayedPrice, delayedPriceTime, oddLotDelayedPrice, oddLotDelayedPriceTime, extendedPrice, extendedChange, extendedChangePercent, extendedPriceTime, previousClose, previousVolume, change, changePercent, volume, iexMarketPercent, iexVolume, avgTotalVolume, iexBidPrice, iexBidSize, iexAskPrice, iexAskSize, iexOpen, iexOpenTime, iexClose, iexCloseTime, marketCap, peRatio, week52High, week52Low, ytdChange, lastTradeTime
        case isUsMarketOpen = "isUSMarketOpen"
    }
}

typealias QuoteBatch = [String: QuoteBatchValue]

struct Logo: Decodable {
	var url: String
}

class LogoModel: ObservableObject {
	
	@Published var dataIsLoaded: Bool = false
	@Published var imageData: Data?
	
	init(symbol: String, sandbox: Bool) {
		self.getLogo(symbol: symbol, sandbox: sandbox)
	}
	
	func getLogo(symbol: String, sandbox: Bool) {
		
		var jsonUrlString: String

		switch sandbox {
		case true:
			jsonUrlString = "https://sandbox.iexapis.com/stable/stock/\(symbol)/logo?token=Tpk_40e51a7eb9b442aa87834a5071daed31"
		case false:
			jsonUrlString = "https://cloud.iexapis.com/stable/stock/\(symbol)/logo?token=pk_ced9c1fec27547ca92d6333afe3adf60"
		}
		
		guard let url = URL(string: jsonUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
			print("Unable to form URL")
			return
		}
		
		URLSession.shared.dataTask(with: url) { (data, response, err) in
			
			guard err == nil else {
				print("error: \(err!)")
				return
			}
			
			guard let data = data else {
				print("Error getting data")
				return
			}
			
			do {
				let quoteData = try JSONDecoder().decode(Logo.self, from: data)
				
				DispatchQueue.main.async {
					
					guard let imageURL: URL = URL(string: quoteData.url) else {
						print("Unable to find image url")
						return
					}
					
					print(imageURL)
					
					guard let imageData: NSData = NSData(contentsOf: imageURL) else {
						print("Unable to process image data")
						return
					}
					self.imageData = imageData as Data
				}
				
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
			
		}.resume()
		
	}
	
}


//MARK: Moved to Combine - Check ViewModels

class QuoteModel: ObservableObject {
	
	@Published var dataIsLoaded: Bool = false
	@Published var quoteResult: Quote?
	
	init(symbol: String, sandbox: Bool) {
		self.getData(symbol: symbol, sandbox: sandbox)
	}
	
	func getData(symbol: String, sandbox: Bool) {
		
		var jsonUrlString: String
		
		switch sandbox {
		case true:
			jsonUrlString = "https://sandbox.iexapis.com/stable/stock/\(symbol)/quote?token=Tpk_40e51a7eb9b442aa87834a5071daed31"
		case false:
			jsonUrlString = "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=pk_ced9c1fec27547ca92d6333afe3adf60"
		}
		
		guard let url = URL(string: jsonUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
			print("Unable to form URL")
			return
		}
		
		print(url)
		
		URLSession.shared.dataTask(with: url) { (data, response, err) in
			
			guard err == nil else {
				print("error: \(err!)")
				return
			}
			
			guard let data = data else {
				print("Error getting data")
				return
			}
			
			do {
				let quoteData = try JSONDecoder().decode(Quote.self, from: data)
				
				DispatchQueue.main.async {
					self.quoteResult = quoteData
					self.dataIsLoaded = true
				}
				
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
			
		}.resume()
		
	}
	
}

class QuoteBatchModel: ObservableObject {
	
	@Published var dataIsLoaded: Bool = false
	@Published var quoteResult: QuoteBatch? = nil
	
	init(symbol: String, sandbox: Bool) {
		
		self.getQuoteData(symbol: symbol, sandbox: sandbox)
		
	}
	
	func getQuoteData(symbol: String, sandbox: Bool) {
		
		var jsonUrlString: String

		switch sandbox {
		case true:
			jsonUrlString = "https://sandbox.iexapis.com/stable/stock/market/batch?symbols=\(symbol)&types=quote&token=Tpk_40e51a7eb9b442aa87834a5071daed31"
		case false:
			jsonUrlString = "https://cloud.iexapis.com/stable/stock/market/batch?symbols=\(symbol)&types=quote&token=pk_ced9c1fec27547ca92d6333afe3adf60"
		}
		
//		let jsonUrlString = "https://finnhub.io/api/v1/quote?symbol=\(symbol)&token=bpjsg9nrh5r9328echa0"
		
		guard let url = URL(string: jsonUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
			print("Unable to get data")
			return
		}
//		print("\(url) | \(symbol)")
		
		URLSession.shared.dataTask(with: url) { (data, response, err) in

			guard err == nil else {
                print ("error: \(err!)")
                return
            }
			
			guard let data = data else {
				print("Error getting data")
				return
			}
			
			do {
				
				let quoteData = try JSONDecoder().decode(QuoteBatch.self, from: data)
				
				DispatchQueue.main.async {
//					let quoteDataSorted = quoteData.sorted(by: {$0.0 < $1.0} )
//					let symbols: [String] = quoteDataSorted.map { $0.key }
//					let symbolData: [QuoteBatchValue] = quoteDataSorted.map { $0.value }
//
//
//					for index in 0..<quoteDataSorted.count {
//						let data: QuoteBatchValue = symbolData[index]
//						print("\(symbols[index]) | \(data.quote?.companyName ?? "N/A") | \((data.quote?.changePercent ?? 0) * 100)")
//					}
					
					self.quoteResult = quoteData
					self.dataIsLoaded = true
					
				}
				
				
			}catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
		}.resume()
	}
	
}

