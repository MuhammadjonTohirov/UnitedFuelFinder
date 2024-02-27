//
//  HomeView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/10/23.
//

import Foundation
import SwiftUI
import GoogleMaps

struct MapTabView: View {
    @State private var bottomSheetFrame: CGRect = .zero
    @State private var screenFrame: CGRect = .zero
    
    @EnvironmentObject var viewModel: MapTabViewModel
    @EnvironmentObject var mainModel: MainViewModel
    
    @State private var pointerFrame: CGRect = .zero
    @State private var selectedMarker: GMSMarker?
    
    private let pointerHeight: CGFloat = 158
    private let locationManager = CLLocationManager()
    
    private var bottomSheetBottomPadding: CGFloat {
        0
    }
    
    var body: some View {
        ZStack {
            innerBody
                .overlay(content: {
                    CoveredLoadingView(isLoading: $viewModel.isDrawing, message: "Drawing route".localize)
                })
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    viewModel.onAppear()
                }
                .onChange(of: viewModel.bodyState, perform: { value in
                    (value == .map) ? viewModel.onSelectMap() : viewModel.onSelectList()
                })
        }
        .coveredLoading(isLoading: $viewModel.isLoading, message: viewModel.loadingMessage)
    }
    
    var innerBody: some View {
        ZStack {
            innerBodyByState
            
            bottomContent
                .opacity(viewModel.bodyState == .map ? 1 : 0)
        }
        .navigationDestination(isPresented: $viewModel.push, destination: {
            viewModel.route?.screen
                .environmentObject(mainModel)
        })        
        .sheet(item: $selectedMarker, content: { marker in
            if let st = selectedMarker?.station {
                StationTipView(station: st, onClickShow: { station in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.viewModel.route = .stationDetails(station: station)
                    }
                })
                .presentationDetents([.height(200)])
            }
        })
        .fullScreenCover(isPresented: $viewModel.present, content: {
            NavigationView {
                viewModel.presentableRoute?.screen
                    .navigationBarTitleDisplayMode(.inline)
                    .environmentObject(mainModel)
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
    }
    
    @ViewBuilder
    private var innerBodyByState: some View {
        switch self.viewModel.bodyState {
        case .map:
            mapView
            .onChange(of: $viewModel.pickedLocation, perform: { value in
                if viewModel.state == .routing {
                    return
                }
                
                self.viewModel.reloadAddress()
            })
        case .list:
            MapTabListView(
                stations: self.viewModel.stations
            )
        }
    }
    
    private var mapView: some View {
        GMapsViewWrapper(
            pickedLocation: $viewModel.pickedLocation,
            isDragging: $viewModel.isDragging,
            screenCenter: pointerFrame.center,
            markers: $viewModel.stationsMarkers
        )
        .set(currentLocation: viewModel.focusableLocation)
        .set(
            radius: viewModel.state == .routing ? 0 : CLLocationDistance(viewModel.filter?.radius ?? 0)
        )
        .set(route: viewModel.mapRoute)
        .set(onClickMarker: { marker, point in
            if marker.hasStation {
                self.selectedMarker = marker
            }
        })
        .ignoresSafeArea()
        .padding(.bottom, 8)
        .overlay {
            bodyOverlay
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .padding(.bottom, -14)
    }
    
    private var bodyOverlay: some View {
        ZStack {
            mapGradientOverlay
            
            PinPointerView(
                isActive: viewModel.isDragging,
                type: viewModel.state == HomeViewState.selectFrom ? .pinA : .pinB)
            .frame(height: pointerHeight)
            .offset(.init(width: 0, height: -(pointerHeight / 2)))
            .opacity(viewModel.state != HomeViewState.routing ? 1 : 0)
        }
    }
    
    private var bottomContent: some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom) {
                if viewModel.state == .selectTo {
                    backButtonView
                        .padding(.leading, 8)
                }
                
                if viewModel.state == .routing {
                    clearRouteButton
                        .padding(.leading, 8)
                }
                
                Spacer()
                
                currentLocationNavView
                    .padding(.trailing, 16)
                    .padding(.bottom, 8)
            }
            
            HomeBottomSheetView(
                input: .init(
                    from: .init(
                        title: viewModel.fromAddress.nilIfEmpty ?? "no_address".localize,
                        isLoading: viewModel.isDetectingAddressFrom || viewModel.isDragging,
                        onClickBody: {
                            self.viewModel.onClickSearchAddressFrom()
                        }, onClickMap: {
                            // skip this method
                            debugPrint("OnClick map 1")
                        }
                    ),
                    to: .init(
                        title: viewModel.toAddress.nilIfEmpty ?? "no_address".localize,
                        isLoading: viewModel.state == .selectTo ? viewModel.isDetectingAddressTo : false,
                        onClickBody: {
                            self.viewModel.onClickSearchAddressTo()
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
                stations: [], //Array(self.viewModel.discountedStations[0..<min(viewModel.discountedStations.count, 6)]),
                hasMoreButton: self.viewModel.stations.count > 6,
                isSearching: self.viewModel.isLoadingAddress,
                onClickMoreButton: {
                    viewModel.onClickViewAllStations()
                }, onClickNavigate: { station in
                    viewModel.focusToLocation(station.clLocation)
                }, onClickOpen: { station in
                    viewModel.route = .stationDetails(station: station)
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
        Image("icon_settings")
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(Color.label)
            .frame(width: 32, height: 32)
            .shadow(color: Color.black.opacity(0.15), radius: 5, x: 0, y: 0)
    }
    
    private  var notificationButton: some View {
        Button {
            self.viewModel.route = .notifications
        } label: {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.init(uiColor: .systemBackground))
                .overlay {
                    Image(systemName: "bell")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundStyle(Color.label.opacity(0.5))
                        .frame(width: 18, height: 18)
                }
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
        }
    }
    
    private var currentLocationNavView: some View {
        Button {
            self.viewModel.focusToCurrentLocation()
        } label: {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.init(uiColor: .systemBackground))
                .overlay {
                    Image("icon_navigation")
                        .renderingMode(.template)
                        .foregroundStyle(Color.label.opacity(0.5))

                }
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
        }
    }
    
    private var filterView: some View {
        Button {
            
        } label: {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.init(uiColor: .systemBackground))
                .overlay {
                    Image("icon_filter")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.label.opacity(0.8))
                }
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
        }
    }
    
    private var clearRouteButton: some View {
        Button(action: {
            viewModel.onClickBack()
            viewModel.clearDestination()
        }, label: {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.init(uiColor: .systemBackground))
                .overlay {
                    Image(systemName: "arrow.clockwise")
                        .resizable()
                        .renderingMode(.template)
                        .aspectRatio(contentMode: .fit)
                        .fixedSize()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(Color.label.opacity(0.8))
                }
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
                
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
    UserSettings.shared.accessToken = UserSettings.testAccessToken
    UserSettings.shared.refreshToken = UserSettings.testRefreshToken
    UserSettings.shared.userEmail = UserSettings.testEmail
    UserSettings.shared.appPin = "0000"
    return MainView()
}
