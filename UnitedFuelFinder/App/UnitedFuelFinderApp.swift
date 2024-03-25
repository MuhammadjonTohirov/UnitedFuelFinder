//
//  UnitedFuelFinderApp.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/10/23.
//

import SwiftUI
import RealmSwift

@main
struct UnitedFuelFinderApp: SwiftUI.App {
//    @State private var overlayWindow: PassThroughWindow?
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.realmConfiguration, Realm.config)
                .onAppear {
                    debugPrint(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
                }
        }
    }
}
