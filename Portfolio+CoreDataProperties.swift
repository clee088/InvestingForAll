//
//  Portfolio+CoreDataProperties.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/15/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//
//

import Foundation
import CoreData


extension Portfolio {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Portfolio> {
        return NSFetchRequest<Portfolio>(entityName: "Portfolio")
    }

    @NSManaged public var color: Data?
	@NSManaged public var currentPrice: Double
	@NSManaged public var currentValue: Double
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var sharePricePurchased: Double
    @NSManaged public var shares: Double
    @NSManaged public var symbol: String?
    @NSManaged public var valuePurchased: Double

}
