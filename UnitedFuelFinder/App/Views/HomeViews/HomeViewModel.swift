//
//  HomeViewModel.swift
//  UnitedFuelFinder
//
//  Created by Jurayev Nodir on 13/06/24.
//

import UIKit

class HomeViewModel : ObservableObject {
    init(push: Bool) {
        self.push = push
    }
    @Published var push: Bool = false
    var items = [String]()
}
    
