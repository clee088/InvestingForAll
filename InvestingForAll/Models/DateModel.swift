//
//  DateModel.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 5/7/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import Foundation
import Combine

class DateModel: ObservableObject {
	
	@Published var calendar: Calendar = Calendar.current
	@Published var currentDate: Date
	private var cancellable: AnyCancellable?
	//https://stackoverflow.com/questions/57796877/swift-combine-using-timer-publisher-in-an-observable-object
	
	init() {
		self.currentDate = Date()
		self.cancellable = Timer.publish(every: 1, on: .main, in: .default)
			.autoconnect()
			.assign(to: \DateModel.currentDate, on: self)
	}
	
	var marketOpenHour: Date {
		return self.calendar.date(bySettingHour: 9, minute: 30, second: 0, of: self.currentDate) ?? Date()
	}
	
	var marketCloseHour: Date {
		return self.calendar.date(bySettingHour: 16, minute: 0, second: 0, of: self.currentDate) ?? Date()
	}
	
	var marketStatus: String {
		switch self.currentDate >= self.marketOpenHour && self.currentDate < self.marketCloseHour {
		case true:
			return "Open"
		default:
			return "Closed"
		}
	}
	
	var marketIsOpen: Bool {
		switch self.currentDate >= self.marketOpenHour && self.currentDate <= self.marketCloseHour {
		case true:
			return true
		default:
			return false
		}
	}
	
}
