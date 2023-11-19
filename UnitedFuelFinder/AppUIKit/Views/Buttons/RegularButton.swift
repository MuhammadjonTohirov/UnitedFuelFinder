//
//  RegularButton.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/11/23.
//

import Foundation
import SwiftUI

struct RegularButton<Content: View>: View {
    var action: () -> Void
    var label: (() -> Content)?
    var height: CGFloat = 50
    
    var body: some View {
        SubmitButton(action: action, label: label, backgroundColor: .init(uiColor: .secondarySystemBackground), height: height)
    }
}
