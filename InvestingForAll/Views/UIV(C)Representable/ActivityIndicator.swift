//
//  ActivityIndicator.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/30/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
	
//	@ObservedObject var news: NewsModel
	
	@Binding var isLoading: Bool
	
	func makeUIView(context: Context) -> UIActivityIndicatorView {
		return UIActivityIndicatorView()
	}
	
	func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
		
		self.isLoading ? uiView.stopAnimating() : uiView.startAnimating()
	}
	
	typealias UIViewType = UIActivityIndicatorView
	
}
