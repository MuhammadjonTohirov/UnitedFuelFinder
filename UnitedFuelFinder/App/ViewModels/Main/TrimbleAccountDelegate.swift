//
//  TrimbleAccountDelegate.swift
//  UnitedFuelFinder
//
//  Created by applebro on 15/05/24.
//

import Foundation
import TrimbleMapsAccounts

class AccountDelegate: AccountManagerDelegate {
    func stateChanged(newStatus: AccountManagerState) {
        switch newStatus {
        case .loaded:
            Logging.l("Trimble loaded successfully")
        case .error:
            Logging.l("Trimble loading failed")
        case .loading:
            Logging.l("Trimble loading")
        case .uninitialized:
            Logging.l("Trimble uninitialized")
        @unknown default:
            Logging.l("Trimble unknown state")
        }
    }
}
