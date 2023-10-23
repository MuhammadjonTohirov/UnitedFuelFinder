//
//  HomeBottomSheetInput.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/10/23.
//

import Foundation

enum BottomSheetState {
    case mainView
    case destinationView
}

struct HomeBottomSheetInput {
    struct ButtonInput {
        var title: String
        var isLoading: Bool
        
        var onClickBody: (() -> Void)
        var onClickMap: (() -> Void)
    }
    
    var from: ButtonInput
    var to: ButtonInput
    
    var onClickReady: () -> Void
    
    var state: BottomSheetState = .mainView
    
    var distance: String
    
    init(from: ButtonInput, to: ButtonInput, state: BottomSheetState = .mainView, 
         onClickReady: @escaping () -> Void, distance: String) {
        self.from = from
        self.to = to
        self.state = state
        self.onClickReady = onClickReady
        self.distance = distance
    }
}
