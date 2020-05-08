//
//  HistoricalPricesViewModel.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/23/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import Foundation
import Combine

final class HistoricalPricesViewModel: ObservableObject {
	
	private lazy var networkService: NetworkService = NetworkService()
	private var cancellable: AnyCancellable?
	
	@Published var results: HistoricalPrices = HistoricalPrices()
	@Published var dataIsLoaded: Bool = false
	
	func getHistoricalData(symbol: String, range: ChartRange, useDate: Bool, date: String, sandbox: Bool) {
		
		self.cancellable =
		self.networkService
			.getHistoricalData(symbol: symbol, range: range, useDate: false, date: "", sandbox: true)
			.receive(on: DispatchQueue.main)
			.catch { _ in Just(self.results) }
			.sink(receiveCompletion: { completion in
				
				switch completion {
				case .finished:
					self.dataIsLoaded = true
					break
					
				case .failure(let error):
					print(error.localizedDescription)
					
				}
				
			}, receiveValue: { (result) in
				self.results = result
			})

	}
	
}
