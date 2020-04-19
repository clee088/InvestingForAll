//
//  QuotesViewModel.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/16/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import Foundation
import Combine

final class QuoteBatchViewModel: ObservableObject {
	
	private lazy var networkSerivice: NetworkService = NetworkService()
	private var cancellable: AnyCancellable?
	
	@Published var results: QuoteBatch? = nil
	@Published var dataIsLoaded: Bool = false
	
	init(symbol: String, sandbox: Bool) {

		self.getData(symbol: symbol, sandbox: sandbox)

	}
	
	func getData(symbol: String, sandbox: Bool) {
		
		self.cancellable =
			self.networkSerivice
				.getBatchQuotes(symbol: symbol, sandbox: sandbox)
				.receive(on: RunLoop.main)
				.catch { _ in Just(self.results) }
				.assign(to: \.results, on: self)
		
		if !(self.results?.isEmpty ?? true) {
			self.dataIsLoaded = true
		}
		
	}
}
