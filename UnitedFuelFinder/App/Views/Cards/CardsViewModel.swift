//
//  CardsViewModel.swift
//  UnitedFuelFinder
//
//  Created by Jurayev Nodir on 26/06/24.
//

import UIKit
import SwiftUI

class CardsViewModel: ObservableObject{
    @Published var push: Bool = false
    @Published var cardList: [CardItem] = [CardItem(), CardItem(), CardItem(), CardItem(), CardItem(), CardItem(), CardItem(), CardItem(), CardItem(), CardItem(), CardItem()]
    @Published var isLoading: Bool = false
    @Published var isSmall: Bool = false
    
    open func onAppear(){
        
    }
}


    
