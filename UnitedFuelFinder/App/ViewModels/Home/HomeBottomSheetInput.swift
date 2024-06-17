//
//  HomeBottomSheetInput.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/10/23.
//

import Foundation
import SwiftUI

enum BottomSheetState {
    case mainView
    case destinationView
}

struct HomeBottomSheetInput {
    struct ButtonInput {
        var title: String
        var isLoading: Bool
        
        var label: String = "A"
        var labelColor: Color = .label
        
        var onClickBody: (() -> Void)
        var onClickMap: (() -> Void)
    }
    
    var from: ButtonInput
    var to: ButtonInput
    var pickedAddress: String
    
    var onClickReady: () -> Void
    var onClickAllDestinations: () -> Void
    var onClickAddDestination: () -> Void
    
    var state: BottomSheetState = .mainView
    
    var distance: String
    
    init(
        from: ButtonInput,
        to: ButtonInput,
        pickedAddress: String,
        state: BottomSheetState = .mainView,
        onClickReady: @escaping () -> Void,
        onClickAllDestinations: @escaping () -> Void,
        onClickAddDestination:  @escaping () -> Void,
        distance: String
    ) {
        self.from = from
        self.to = to
        self.state = state
        self.onClickReady = onClickReady
        self.distance = distance
        self.pickedAddress = pickedAddress
        self.onClickAllDestinations = onClickAllDestinations
        self.onClickAddDestination = onClickAddDestination
    }
}
