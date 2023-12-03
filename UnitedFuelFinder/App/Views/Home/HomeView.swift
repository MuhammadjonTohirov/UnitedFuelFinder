//
//  HomeView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/10/23.
//

import Foundation
import SwiftUI
import GoogleMaps
import SwiftUITooltip

struct HomeView: View {
    @State private var bottomSheetFrame: CGRect = .zero
    @State private var screenFrame: CGRect = .zero
    
    @ObservedObject var viewModel: HomeViewModel = HomeViewModel()
    @State private var pointerFrame: CGRect = .zero
    @State private var selectedMarker: GMSMarker?
    
    private let pointerHeight: CGFloat = 158
    private let locationManager = CLLocationManager()
    
    private var bottomSheetBottomPadding: CGFloat {
        viewModel.isDragging ? -bottomSheetFrame.height + 80 : 0
    }
    
    var body: some View {
        NavigationStack {
            innerBody
                .overlay(content: {
                    CoveredLoadingView(isLoading: $viewModel.isDrawing, message: "Drawing route".localize)
                })
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            self.viewModel.onClickSettings()
                        } label: {
                            settingsButton
                        }
                    }
                })
        }
    }
    
    var innerBody: some View {
        ZStack {
            GMapsViewWrapper(
                pickedLocation: $viewModel.pickedLocation,
                isDragging: $viewModel.isDragging,
                screenCenter: pointerFrame.center,
                markers: $viewModel.stationsMarkers
            )
//            .set(radius: self.viewModel.state == HomeViewState.selectFrom ? viewModel.radius : 0)
            .set(currentLocation: viewModel.focusableLocation)
            .set(
                from: self.viewModel.fromLocation?.coordinate,
                to: viewModel.state == .routing ? self.viewModel.toLocation?.coordinate : nil,
                onStartDrawing: {
                    Logging.l("Before start drawing")
                    viewModel.onStartDrawingRoute()
                },
                onEndDrawing: { isOK in
                    Logging.l("After end drawing")
                    viewModel.onEndDrawingRoute(isOK)
                }
            )
            .set(onClickMarker: { marker, point in
                self.selectedMarker = marker
                
            })
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
        }
        .navigationDestination(isPresented: $viewModel.push, destination: {
            viewModel.route?.screen
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
            
            PinPointerView(
                isActive: viewModel.isDragging,
                type: viewModel.state == HomeViewState.selectFrom ? .pinA : .pinB)
            .frame(height: pointerHeight)
            .readRect(rect: $pointerFrame)
            .offset(.init(width: 0, height: -(pointerHeight / 2)))
            .opacity(viewModel.state != HomeViewState.routing ? 1 : 0)
            
            VerticalValueAdjuster(currentValue: $viewModel.radiusValue) { value, percentage in
                viewModel.startFilterStations()
            }
            .position(x: 27, y: 24 + UIApplication.shared.safeArea.top)
            .opacity(self.viewModel.state == .routing ? 0 : 1)
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
                
                VStack {
                    notificationButton
                        
                    currentLocationNavView
                }
                    .padding(.trailing, 8)
            }
            
            HomeBottomSheetView(
                input: .init(
                    from: .init(
                        title: viewModel.fromAddress.nilIfEmpty ?? "No address",
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
                stations: Array(self.viewModel.discountedStations[0..<min(viewModel.discountedStations.count, 6)]),
                hasMoreButton: self.viewModel.discountedStations.count > 6,
                isSearching: self.viewModel.isLoading,
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
                .overlay {
                    VStack {
                        Text("address".localize)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.init(uiColor: .label.withAlphaComponent(0.6)))
                        
                        Text("\(viewModel.fromAddress)")
                            .font(.system(size: 13, weight: .medium))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.init(uiColor: .label.withAlphaComponent(0.8)))
                        Spacer()
                    }
                    .frame(maxWidth: UIApplication.shared.screenFrame.width * 2 / 3 )
                    .opacity(viewModel.isDragging ? 1 : 0)
                    .padding(.top, UIApplication.shared.safeArea.top)
                    .ignoresSafeArea()
                }
            Spacer()
        }.allowsHitTesting(false)
    }
}

#Preview {
    MainView()
}
