//
//  QuoteViewModel.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/18/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import CoreData

final class QuoteViewModel: ObservableObject {
	
	private lazy var networkSerivice: NetworkService = NetworkService()
	private var cancellable: AnyCancellable?
	
	@Published var results: Quote? = nil
	@Published var dataIsLoaded: Bool = false
	
	@FetchRequest(entity: Portfolio.entity(), sortDescriptors: [], predicate: NSPredicate(format: "symbol != %@", "Cash")) var portfolioWOCash: FetchedResults<Portfolio>
	
	@Environment(\.managedObjectContext) var moc
	
	private func updateValues(symbol: String, asset: FetchedResults<Portfolio>.Element) {
		
		let lp = self.results?.latestPrice ?? 0
		let shares = asset.shares
		
		asset.currentValue = lp * shares
		asset.currentPrice = lp
		
		try? self.moc.save()
		
		print("Saved Values for \(asset.symbol ?? "")")
		
	}
	
	func getData(symbol: String, sandbox: Bool, asset: FetchedResults<Portfolio>.Element) {
		
		self.cancellable =
			self.networkSerivice
				.getQuote(symbol: symbol, sandbox: sandbox)
				.receive(on: DispatchQueue.main)
				.catch { _ in Just(self.results) }
				//				.assign(to: \.results, on: self)
				.sink(receiveCompletion: { completion in
					switch completion {
						
					case .finished:
						
						self.updateValues(symbol: symbol, asset: asset)
						self.dataIsLoaded = true
						break
						
					case .failure(let error):
						fatalError("\(error)")
						
					}
				}, receiveValue: {
					self.results = $0
				})
		
//		if !(self.results. ?? true) {
//			self.dataIsLoaded = true
//		}
		
	}
}
