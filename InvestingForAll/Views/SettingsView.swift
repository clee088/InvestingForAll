//
//  SettingsView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/30/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@Environment(\.managedObjectContext) var moc
	
	@EnvironmentObject var developer: DeveloperModel
	
	@FetchRequest(entity: Portfolio.entity(), sortDescriptors: []) var portfolio: FetchedResults<Portfolio>
	
	private func resetCoreData() {
		
		for object in self.portfolio {
			
			self.moc.delete(object)
			
		}
		
		let portfolio = Portfolio(context: self.moc)
		
		portfolio.id = UUID()
		portfolio.name = "Cash"
		portfolio.symbol = "Cash"
		portfolio.sharePricePurchased = 1
		portfolio.shares = 1000
		portfolio.valuePurchased = portfolio.shares * portfolio.sharePricePurchased
		portfolio.currentValue = portfolio.valuePurchased
		portfolio.currentPrice = portfolio.currentValue
		try? portfolio.color = NSKeyedArchiver.archivedData(withRootObject: UIColor.systemGreen, requiringSecureCoding: false)
		
		try? self.moc.save()
		
	}
	
    var body: some View {
		GeometryReader { geometry in
			VStack {
				Toggle(isOn: self.$developer.sandboxMode) {
					Text("Sandbox Mode")
				}
				
				Button(action: {
					self.resetCoreData()
				}) {
					ZStack {
						
						RoundedRectangle(cornerRadius: 20)
							.frame(height: geometry.size.height * 0.06)
							
						
						Text("Reset Simulated Holdings")
							.foregroundColor(Color.white)
					}
				}
				
				Spacer()
			}
			.padding()
			.animation(.spring())
		}
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
		
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
        return SettingsView()
			.environment(\.colorScheme, .light)
			.environmentObject(DeveloperModel())
			.environment(\.managedObjectContext, context)
    }
}
