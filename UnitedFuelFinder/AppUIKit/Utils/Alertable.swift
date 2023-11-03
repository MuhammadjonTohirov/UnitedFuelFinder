//
//  Alertable.swift
//  UnitedFuelFinder
//
//  Created by applebro on 27/10/23.
//

import Foundation
import SwiftUI

protocol Alertable: NSObject {
    var alert: AlertToast {get set}
    var shouldShowAlert: Bool {get set}
    func showAlert(message: String)
    func showError(message: String)
    
    func hideAlert()
    func showCustomAlert(alert: AlertToast)
}

extension Alertable {
    func showAlert(message: String) {
        DispatchQueue.main.async {
            self.alert = .init(displayMode: .alert, type: .regular, title: message)
            self.shouldShowAlert = true
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            self.alert = .init(displayMode: .alert, type: .error(.init(uiColor: .systemRed)), title: message)
            self.shouldShowAlert = true
        }
    }
    
    func hideAlert() {
        DispatchQueue.main.async {
            self.shouldShowAlert = false
        }
    }
    
    func showCustomAlert(alert: AlertToast) {
        DispatchQueue.main.async {
            self.alert = alert
            self.shouldShowAlert = true
        }
    }
}
