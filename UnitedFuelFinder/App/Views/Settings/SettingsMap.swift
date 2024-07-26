//
//  SettingsMap.swift
//  UnitedFuelFinder
//
//  Created by applebro on 11/12/23.
//

import Foundation
import SwiftUI

public enum MapCenterType: Codable {
    case currentLocation
    case pin
    
    public var name: String {
        switch self {
        case .currentLocation:
            return "current_location".localize
            
        case .pin:
            return "map_pin".localize
        }
    }
}

struct SettingsMap: View {
    @State var mainPoint: MapCenterType = .currentLocation {
        didSet {
            UserSettings.shared.mapCenterType = mainPoint
        }
    }
    
    @State private var showMainPoint: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("main_point".localize)
                Spacer()
                Text(mainPoint.name)
                    .foregroundStyle(Color.secondary)
                
                Icon(systemName: "chevron.forward")
                    .foregroundStyle(Color.secondary)
            }
            .background {
                Rectangle()
                    .foregroundStyle(Color.background)
                    .ignoresSafeArea()
            }.onTapGesture {
                withAnimation {
                    showMainPoint.toggle()
                }
            }
            
            if showMainPoint {
                mainPointView.transition(.opacity)
            }
            
            Text("discounted_stations_pick_logic_desc".localize) //Select logic to get nearest discounted stations, near to current location or near to focused location by pin.
                .foregroundStyle(Color.secondary)
                .font(.caption)
                .padding(.top, Padding.small)
            Spacer()
        }
        .font(.lato(size: 14))
        .padding(Padding.default)
        .navigationTitle("map_settings".localize)
        .onAppear {
            self.mainPoint = UserSettings.shared.mapCenterType ?? .currentLocation
        }
    }
    
    private var mainPointView: some View {
        VStack {
            HStack {
                Text(MapCenterType.currentLocation.name)
                Spacer()
                Icon(systemName: "checkmark.circle.fill")
                    .renderingMode(.template)
                    .opacity(mainPoint == .currentLocation ? 1 : 0)
                    .foregroundStyle(Color.accentColor)
            }
            .background {
                Rectangle()
                    .foregroundStyle(Color.background)
            }
            .onTapGesture {
                mainPoint = .currentLocation
            }
            .padding(.top, Padding.small)
            
            HStack {
                Text(MapCenterType.pin.name)
                Spacer()
                Icon(systemName: "checkmark.circle.fill")
                    .opacity(mainPoint == .currentLocation ? 0 : 1)
                    .foregroundStyle(Color.accentColor)
            }
            .background {
                Rectangle()
                    .foregroundStyle(Color.background)
            }
            .onTapGesture {
                mainPoint = .pin
            }
            .padding(.top, Padding.small / 2)
        }
    }
}

#Preview {
    SettingsMap()
}
