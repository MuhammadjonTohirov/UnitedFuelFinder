//
//  MainTabView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 31/01/24.
//

import Foundation
import SwiftUI

enum MainTabs: Int {
    case dashboard
    case map
    case settings
}

struct MainTabView: View {
    @ObservedObject var viewModel: MainTabViewModel = .init()
    @EnvironmentObject var mainViewModel: MainViewModel
    @State private var didAppear = false
        
    @State private var imagePlaceholder: Image?
    
    var body: some View {
        tabBarViewBody
            .richAlert(
                type: .custom(
                    image: Icon(systemName: "exclamationmark.triangle")
                        .size(.init(width: 56, height: 56))
                        .iconColor(.accent)
                        .anyView
                ),
                title: "attention".localize,
                message: Text(
                    "disclamer.desc".localize,
                    configure: { attr in
                        if let range = attr.range(of: "disclamer.desc.bold1".localize) {
                            attr[range].font = UIFont.lato(ofSize: 16, weight: .semibold)
                        }
                        
                        if let range = attr.range(of: "disclamer.desc.bold2".localize) {
                            attr[range].font = UIFont.lato(ofSize: 16, weight: .semibold)
                        }
                        
                        if let range = attr.range(of: "disclamer.desc.bold3".localize) {
                            attr[range].font = UIFont.lato(ofSize: 16, weight: .semibold)
                        }
                    }
                )
                .font(.lato(size: 16, weight: .regular))
                .anyView,
                isPresented: $viewModel.showWarningAlert, onDismiss: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        viewModel.checkActualVersion()
                    }
                }
            )
            .warningAlert(type: .custom(
                image: Icon(systemName: "exclamationmark.triangle")
                    .foregroundStyle(.accent)
                    .frame(width: 56, height: 56, alignment: .center)
                    .anyView
            ),
                          title: "attention".localize,
                          message: Text(
                            "New version is available".localize
                          ).anyView,
                          btnTitle: "Update".localize,
                          isPresented: $viewModel.showVersionWarningAlert,
                          onDismiss: {
                viewModel.showAppOnAppstore()
            })

    }
    var tabBarViewBody: some View {
        tabView
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.onAppear()
            }
            .onAppear {
                if didAppear {
                    return
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    viewModel.alertWarning()
                    self.didAppear = true
                }
            }
            .coveredLoading(isLoading: $viewModel.isLoading)
    }
    
    private var tabView: some View {
        TabView(selection: $viewModel.selectedTag) {
            NavigationStack {
                DashboardView(viewModel: viewModel.dashboardViewModel as! DashboardViewModel)
                    .environmentObject(mainViewModel)
            }
            .tabItem {
                Image("icon_pie")
                    .renderingMode(.template)
                Text("dashboard".localize)
            }
            .tag(MainTabs.dashboard)
            
            NavigationStack {
                MapTabView(viewModel: viewModel.mapViewModel as! MapTabViewModel)
                    .environmentObject(mainViewModel)
                    .environmentObject(viewModel)
            }
            .tabItem {
                Image("icon_map_2")
                    .renderingMode(.template)
                Text("map".localize)
            }
            .tag(MainTabs.map)

            NavigationStack {
                SettingsView()
                    .environmentObject(mainViewModel)
            }
            .tabItem {
                Image("icon_settings")
                    .renderingMode(.template)
                Text("settings".localize)
            }
            .tag(MainTabs.settings)
        }
        .onChange(of: viewModel.selectedTag, perform: { value in
            switch value {
            case .dashboard:
                debugPrint("On select dashboard")
                viewModel.checkActualVersion()
            case .map:
                debugPrint("On select map")
                viewModel.onSelectMapTab()
            case .settings:
                debugPrint("On select settings")
            }
        })
        .accentColor(.accent)
    }
}

#Preview {
    UserSettings.shared.setupForTest()
    
    return MainView()
}
