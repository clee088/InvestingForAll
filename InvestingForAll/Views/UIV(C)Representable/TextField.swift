//
//  TextField.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/10/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import Foundation
import SwiftUI

struct CustomTextField: UIViewRepresentable {
	typealias UIViewType = UITextField
	
	func makeUIView(context: Context) -> UITextField {
		let textField = UITextField(frame: .zero)
		
		textField.keyboardType = .numberPad
		textField.returnKeyType = .done
		
		return textField
		
	}
	
	func updateUIView(_ uiView: UITextField, context: Context) {
		
	}
	
}
