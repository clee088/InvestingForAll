//
//  StockView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/9/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct StockView: View {
	
	var data: [Float] = [10, 30, 25, 25, 28, 50, 60, 23, 45, 20, 50]
	
	var body: some View {
		ZStack {
			Path { path in
				
				var x = 0
				
				path.move(to: CGPoint(x: x, y: Int(data[0])))
				
				data.forEach { price in
					
					path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(price)))
					
					x += 20
					
				}
				
				
			}
			.stroke()
		}
		.padding()
	}
}

struct StockView_Previews: PreviewProvider {
	static var previews: some View {
		StockView()
	}
}
