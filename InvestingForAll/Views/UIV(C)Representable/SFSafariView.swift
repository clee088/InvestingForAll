//
//  WebView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/30/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI
import SafariServices

struct SFSafariView: UIViewControllerRepresentable {
	
	var urlString: String
	
	func makeUIViewController(context: Context) -> SFSafariViewController {
		
		guard let url: URL = URL(string: self.urlString) else {
			return SFSafariViewController(url: URL(string: "https://finance.yahoo.com")!)
		}
		
		return SFSafariViewController(url: url)
	}
	
	func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
		
	}
	
	typealias UIViewControllerType = SFSafariViewController
	
}
