//
//  MainViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 08/10/23.
//

import Foundation
import GoogleMaps

class MainViewRouter {
    var delegate: AppDelegate?
}

protocol AppDelegate {
    var timer: Timer? {get set}
    func navigate(to destination: AppDestination) async
    func showAppOnAppstore()
    
    func defaultNavigationSetup()
    func transparentNavigationSetup()
}

extension AppDelegate {
    func defaultNavigationSetup() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let back = UIBarButtonItemAppearance(style: .done)
        back.normal.backgroundImage = UIImage()
        
        back.normal.titlePositionAdjustment = .init(horizontal: -1000, vertical: 0)
        
        appearance.backButtonAppearance = back
        appearance.titlePositionAdjustment = .init(horizontal: 0, vertical: 0)
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithTransparentBackground()
        UITabBar.appearance().standardAppearance = tabAppearance
    }
    
    func transparentNavigationSetup() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let back = UIBarButtonItemAppearance(style: .done)
        back.normal.backgroundImage = UIImage()
        
        back.normal.titlePositionAdjustment = .init(horizontal: -1000, vertical: 0)
        
        appearance.backButtonAppearance = back
        appearance.titlePositionAdjustment = .init(horizontal: 0, vertical: 0)
        appearance.shadowImage = UIImage()
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}

var routerObject = MainViewRouter()
var appDelegate: AppDelegate? = routerObject.delegate

final class MainViewModel: ObservableObject {
    @Published var route: AppDestination = .loading
    
    @Published var language: Language = UserSettings.shared.language ?? .english {
        didSet {
            UserSettings.shared.language = language
        }
    }
    var trimbleDelegate: AccountDelegate = .init()
    
    var timer: Timer?
    
    init(route: AppDestination = .loading) {
        self.route = route
        appDelegate = self
        
        setupUserSettings()
        setupGoogleMaps()
                
        Logging.l("Access token: \(UserSettings.shared.accessToken ?? "-")")
    }
    
    func set(language: Language) {
        UserSettings.shared.language = language
        self.language = language
    }
    
    private func setupUserSettings() {
        UserSettings.shared.lastActiveDate = Date()
        UserSettings.shared.photoUpdateDate = Date()
    }
    
    private func setupGoogleMaps() {
        GMSServices.provideAPIKey(URL.googleMapsApiKey)
        Logging.l("GMaps \(GMSServices.sdkVersion())")
    }
}

extension MainViewModel: AppDelegate {
    func navigate(to destination: AppDestination) async {
        await MainActor.run {
            self.route = destination
        }
    }
    
    func showAppOnAppstore() {
        guard let url = URL(string: URL.appstore) else { return }
        UIApplication.shared.open(url)
    }
}

extension URL {
    static var appstore: String {
        return "itms-apps://itunes.apple.com/app/id\(URL.appstoreID)"
    }
    
    static var appstoreID: String {
        return "6470516568"
    }
}
