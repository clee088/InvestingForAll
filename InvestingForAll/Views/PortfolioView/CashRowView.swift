//
//  CashRowView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/22/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct CashRowView: View {
	
	var geometry: GeometryProxy
	
	var asset: FetchedResults<Portfolio>.Element
	
	private func convertColor(data: Data) -> Color {
		
		do {
			return try Color(NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) ?? UIColor(red: .random(in: 0...1), green: .random(in: 0...1), blue: .random(in: 0...1), alpha: 1))
		} catch {
			print(error)
		}
		
		return Color.clear
		
	}
	
	var body: some View {
		
		VStack(alignment: .leading) {
					
					HStack {
						
						RoundedRectangle(cornerRadius: 5)
							.fill(self.convertColor(data: self.asset.color ?? Data()))
							.frame(width: geometry.size.width * 0.02)
						
						VStack(alignment: .leading) {
							
							Text(String(self.asset.symbol ?? "Unknown"))
								.font(.headline)
								.fontWeight(.semibold)
							
							Text(String(self.asset.name ?? "Unknown"))
								.font(.headline)
								.fontWeight(.regular)
							
						}
						.frame(maxWidth: geometry.size.width * 0.3, alignment: .leading)
						
					}
					.padding([.vertical, .trailing])
					
				}
	}
	
}
