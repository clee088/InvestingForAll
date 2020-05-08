//
//  OrderHistory+CoreDataProperties.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 5/5/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//
//

import Foundation
import CoreData

class Order {
	
	enum actionType {
		case buy
		case sell
		
		var string: String {
			switch self {
			case .buy:
				return "Buy"
			case .sell:
				return "Sell"
			}
		}
	}
	
	enum positionType {
		case long
		case short
		
		var string: String {
			switch self {
			case .long:
				return "Long"
			case .short:
				return "Short"
			}
		}
	}
	
	enum orderType {
		case marketOrder
		case limitOrder
		
		var string: String {
			switch self {
			case .marketOrder:
				return "Market Order"
			case .limitOrder:
				return "Limit Order"
			}
		}
	}
	
	enum statusType {
		case pending
		case completed
		case cancelled
		
		var string: String {
			switch self {
			case .pending:
				return "Pending"
			case .completed:
				return "Completed"
			case .cancelled:
				return "Cancelled"
			}
		}
	}
	
	var symbol: String
	var action: actionType
	var position: positionType
	var type: orderType
	var shares: Double
	var id: UUID
	var color: Data
	var name: String
	var date: Date
	var dateCompleted: Date?
	var status: statusType = .pending
	
	init(symbol: String, action: actionType, position: positionType, type: orderType, shares: Double, id: UUID, color: Data, name: String, date: Date) {
		self.symbol = symbol
		self.action = action
		self.position = position
		self.type = type
		self.shares = shares
		self.id = id
		self.color = color
		self.name = name
		self.date = date
	}
	
}

extension OrderHistory {
	
    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderHistory> {
        return NSFetchRequest<OrderHistory>(entityName: "OrderHistory")
    }
	
    @NSManaged public var symbol: String?
	@NSManaged public var action: String?
    @NSManaged public var position: String?
    @NSManaged public var type: String?
    @NSManaged public var shares: Double
    @NSManaged public var id: UUID?
    @NSManaged public var color: Data?
    @NSManaged public var name: String?
    @NSManaged public var date: Date?
    @NSManaged public var status: String?
    @NSManaged public var dateCompleted: Date?

}
