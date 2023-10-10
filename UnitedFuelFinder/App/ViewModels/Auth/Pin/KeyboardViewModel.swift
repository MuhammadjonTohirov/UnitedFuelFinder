//
//  KeyboardViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/10/23.
//

import SwiftUI

enum KeyboardType {
    case withClear
    case withExit
    
    var text: String {
        switch self {
        case .withClear:
            return "c".uppercased()
        case .withExit:
            return "exit".localize.uppercased()
        }
    }
}

final class KeyboardViewModel: ObservableObject {
    let type: KeyboardType
    var maxCharacters: Int = 4
    
    init(type: KeyboardType, maxCharacters: Int = 4) {
        self.type = type
        self.maxCharacters = maxCharacters
    }
}
