//
//  HomeView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/10/23.
//

import Foundation
import SwiftUI

import GoogleMaps


struct HomeView: View {
    @State private var bottomSheetFrame: CGRect = .zero
    @State private var screenFrame: CGRect = .zero
    
    @ObservedObject var viewModel: HomeViewModel = .init()
    @State private var isDragging: Bool = false
    @State private var pointerFrame: CGRect = .zero
    
    private let pointerHeight: CGFloat = 158
    private let locationManager = CLLocationManager()
    
    private var bottomSheetBottomPadding: CGFloat {
        isDragging ? -bottomSheetFrame.height + 80 : 0
    }
    
    var body: some View {
        ZStack {
            GMapsView(
                pickedLocation: $viewModel.pickedLocation,
                isDragging: $isDragging,
                screenCenter: pointerFrame.center
            )
            .set(currentLocation: viewModel.currentLocation)
            .set(
                from: self.viewModel.fromLocation?.coordinate,
                to: viewModel.state == .routing ? self.viewModel.toLocation?.coordinate : nil,
                onStartDrawing: {
                    Logging.l("Before start drawing")
                    viewModel.onStartDrawingRoute()
                },
                onEndDrawing: {
                    Logging.l("After end drawing")
                    viewModel.onEndDrawingRoute()
                }
            )
            .ignoresSafeArea()
            .padding(.bottom, 8)
            .overlay {
                ZStack {
                    mapGradientOverlay
                    
                    settingsButton
                    
                    PinPointerView(
                        isActive: isDragging,
                        type: viewModel.state == HomeViewState.selectFrom ? .pinA : .pinB)
                    .frame(height: pointerHeight)
                    .readRect(rect: $pointerFrame)
                    .offset(.init(width: 0, height: -(pointerHeight / 2)))
                    .opacity(viewModel.state != HomeViewState.routing ? 1 : 0)
                }
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .padding(.bottom, -14)
            .onChange(of: viewModel.pickedLocation, perform: { value in
                if viewModel.state == .routing {
                    return
                }
                
                self.viewModel.reloadAddress()
            })
            
            bottomContent
            
            BouncingLoadingView(message: "Searching route")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color.background.opacity(0.5)
                        .ignoresSafeArea()
                }
                .opacity(viewModel.isDrawing ? 1 : 0)
        }
        .background {
            GeometryReader(content: { geometry in
                Color.clear.onAppear {
                    screenFrame = geometry.frame(in: .global)
                }
            })
        }
        .onAppear {
            viewModel.onAppear()
            viewModel.focusToCurrentLocation()
        }
    }
    
    private var bottomContent: some View {
        VStack {
            Spacer()
            HStack {
                if viewModel.state == .selectTo {
                    backButtonView
                        .padding(.leading, 8)
                        .padding(.bottom, 8)
                }
                
                if viewModel.state == .routing {
                    clearRouteButton
                        .padding(.leading, 8)
                        .padding(.bottom, 8)
                }

                Spacer()
                currentLocationNavView
                    .padding(.trailing, 8)
                    .padding(.bottom, 8)
            }
            
            HomeBottomSheetView(
                input: .init(
                    from: .init(
                        title: viewModel.fromAddress.nilIfEmpty ?? "No address",
                        isLoading: viewModel.isLoadingAddress || isDragging,
                        onClickBody: {
                            debugPrint("OnClick body 1")
                        }, onClickMap: {
                            // skip this method
                            debugPrint("OnClick map 1")
                        }
                    ),
                    to: .init(
                        title: viewModel.toAddress.nilIfEmpty ?? "no_address".localize,
                        isLoading: viewModel.state == .selectTo ? viewModel.isLoadingAddress : false,
                        onClickBody: {
                            debugPrint("OnClick body 2")
                        }, onClickMap: {
                            debugPrint("OnClick map 2")
                            self.viewModel.onClickSelectToPointOnMap()
                        }
                    ),
                    
                    state: viewModel.state != .selectTo ? .mainView : .destinationView,
                    onClickReady: {
                        // draw route
                        viewModel.onClickDrawRoute()
                    },
                    distance: viewModel.distance
                )
            )
            
            .background {
                GeometryReader(content: { geometry in
                    Color.clear.onAppear {
                        bottomSheetFrame = geometry.frame(in: .global)
                    }
                })
            }
            .padding(.bottom, bottomSheetBottomPadding)
        }
    }
    
    private var settingsButton: some View {
        VStack {
            HStack {
                Image("icon_settings")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.label)
                    .frame(width: 32, height: 32)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 0)
                    .opacity(0)
                Spacer()
                VStack {
                    Text("address".localize)
                        .font(.system(size: 13))
                        .foregroundStyle(Color.init(uiColor: .label.withAlphaComponent(0.7)))
                    
                    Text("\(viewModel.fromAddress)")
                        .font(.system(size: 13))
                        .multilineTextAlignment(.center)
                }.opacity(isDragging ? 1 : 0)
                Spacer()
                Image("icon_settings")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.label)
                    .frame(width: 32, height: 32)
                    .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 0)
            }
            .frame(maxWidth: .infinity)
            
            Spacer()
        }.padding(.horizontal, Padding.medium)
        
    }
    
    private var currentLocationNavView: some View {
        Button {
            self.viewModel.focusToCurrentLocation()
        } label: {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.background)
                .overlay {
                    Image("icon_navigation")
                        .renderingMode(.template)
                        .foregroundStyle(Color.label.opacity(0.5))
                }
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
        }
    }
    
    private var clearRouteButton: some View {
        Button(action: {
            viewModel.onClickBack()
            viewModel.clearDestination()
        }, label: {
            Text("clear".localize)
                .font(.system(size: 14))
                .foregroundStyle(Color.label.opacity(0.5))
                .padding(.horizontal, 4)
                .frame(height: 40)
                .frame(minWidth: 80)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(Color.background)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                }
        })
    }
    
    private var backButtonView: some View {
        Button {
            self.viewModel.onClickBack()
        } label: {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.background)
                .overlay {
                    Image(systemName: "arrow.left")
                        .renderingMode(.template)
                        .foregroundStyle(Color.label.opacity(0.5))
                }
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
        }
    }
    
    var mapGradientOverlay: some View {
        VStack {
            Rectangle()
                .frame(maxHeight: 200)
                .ignoresSafeArea(edges: .top)
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color.background.opacity(0.6),
                            Color.background.opacity(0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Spacer()
        }.allowsHitTesting(false)
    }
}

#Preview {
    MainView()
}
