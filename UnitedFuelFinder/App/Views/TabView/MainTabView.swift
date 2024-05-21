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
        
    @State private var mapBodyState: HomeBodyState = .map
    @State private var imagePlaceholder: Image?
    
    var body: some View {
        innerBody
            .richAlert(
                type: .custom(
                    image: Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .foregroundStyle(.accent)
                        .frame(width: 56, height: 56, alignment: .center)
                        .anyView
                ),
                title: "attention".localize,
                message: Text(
                    "disclamer.desc".localize,
                    configure: { attr in
                        if let range = attr.range(of: "disclamer.desc.bold1".localize) {
                            attr[range].font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                        }
                        
                        if let range = attr.range(of: "disclamer.desc.bold2".localize) {
                            attr[range].font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                        }
                        
                        if let range = attr.range(of: "disclamer.desc.bold3".localize) {
                            attr[range].font = UIFont.systemFont(ofSize: 16, weight: .semibold)
                        }
                    }
                ).anyView,
                isPresented: $viewModel.showWarningAlert, onDismiss: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        viewModel.checkActualVersion()
                    }
                }
            )
            .warningAlert(type: .custom(
                image: Image(systemName: "exclamationmark.triangle")
                    .resizable()
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
    var innerBody: some View {
        NavigationStack {
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
                .overlay {
                    if viewModel.isLoading {
                        Rectangle()
                            .foregroundStyle(.appBackground.opacity(0.5))
                    } else {
                        EmptyView()
                            .opacity(0)
                    }
                }
        }
    }
    
    
    @ViewBuilder
    private var leadingTopBar: some View {
        switch viewModel.selectedTag {
        case .dashboard:
            Icon(name: "icon_bell_active")
                .onTapGesture {
                    viewModel.dashboardViewModel.navigate(to: .notifications)
                }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var centerTopBar: some View {
        switch viewModel.selectedTag {
        case .dashboard:
            Text("Dashboard")
                .font(.system(size: 16, weight: .bold))
        case .map:
            MapTabToggleView(selectedIndex: $mapBodyState)
        case .settings:
            Text("Settings")
                .font(.system(size: 16, weight: .bold))
        }
    }
    
    @ViewBuilder
    private var trailingTopBar: some View {
        switch viewModel.selectedTag {
        case .map:
            Icon(name: "icon_filter_2")
                .onTapGesture {
                    if let filter = self.viewModel.mapViewModel.filter {
                        self.viewModel.mapViewModel.route = .filter(filter, { newFilter in
                            self.viewModel.mapViewModel.set(filter: newFilter)
                            self.viewModel.mapViewModel.route = nil
                        })
                    }
                }
        case .dashboard:
            KF(
                imageUrl: UserSettings.shared.userAvatarURL,
                cacheKey: (UserSettings.shared.photoUpdateDate ?? Date()).toString(),
                storageExpiration: .expired,
                memoryExpiration: .expired,
                placeholder: imagePlaceholder?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 32.f.sw(), height: 32.f.sw(), alignment: .center)
                    .clipShape(Circle())
                    .anyView ?? EmptyView().anyView
            )
            .frame(width: 32.f.sw(), height: 32.f.sw())
            .background {
                Circle()
                    .foregroundColor(Color(uiColor: .secondarySystemBackground))
            }
            .onTapGesture {
                viewModel.dashboardViewModel.navigate(to: .profile)
            }
            .onAppear {
                if let img = UIImage(named: "icon_man_placeholder") {
                    self.imagePlaceholder = Image(uiImage: img)
                }
            }
        default:
            Text("")
        }
    }
    
    private var tabView: some View {
        TabView(selection: $viewModel.selectedTag) {
            DashboardView(viewModel: viewModel.dashboardViewModel as! DashboardViewModel)
                .environmentObject(mainViewModel)
                .tabItem {
                    Image("icon_pie")
                        .renderingMode(.template)
                    Text("dashboard".localize)
                }
                .tag(MainTabs.dashboard)

            MapTabView(viewModel: viewModel.mapViewModel as! MapTabViewModel)
                .environmentObject(mainViewModel)
                .tabItem {
                    Image("icon_map_2")
                        .renderingMode(.template)
                    Text("map".localize)
                }
                .tag(MainTabs.map)

            SettingsView()
                .environmentObject(mainViewModel)
                .tabItem {
                    Image("icon_settings")
                        .renderingMode(.template)
                    Text("settings".localize)
                }
                .tag(MainTabs.settings)
        }
        .onChange(of: mapBodyState, perform: { value in
            viewModel.mapViewModel.bodyState = value
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                leadingTopBar
            }
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                trailingTopBar
            }
        })
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                centerTopBar
            }
        })
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
