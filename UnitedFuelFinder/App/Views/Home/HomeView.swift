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
        NavigationView {
            innerBody
        }
    }
    
    var innerBody: some View {
        ZStack {
            GMapsView(
                pickedLocation: $viewModel.pickedLocation,
                isDragging: $isDragging,
                screenCenter: pointerFrame.center,
                markers: $viewModel.stationsMarkers
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
                bodyOverlay
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
            
            BouncingLoadingView(message: viewModel.loadingMessage)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color.background.opacity(0.5)
                        .ignoresSafeArea()
                }
                .opacity(viewModel.isLoading ? 1 : 0)
        }
        .navigation(isActive: $viewModel.push, destination: {
            viewModel.route?.screen
        })
        .sheet(isPresented: $viewModel.present, content: {
            NavigationView {
                viewModel.presentableRoute?.screen
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationTitle("all_stations".localize)
            }
            .presentationDetents([.fraction(0.95)])
        })
        .background {
            GeometryReader(content: { geometry in
                Color.clear.onAppear {
                    screenFrame = geometry.frame(in: .global)
                }
            })
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    private var bodyOverlay: some View {
        ZStack {
            mapGradientOverlay
            
            Button {
                self.viewModel.onClickSettings()
            } label: {
                settingsButton
            }
            
            PinPointerView(
                isActive: isDragging,
                type: viewModel.state == HomeViewState.selectFrom ? .pinA : .pinB)
            .frame(height: pointerHeight)
            .readRect(rect: $pointerFrame)
            .offset(.init(width: 0, height: -(pointerHeight / 2)))
            .opacity(viewModel.state != HomeViewState.routing ? 1 : 0)
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
                        isLoading: viewModel.isDetectingAddress || isDragging,
                        onClickBody: {
                            debugPrint("OnClick body 1")
                        }, onClickMap: {
                            // skip this method
                            debugPrint("OnClick map 1")
                        }
                    ),
                    to: .init(
                        title: viewModel.toAddress.nilIfEmpty ?? "no_address".localize,
                        isLoading: viewModel.state == .selectTo ? viewModel.isDetectingAddress : false,
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
                ),
                stations: Array(self.viewModel.stations[0..<min(viewModel.stations.count, 6)]),
                hasMoreButton: self.viewModel.stations.count > 6,
                onClickMoreButton: {
                    viewModel.onClickViewAllStations()
                }
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
                        .foregroundStyle(Color.init(uiColor: .label.withAlphaComponent(0.6)))
                    
                    Text("\(viewModel.fromAddress)")
                        .font(.system(size: 13, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.init(uiColor: .label.withAlphaComponent(0.8)))
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
    
    private var mapGradientOverlay: some View {
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
