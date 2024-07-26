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
    
    private var navigationOpacity: CGFloat {
        switch viewModel.selectedTag {
        case .map:
            return viewModel.leadningNavigationOpacity
        default:
            return 1
        }
    }

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
                .coveredLoading(isLoading: $viewModel.isLoading)
        }
    }
    
    @ViewBuilder
    private var leadingTopBar: some View {
        switch viewModel.selectedTag {
        case .dashboard:
            Image("icon_bell_active")
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.white)
                .shadow(color: .black, radius: 4, x: 0, y: 0)
                .onTapGesture {
                    viewModel.dashboardViewModel.navigate(to: .notifications)
                }
        case .map:
            if let tollCost = viewModel.mapDetails {
                TotalCostView(value: "$\(tollCost.tollCost)")
            } else {
                EmptyView()
            }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var centerTopBar: some View {
        switch viewModel.selectedTag {
        case .dashboard:
            Text("dashboard".localize)
                .font(.lato(size: 16, weight: .bold))
                .foregroundStyle(.white)
                .shadow(color: .black, radius: 4, x: 0, y: 0)

        case .map:
            MapTabToggleView(selectedIndex: $viewModel.mapBodyState)
        case .settings:
            Text("settings".localize)
                .font(.lato(size: 16, weight: .bold))
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
                            self.viewModel.mapViewModel.route = nil
                            self.viewModel.mapViewModel.set(filter: newFilter)
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
                .environmentObject(viewModel)
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
        
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                leadingTopBar
                    .opacity(navigationOpacity)
            }
        })
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                trailingTopBar
                    .opacity(navigationOpacity)
            }
        })
        .toolbar(content: {
            ToolbarItem(placement: .principal) {
                centerTopBar
                    .opacity(navigationOpacity)
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
