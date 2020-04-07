//
//  WatchlistRow.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/2/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct WatchlistRow: View {
	
	@State var ticker: String
	@State var companyName: String
	@State var imageData: Data?
	
    var body: some View {
        
		GeometryReader { geometry in
			HStack {
				
				Image(uiImage: (UIImage(data: self.imageData ?? Data()) ?? UIImage(systemName: "exclamationmark.triangle"))!)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12, alignment: .center)
					.clipShape(Circle())
				
				Text(self.ticker)
					.font(.system(size: 18))
					.fontWeight(.bold)
				
				Text(self.companyName)
					.font(.system(size: 15))
					.fontWeight(.medium)
				
				Spacer()
				
			}
			.background(Color("Card Dark"))
			.clipShape(RoundedRectangle(cornerRadius: 20))
		}
		
    }
}

struct WatchlistRow_Previews: PreviewProvider {
    static var previews: some View {
		WatchlistRow(ticker: "ENPH", companyName: "Enphase Energy Inc.")
    }
}
