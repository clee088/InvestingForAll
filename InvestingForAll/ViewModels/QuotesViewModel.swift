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
	
	private lazy var networkService: NetworkService = NetworkService()
	private var cancellable: AnyCancellable?
	
	@Published var results: QuoteBatch? = nil
	@Published var dataIsLoaded: Bool = false
	
//	init(symbol: String, sandbox: Bool) {
//
//		self.getData(symbol: symbol, sandbox: sandbox)
//
//	}
	
	func getData(symbol: String, sandbox: Bool) {
		
		self.cancellable =
			self.networkService
				.getBatchQuotes(symbol: symbol, sandbox: sandbox)
				.receive(on: DispatchQueue.main)
				.catch { _ in Just(self.results) }
				.sink(receiveCompletion: { completion in
					
					switch completion {
					case .finished:
						self.dataIsLoaded = true
						print("Received Values for: \(symbol)")
						break
						
					case .failure(let error):
						print(error.localizedDescription)
						
					}
					
				}, receiveValue: { (result) in
					
					self.results = result
					
				})
		
		//		URLSession
		//			.shared
		//			.dataTaskPublisher(for: url)
		//			.map { $0.data }
		//			.decode(type: QuoteBatch?.self, decoder: JSONDecoder())
		//			.eraseToAnyPublisher()
		//			.receive(on: DispatchQueue.main)
		//			.sink(receiveCompletion: { completion in
		//
		//				self.dataIsLoaded = true
		//				print("Done with \(symbol)")
		//
		//			}, receiveValue: {result in
		//
		//				self.results = result
		//
		//			})
		//			.store(in: &cancellable)
		
	}
}
