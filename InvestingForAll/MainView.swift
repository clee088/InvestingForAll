//
//  MainView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/20/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct MainView: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@EnvironmentObject var developer: DeveloperModel
	
	@Environment(\.managedObjectContext) var moc
	
//	@State var index: Int = 3
	
	@State var showSearch: Bool = false
	
	@State var viewState: CGSize = .zero
	
	@State private var response: Double = 0.3
	@State private var dampingFraction: Double = 0.7
	@State private var blendDuration: Double = 0.3
	
	@State var selctionIndex: Int = 0
	
	var body: some View {
		
		//var imageNames: [String] = ["house", "person", "globe", "briefcase", "gear"]
		
		GeometryReader { geometry in
			
			TabView(selection: self.$selctionIndex) {
					
					
					OverviewView(geometry: geometry)
						.environment(\.colorScheme, self.colorScheme)
						.environment(\.managedObjectContext, self.moc)
						.environmentObject(self.developer)
						.tabItem {
							Image(systemName: "house")
							Text("Overview")
					}
					.tag(0)
					
					PortfolioView(geometry: geometry)
						.tabItem {
							Image(systemName: "globe")
							Text("Portfolio")
					}
					.tag(1)
					
				}
					.accentColor(Color("Button"))
				
			}
			
		}
		
}

struct MainView_Previews: PreviewProvider {
	
    static var previews: some View {
		
		let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
		
        return MainView()
			.environment(\.colorScheme, .light)
			.environment(\.managedObjectContext, context)
			.environmentObject(DeveloperModel())
    }
}
