//
//  UserBalance.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/12/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

class UserBalance: ObservableObject {
	
	init() {
		UserDefaults.standard.register(defaults: ["Balance" : 1000])
	}
	
	@Published var balance = UserDefaults.standard.double(forKey: "Balance") {
		didSet {
			UserDefaults.standard.set(self.balance, forKey: "Balance")
		}
	}
	
}
