//
//  Bool+Extensions.swift
//  UnitedFuelFinder
//
//  Created by applebro on 14/07/24.
//

import Foundation

extension Bool {
    func ifTrue(_ completion: @escaping () -> Void) {
        if self {
            completion()
        }
    }
    
    func ifFalse(_ completion: @escaping () -> Void) {
        if !self {
            completion()
        }
    }
}
