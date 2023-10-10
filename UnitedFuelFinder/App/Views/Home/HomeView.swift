//
//  HomeView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/10/23.
//

import Foundation
import SwiftUI
import UnitedUIKit
import MapKit

struct HomeView: View {
    @State private var region = MKCoordinateRegion()
    @State private var userTrackingMode = UserTrackingMode.follow
    @State private var screen: CGRect = .zero
    
    var body: some View {
        VStack(spacing: 0) {
            UMap(coordinateRegion: $region, userTrackingMode: $userTrackingMode)
                .ignoresSafeArea()
                .padding(.bottom, -16)
            RoundedRectangle(cornerRadius: 16)
                .ignoresSafeArea()
                .frame(height: UIApplication.shared.screenFrame.height * 0.32 + 100)
        }
        
    }
}

#Preview {
    HomeView()
}
