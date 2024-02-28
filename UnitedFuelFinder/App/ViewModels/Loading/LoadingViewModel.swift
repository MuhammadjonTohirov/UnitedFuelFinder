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
            
            if UserSettings.shared.hasValidToken {
                if await AuthService.shared.refreshTokenIfRequired(), await AuthService.shared.syncUserInfo() {
                    if UserSettings.shared.appPin == nil {
                        appDelegate?.navigate(to: .auth)
                    } else {                        
                        appDelegate?.navigate(to: .pin)
                    }
                } else {
                    appDelegate?.navigate(to: .auth)
                }
                return
            }
            
            appDelegate?.navigate(to: .auth)

        }
    }
    
    static func createModel() -> LoadingViewModelProtocol {
        LoadingViewModel()
    }
}
