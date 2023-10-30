//
//  LoadingViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 08/10/23.
//

import Foundation


protocol LoadingViewModelProtocol {
    func initialize()
    
    static func createModel() -> LoadingViewModelProtocol
}

final class LoadingViewModel: LoadingViewModelProtocol {
    func initialize() {
        Task(priority: .medium) {
            await CommonService.shared.syncStates()
            
            if UserSettings.shared.canShowMain {
                if await AuthService.shared.refreshToken() {
                    mainRouter?.navigate(to: .main)
                } else {
                    mainRouter?.navigate(to: .auth)
                }
                return
            }
            
            if UserSettings.shared.isLanguageSelected ?? false {
                mainRouter?.navigate(to: .auth)
                return
            }
            
            mainRouter?.navigate(to: .language)
        }
    }
    
    static func createModel() -> LoadingViewModelProtocol {
        LoadingViewModel()
    }
}