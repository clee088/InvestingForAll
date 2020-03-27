//
//  SupportedSymbolsModel.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/27/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

struct SupportedSymbol: Decodable {
	
	var symbol: String
	var exchange: String
	var name: String
	var date: String
	var type: String
	var iexId: String
	var region: String
	var currency: String
	var isEnabled: Bool
	var figi: String
	var cik: String
	
}

typealias SupportedSymbols = [SupportedSymbol]
