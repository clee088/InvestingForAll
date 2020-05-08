//
//  DonutSlice.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/21/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct DonutSliceView: View {
	
	let geometry: GeometryProxy
	
	@State var portfolio: FetchedResults<Portfolio>
	
	@State var index: Int
	
	@State var color: Color
	
	@Binding var selectedIndex: Int?
	
	@Binding var isSelecting: Bool
	
	@State var values: [Double]
	
	var body: some View {
		
		let offset: Double = self.values.prefix(upTo: self.index).reduce(0, +)
		
//		print("\(self.index) | \(self.portfolio.map({$0.name ?? ""})[self.index]) | \(self.values[self.index]) | \(offset) | \(offset + self.values[self.index])")
		
		switch self.index == 0 {
		case true:
			return Circle()
				.trim(from: CGFloat(0), to: CGFloat(offset + self.values[self.index]))
				.stroke(self.color.opacity(self.selectedIndex == self.index && self.isSelecting || self.selectedIndex == nil ? 1 : 0.7), style: StrokeStyle(lineWidth: self.selectedIndex == self.index && self.isSelecting ? self.geometry.size.width * 0.07 : self.geometry.size.width * 0.06, lineCap: .butt, lineJoin: .miter))
			
		default:
			return Circle()
				.trim(from: CGFloat(offset), to: CGFloat(offset + self.values[self.index]))
				.stroke(self.color.opacity(self.selectedIndex == self.index && self.isSelecting || self.selectedIndex == nil ? 1 : 0.7), style: StrokeStyle(lineWidth: self.selectedIndex == self.index && self.isSelecting ? self.geometry.size.width * 0.07 : self.geometry.size.width * 0.06, lineCap: .butt, lineJoin: .miter))
			
		}
		
	}
	
}
