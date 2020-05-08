//
//  NetworkService.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/16/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import Foundation
import Combine

final class NetworkService {
	
	func getBatchQuotes(symbol: String, sandbox: Bool) -> AnyPublisher<QuoteBatch?, Error> {
		
		var jsonUrlString: String

		switch sandbox {
		case true:
			jsonUrlString = "https://sandbox.iexapis.com/stable/stock/market/batch?symbols=\(symbol)&types=quote&token=Tpk_40e51a7eb9b442aa87834a5071daed31"
		case false:
			jsonUrlString = "https://cloud.iexapis.com/stable/stock/market/batch?symbols=\(symbol)&types=quote&token=pk_ced9c1fec27547ca92d6333afe3adf60"
		}
		
		guard let url = URL(string: jsonUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
			fatalError("Invalid URL!")
		}
		
		return URLSession
			.shared
			.dataTaskPublisher(for: url)
			.map { $0.data }
			.decode(type: QuoteBatch?.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}
	
	func getQuote(symbol: String, sandbox: Bool) -> AnyPublisher<Quote?, Error> {
		
		var jsonUrlString: String
		
		switch sandbox {
		case true:
			jsonUrlString = "https://sandbox.iexapis.com/stable/stock/\(symbol)/quote?token=Tpk_40e51a7eb9b442aa87834a5071daed31"
		case false:
			jsonUrlString = "https://cloud.iexapis.com/stable/stock/\(symbol)/quote?token=pk_ced9c1fec27547ca92d6333afe3adf60"
		}
		
		guard let url = URL(string: jsonUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
			fatalError("Invalid URL!")
		}
		
		return URLSession
			.shared
			.dataTaskPublisher(for: url)
			.map { $0.data }
			.decode(type: Quote?.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}
	
	func getHistoricalData(symbol: String, range: ChartRange, useDate: Bool, date: String, sandbox: Bool) -> AnyPublisher<HistoricalPrices, Error> {
		
		var jsonUrlString: String
		
		switch useDate {
			
		case true:
			
			switch sandbox {
			case true:
				jsonUrlString = "https://sandbox.iexapis.com/stable/stock/\(symbol)/chart/\(date)?token=Tpk_40e51a7eb9b442aa87834a5071daed31"
			case false:
				jsonUrlString = "https://cloud.iexapis.com/stable/stock/\(symbol)/chart/\(date)?token=pk_ced9c1fec27547ca92d6333afe3adf60"
			}
			
		case false:
			
			switch sandbox {
			case true:
				jsonUrlString = "https://sandbox.iexapis.com/stable/stock/\(symbol)/chart/\(range.rawValue)?token=Tpk_40e51a7eb9b442aa87834a5071daed31"
			case false:
				jsonUrlString = "https://cloud.iexapis.com/stable/stock/\(symbol)/chart/\(range.rawValue)?token=pk_ced9c1fec27547ca92d6333afe3adf60"
			}
			
		}
		
		guard let url = URL(string: jsonUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
			fatalError("Invalid URL!")
		}
		
		print(url)
		
		return URLSession
			.shared
			.dataTaskPublisher(for: url)
			.map { $0.data }
			.decode(type: HistoricalPrices.self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
		
	}
	
}

enum ChartRange: String {
	
	case max = "max"
	case fiveYear = "5y"
	case twoYear = "2y"
	case oneYear = "1y"
	case yearToDate = "ytd"
	case sixMonth = "6m"
	case threeMonth = "3m"
	case oneMonthDefault = "1m"
	case oneMonthThirty = "1mm"
	case fiveDay = "5d"
	case fiveDayTenMinute = "5dm"
	case date
	case dynamic = "dynamic"
	
}
