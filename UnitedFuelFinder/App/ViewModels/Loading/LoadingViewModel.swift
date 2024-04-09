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
                        await showAuth()
                    } else {
                        await MainService.shared.syncCustomers()
                        await showMain()
                    }
                } else {
                    await showAuth()
                }
                return
            }
            
            await showAuth()
        }
    }
    
    private func showMain() async {
        await appDelegate?.navigate(to: .pin)
    }
    
    private func showAuth() async {
        await appDelegate?.navigate(to: .auth)
    }
    
    static func createModel() -> LoadingViewModelProtocol {
        LoadingViewModel()
    }
}
