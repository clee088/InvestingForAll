//
//  NewsModel.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/30/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import Foundation

typealias News = [NewsItem]

struct NewsItem: Decodable {
	
	var datetime: Int?
	var headline: String?
	var source: String?
	var url: String?
	var summary: String?
	var related: String?
	var image: String?
	var lang: String?
	var hasPaywall: Bool?
	
}

final class NewsModel: ObservableObject {
	
	@Published var newsResults: News?
	@Published var imageData: Data?
	@Published var dataIsLoaded: Bool = false
	
	init(symbol: String, sandbox: Bool) {
		self.getNewsData(symbol: symbol, sandbox: sandbox)
	}
	
	func getNewsData(symbol: String, sandbox: Bool) {
		
		var jsonURL: String
		
		switch sandbox {
		case true:
			jsonURL = "https://sandbox.iexapis.com/stable/stock/\(symbol)/news?token=Tpk_40e51a7eb9b442aa87834a5071daed31"
		case false:
			jsonURL = "https://cloud.iexapis.com/stable/stock/\(symbol)/news?token=pk_ced9c1fec27547ca92d6333afe3adf60"
		}
		
		guard let url: URL = URL(string: jsonURL) else {
			print("Error forming URL")
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
				let newsData = try JSONDecoder().decode(News.self, from: data)
				
				DispatchQueue.main.async {
					self.newsResults = newsData
					
					self.dataIsLoaded = true
				}
				
			} catch let jsonErr {
				print("Error serializing json:", jsonErr)
			}
			
		}.resume()
		
	}
	
}
