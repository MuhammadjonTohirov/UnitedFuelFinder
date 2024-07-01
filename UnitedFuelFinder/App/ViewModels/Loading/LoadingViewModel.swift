//
//  LoadingViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 08/10/23.
//

import Foundation


protocol LoadingViewModelProtocol {
    var loadingReason: String {get}
    func initialize()
    
    static func createModel() -> LoadingViewModelProtocol
}

final class LoadingViewModel: LoadingViewModelProtocol, ObservableObject {
    @Published var loadingReason: String = ""
    
    func initialize() {
        Task.detached(priority: .high) { [weak self] in
            guard let self else {return}
            await CommonService.shared.syncStates()

            if (await AuthService.shared.refreshTokenIfRequired()) && UserSettings.shared.hasValidToken {
                if UserSettings.shared.appPin == nil {
                    await self.showAuth()
                } else {
                    await self.setState("loading.prerequisites".localize)
                    await AuthService.shared.syncUserInfo()
                    await self.setState("loading.stations".localize)
                    await MainService.shared.syncCustomers()
                    await MainService.shared.syncAllStations()
                    await self.setState("")
                    
                    await self.showPin()
                }
                
                return
            }
            
            await self.showAuth()
        }
    }
    
    private func setState(_ text: String) async {
        await MainActor.run {
            loadingReason = text
        }
    }
    
    private func showMain() async {
        await appDelegate?.navigate(to: .mainTab)
    }
    
    private func showAuth() async {
        await appDelegate?.navigate(to: .auth)
    }
    
    private func showPin() async {
        await appDelegate?.navigate(to: .pin)
    }
    
    static func createModel() -> LoadingViewModelProtocol {
        LoadingViewModel()
    }
}
