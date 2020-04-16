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
	
}
