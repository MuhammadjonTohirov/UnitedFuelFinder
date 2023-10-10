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
    @State private var userTrackingMode = UserTrackingMode.followWithHeading
    @State private var bottomSheetFrame: CGRect = .zero
    @State private var screenFrame: CGRect = .zero
    private let locationManager = CLLocationManager()

    var body: some View {
        ZStack {
            UMap(coordinateRegion: $region, userTrackingMode: $userTrackingMode)
                .ignoresSafeArea()
                .padding(.bottom, -16)
                .overlay {
                    ZStack {
                        mapGradientOverlay
                        
                        Image("icon_settings")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(Color.label)
                            .frame(width: 32, height: 32)
                            .position(x: screenFrame.width - 32, y: 20)
                            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 0)
                    }
                }.padding(.bottom, bottomSheetFrame.height - 10)
            
            VStack(spacing: 0) {
                Spacer()
                bottomSheetView
            }
            
            currentLocationNavView
        }
        .onChange(of: screenFrame, perform: { value in
            region = .init(center: .init(latitude: 40.793624, longitude: -74.264141), span: .init(latitudeDelta: 1, longitudeDelta: 1))
            
        })
        .background {
            GeometryReader(content: { geometry in
                Color.clear.onAppear {
                    screenFrame = geometry.frame(in: .global)
                }
            })
        }
    }
    
    var currentLocationNavView: some View {
        Button.init(role: .none) {
            
        } label: {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.background)
                .overlay {
                    Image("icon_navigation")
                        .renderingMode(.template)
                        .foregroundStyle(Color.label)
                }
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                .position(
                    x: bottomSheetFrame.width - 40,
                    y: bottomSheetFrame.origin.y - 100
                )
        }
    }
    
    var mapGradientOverlay: some View {
        VStack {
            Rectangle()
                .frame(maxHeight: 300)
                .ignoresSafeArea(edges: .top)
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.background,
                            Color.background.opacity(0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Spacer()
        }.allowsHitTesting(false)
    }
    
    var bottomSheetView: some View {
        VStack {
            fromPointView
                .padding(.top, Padding.small / 2)
            toPointView
            ScrollView(.horizontal) {
                HStack {
                    gasStationItem
                    gasStationItem
                }
                .padding(.horizontal, Padding.medium)
            }
            .padding(.horizontal, -Padding.medium)
            .scrollIndicators(.never)
            .padding(.top, 10)
        }
        .padding(Padding.medium)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(Color.background)
                .ignoresSafeArea()
                .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 0)
        }
        .background {
            GeometryReader(content: { geometry in
                Color.clear.onAppear {
                    bottomSheetFrame = geometry.frame(in: .global)
                }
            })
        }
    }
    
    var gasStationItem: some View {
        VStack(spacing: 16) {
            HStack {
                Image("image_ta")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 32)
                
                VStack(alignment: .leading) {
                    Text("TA/Petro")
                    Text("23.37 ml • NEWARK NJ")
                }
                .font(.system(size: 12))
                
                Spacer()
                
                Text("$4.42")
                    .foregroundStyle(.white)
                    .font(.system(size: 12))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 4)
                    .background {
                        RoundedRectangle(
                            cornerRadius: 4
                        ).foregroundStyle(
                            Color.accentColor
                        )
                    }
            }
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Save $0.68 per gallon ")
                    Text("Retail price $5.1")
                }
                .font(.system(size: 12))
                
                Spacer()
                
                Label(
                    title: {
                        Text("Get Direction")
                    },
                    icon: {
                        Image(
                            "icon_navigator"
                        ).renderingMode(
                            .template
                        ).foregroundStyle(
                            Color.white
                        )
                    }
                )
                    .foregroundStyle(.white)
                    .font(.system(size: 12))
                    .padding(.vertical, 2)
                    .padding(.horizontal, 4)
                    .background {
                        RoundedRectangle(
                            cornerRadius: 6
                        ).foregroundStyle(
                            Color.accentColor
                        )
                    }
            }
        }
        .padding(Padding.medium)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.secondaryBackground)
        }
        .frame(minWidth: UIApplication.shared.screenFrame.width * 0.8)
    }
    
    var fromPointView: some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(height: 40)
            .foregroundStyle(Color.secondaryBackground)
            .overlay {
                HStack {
                    Image("icon_point_circle")
                        .renderingMode(.template)
                        .foregroundStyle(Color.label)

                    Text("Fair Lawn, Peterson, USA")
                        .font(.system(size: 13))
                    Spacer()
                    Divider()
                        .padding(6)
                    Image(systemName: "arrow.forward")
                }
                .padding(.horizontal, 10)
            }
    }
    
    var toPointView: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 40)
                .foregroundStyle(Color.secondaryBackground)
                .overlay {
                    HStack {
                        Image("icon_pin_search")
                            .renderingMode(.template)
                            .foregroundStyle(Color.label)

                        Text("Fair Lawn, Peterson, USA")
                            .font(.system(size: 13))
                        Spacer()
                        Divider()
                            .padding(6)
                        Image(systemName: "arrow.forward")
                    }
                    .padding(.horizontal, 10)
                }
            
            RoundedRectangle(cornerRadius: 8)
                .frame(width: 51, height: 40)
                .foregroundStyle(Color.secondaryBackground)
                .overlay {
                    Text("Map")
                        .font(.system(size: 13))
                }
        }
    }
}

#Preview {
    HomeView()
}
