//
//  ManageDrivers.swift
//  UnitedFuelFinder
//
//  Created by applebro on 27/06/24.
//

import Foundation
import SwiftUI

struct ManageDriverView: View {
    @State 
    var drivers: [UserInfo] = []
    
    @State
    private var selectedUserInfo: UserInfo?
    
    @State
    private var showEditDriver: Bool = false
    
    @State
    private var isLoading: Bool = false
    
    var body: some View {
        ForEach(drivers, id: \.id) { driver in
            VStack(alignment: .leading, spacing: 5) {
                Text(driver.fullName)
                    .font(.bold(size: 14))
                Text(driver.email)
                    .font(.regular(size: 12))
                    .foregroundStyle(Color.blue)
                    .padding(.bottom, 5)
                
                Text(driver.permissionsString)
                    .font(.regular(size: 12))
                
                Text(driver.stationNamesString)
                    .font(driver.stationsFont)
                    .foregroundStyle(driver.stationsColor)
                    .set(isVisible: !driver.stationNamesString.isEmpty)
                
                Text(driver.registerTimeBeautified)
                    .font(.regular(size: 12))
            }
            .horizontal(alignment: .leading)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.appSecondaryBackground)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 5)
            .onTapGesture {
                selectedUserInfo = driver
                showEditDriver = true
            }
        }
        .scrollable()
        .coveredLoading(isLoading: $isLoading)
        .onAppear {
            isLoading = true
            Task {
                let driverList = await CompanyService.shared.loadDrivers()
                await MainService.shared.syncCustomers()
                await MainActor.run {
                    self.drivers = driverList
                    self.isLoading = false
                }
            }
        }
        .navigationDestination(isPresented: $showEditDriver) {
            if let selectedUserInfo {
                DriverPropertiesView(userInfo: selectedUserInfo)
            }
        }
        .navigationTitle("manage.drivers".localize)
    }
}

#Preview {
    UserSettings.shared.setupForTest()
    return NavigationStack {
        ManageDriverView()
    }
}

extension UserInfo {
    var stationsColor: Color {
        if isAllStationsSelected {
            return Color(uiColor: .systemGreen)
        }
        
        return .label
    }
    
    var stationsFont: Font? {
        if isAllStationsSelected {
            return .bold(size: 12)
        }
        
        return .regular(size: 12)
    }
}
