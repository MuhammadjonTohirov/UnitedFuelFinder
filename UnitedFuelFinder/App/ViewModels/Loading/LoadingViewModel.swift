//
//  LoadingViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 08/10/23.
//

import Foundation
import USDK

protocol LoadingViewModelProtocol {
    func initialize()
    
    static func createModel() -> LoadingViewModelProtocol
}

final class LoadingViewModel: LoadingViewModelProtocol {
    func initialize() {
        Task(priority: .medium) {
            try await Task.sleep(for: .seconds(1))
            
//            if UserSettings.shared.canShowMain ?? false {
//                mainRouter?.navigate(to: .main)
//                return
//            }
//            
            mainRouter?.navigate(to: .language)
            
//            let isOK = await UserNetworkService.shared.refreshToken()
//            
//            let hasPin = UserSettings.shared.appPin != nil
//            let hasLanguage = UserSettings.shared.language != nil
//            
//            DispatchQueue.main.async {
//                if !hasLanguage {
//                    mainRouter?.navigate(to: .intro)
//                    return
//                }
//                
//                if !isOK {
//                    mainRouter?.navigate(to: .auth)
//                    return
//                }
//                
//                if hasPin {
//                    mainRouter?.navigate(to: .pin)
//                } else {
//                    mainRouter?.navigate(to: .auth)
//                }
//            }
        }
    }
    
    static func createModel() -> LoadingViewModelProtocol {
        LoadingViewModel()
    }
}
