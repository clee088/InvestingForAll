//
//  Extensions.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 4/10/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

extension Array {

    func evenlySpaced(length: Int) -> [Element] {
        guard length < self.count else { return self }

        let takeIndex = (self.count / length) - 1
        let nextArray = Array(self.dropFirst(takeIndex + 1))
        return [self[takeIndex]] + nextArray.evenlySpaced(length: length - 1)
    }

}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension Publishers {
	
	static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        // 2.
		let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { $0.keyboardHeight }
        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }
        
        // 3.
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
	
}

extension UIApplication {
	
	func endEditing() {
		sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
	}
	
}
