//
//  WatchlistView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/20/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct WatchlistView: View {
	
	@Environment(\.managedObjectContext) var moc
	
	@FetchRequest(entity: Watchlist.entity(), sortDescriptors: []) var watchlist: FetchedResults<Watchlist>
	
	var geometry: GeometryProxy
	
	var body: some View {
		
		
			VStack {
				HStack {
					Text("Watchlist")
						.font(.system(size: 20))
						.bold()
					
					Spacer()
				}
				
				Spacer()
				
				if !self.watchlist.isEmpty {
					ScrollView(.vertical) {
						VStack {
							ForEach(self.watchlist, id: \.id) { stock in
								
								VStack {
									HStack {
										
										Image(uiImage: (UIImage(data: stock.image ?? Data()) ?? UIImage(systemName: "exclamationmark.triangle"))!)
											.resizable()
											.aspectRatio(contentMode: .fit)
											.frame(width: self.geometry.size.width * 0.15, height: self.geometry.size.height * 0.15, alignment: .center)
											.clipShape(Circle())
										
										Text(stock.ticker ?? "N/A")
											.font(.headline)
											.fontWeight(.regular)
										
										
										Spacer()
										
									}
									
									HStack {
										Text(stock.companyName ?? "N/A")
											//										.font(.system(size: 15))
											.font(.subheadline)
											.fontWeight(.light)
										
										Spacer()
									}
									
								}
								.padding()
								.background(Color("Card Background"))
								.clipShape(RoundedRectangle(cornerRadius: 20))
								
							}
							
						}
					}
					
				} else {
						
					Text("Your Watchlist is Empty!")
						
				}
				
				Spacer()
				
			}
		
		
	}
	
}
