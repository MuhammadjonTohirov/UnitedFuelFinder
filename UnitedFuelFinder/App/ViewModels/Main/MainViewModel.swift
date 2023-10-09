//
//  MainViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 08/10/23.
//

import Foundation
import USDK

class MainViewRouter {
    var delegate: AppDelegate?
}

protocol AppDelegate {
    func navigate(to destination: AppDestination)
}

var routerObject = MainViewRouter()
var mainRouter: AppDelegate? = routerObject.delegate

final class MainViewModel: ObservableObject {
    @Published var route: AppDestination = .loading
    @Published var language: Language = UserSettings.shared.language ?? .english
    
    init(route: AppDestination = .loading) {
        self.route = route
        mainRouter = self
        UserSettings.shared.lastActiveDate = Date()
    }
    
    func set(language: Language) {
        UserSettings.shared.language = language
        self.language = language
    }
}

extension MainViewModel: AppDelegate {
    func navigate(to destination: AppDestination) {
        DispatchQueue.main.async {
            self.route = destination
        }
    }
}
