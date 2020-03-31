//
//  SettingsView.swift
//  InvestingForAll
//
//  Created by Christopher Lee on 3/30/20.
//  Copyright © 2020 Christopher Lee. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
	
	@Environment(\.colorScheme) var colorScheme: ColorScheme
	
	@EnvironmentObject var developer: DeveloperModel
	
    var body: some View {
		VStack {
			Toggle(isOn: self.$developer.sandboxMode) {
				Text("Sandbox Mode")
			}
			
			Spacer()
		}
		.padding()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
