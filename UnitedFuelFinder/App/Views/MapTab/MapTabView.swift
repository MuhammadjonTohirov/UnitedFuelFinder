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
    
    @ObservedObject var viewModel: MapTabViewModel
    @EnvironmentObject var mainModel: MainViewModel
    @EnvironmentObject var tabModel: MainTabViewModel
    @State private var areaRadius: CGFloat = UserSettings.shared.maxRadius.f
    init(viewModel: MapTabViewModel) {
        self.viewModel = viewModel
    }
    
    @State private var pointerFrame: CGRect = .zero
    @State private var selectedMarker: GMSMarker?
    
    private let pointerHeight: CGFloat = 158
    private let locationManager = CLLocationManager()
    
    private var hasSafeArea: Bool {
        UIApplication.shared.safeArea.bottom != 0
    }
    
    @State private var stationInfoRect: CGRect = .zero
    
    private var bottomSafeArea: CGFloat {
        hasSafeArea ? UIApplication.shared.safeArea.bottom : 20
    }
    
    private var bottomSheetBottomPadding: CGFloat {
        0
    }
    
    var body: some View {
        ZStack {
            innerBody
                .overlay(content: {
                    CoveredLoadingView(
                        isLoading: $viewModel.isDrawing,
                        message: "Drawing route".localize
                    )
                })
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    areaRadius = UserSettings.shared.maxRadius.f
                    viewModel.onAppear()
                }
                .onChange(of: tabModel.mapBodyState, perform: { value in
                    (value == .map) ? viewModel.onSelectMap() : viewModel.onSelectList()
                })
                .onDisappear {
                    viewModel.onDisappear()
                }
            // cover tabbar
            GeometryReader(content: { geometry in
                VStack(spacing: 0) {
                    
                    Spacer()
                    
                    Rectangle()
                        .foregroundStyle(Color.background)
                        .ignoresSafeArea(.container, edges: .bottom)
                        .frame(height: 0)
                }
            })
        }
        .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 2)
        .navigationDestination(isPresented: $viewModel.push, destination: {
            viewModel.route?.screen
                .environmentObject(mainModel)
        })
        .coveredLoading(
            isLoading: $viewModel.isLoading,
            message: viewModel.loadingMessage
        )
        .onChange(of: viewModel.state, perform: { value in
            tabModel.leadningNavigationOpacity = value == .pickLocation ? 0 : 1
        })
        .background(.appBackground)
    }
    
    var innerBody: some View {
        ZStack {
            innerBodyByState
            
            bottomContent
                .opacity(tabModel.mapBodyState == .map ? 1 : 0)
        }
        .sheet(item: $selectedMarker, content: { marker in
            if let st = selectedMarker?.station {
                StationTipView(station: st, onClickShow: { station in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.viewModel.route = .stationDetails(station: station)
                    }
                }, onClickNavigate: { station in
                    self.viewModel.navigate(to: station)
                })
                .readRect(rect: $stationInfoRect)
                .presentationDetents([.height(stationInfoRect.height)])
            }
        })
        .fullScreenCover(isPresented: $viewModel.present, content: {
            NavigationView {
                viewModel.presentableRoute?.screen
                    .navigationBarTitleDisplayMode(.inline)
                    .environmentObject(mainModel)
                    .environmentObject(viewModel)
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
        switch self.tabModel.mapBodyState {
        case .map:
            mapView
            .onChange(of: viewModel.isDragging, perform: { value in
                if value {
                    self.viewModel.onDraggingMap()
                }
            })
            .ignoresSafeArea()
            .padding(.bottom, 8)
            .overlay {
                bodyOverlay
            }
            .ignoresSafeArea(.container, edges: .bottom)
            .padding(.bottom, -14)
            .onChange(of: $viewModel.pickedLocation, perform: { value in
                if viewModel.state == .routing {
                    return
                }
                
                if !viewModel.isMapReady {
                    return
                }
                
                self.viewModel.removeMarkers()
                self.viewModel.removeStations()
                self.viewModel.reloadAddress()
                self.viewModel.startFilterStations()
            })
        case .list:
            MapTabListView(
                stations: self.viewModel.stations,
                fromPoint: self.viewModel.fromLocation?.location
            )
            .environmentObject(self.viewModel)
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
            radius: viewModel.state != .default 
            ? 0
            : CLLocationDistance(((viewModel.filter?.radius ?? 0) + 4).f.asMeters)
        )
        .set(destinations: viewModel.destinations)
        .set(route: viewModel.mapRoute)
        .set(onClickMarker: { marker, point in
            if marker.hasStation {
                self.selectedMarker = marker
            }
        })
        .set(onChangeVisibleArea: { radius in
            guard viewModel.isMapReady else {
                return
            }
            
            Logging.l(tag: "MapTabView", "Change visible area \(radius)")

            viewModel.screenVisibleArea = radius
        })
    }
    
    private var bodyOverlay: some View {
        ZStack {
            mapGradientOverlay
            
            PinPointerView(
                isActive: viewModel.isDragging,
                label: viewModel.pointLabel
            )
            .frame(height: pointerHeight)
            .offset(.init(width: 0, height: -(115 / 2) - bottomSafeArea))
            .opacity(viewModel.state != HomeViewState.routing ? 1 : 0)
        }
        .overlay {
            VerticalValueAdjuster(
                maxValue: UserSettings.shared.maxRadius.f,
                currentValue: $areaRadius
            ) { value, percentage in
                viewModel.filter?.radius = Int(value)
                viewModel.startFilterStations()
            }
            .vertical(alignment: .top)
            .horizontal(alignment: .leading)
            .set(isVisible: viewModel.state == .default)
        }
    }
    
    private var bottomContent: some View {
        VStack {
            Spacer()
            HStack(alignment: .bottom) {
                if viewModel.state == .pickLocation {
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
                    from: fromLocationInput,
                    to: toLocationInput,
                    pickedAddress: viewModel.pickedLocationAddress ?? "",
                    state: viewModel.state != .pickLocation ? .mainView : .destinationView,
                    onClickReady: {
                        // draw route
                        viewModel.onClickDonePickAddress()
                    },
                    onClickAllDestinations: {
                        viewModel.onClickAllDestinations()
                    },
                    onClickAddDestination: {
                        viewModel.onClickAddDestination()
                    },
                    distance: viewModel.distance
                ),
                hasMoreButton: self.viewModel.stations.count > 6,
                isSearching: self.viewModel.isLoadingAddress,
                onClickMoreButton: {
                    viewModel.onClickViewAllStations()
                }, onClickNavigate: { station in
                    viewModel.focusToLocation(station.clLocation.coordinate)
                }, onClickOpen: { station in
                    viewModel.route = .stationDetails(station: station)
                }
            )
            .set(showAllButtons: viewModel.destinations.count > 1)
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
                .foregroundStyle(Color.background)
                .overlay {
                    Icon(systemName: "bell")
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
                .foregroundStyle(Color.background)
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
                .foregroundStyle(Color.background)
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
            viewModel.onClickResetMap()
        }, label: {
            Circle()
                .frame(width: 40, height: 40)
                .foregroundStyle(Color.background)
                .overlay {
                    Icon(systemName: "arrow.clockwise")
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
                    Icon(systemName: "arrow.left")
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
    
    private var fromLocationInput: HomeBottomSheetInput.ButtonInput {
        .init(
            title: viewModel.fromAddress.nilIfEmpty ?? "no_address".localize,
            isLoading: (viewModel.state != .routing) && (viewModel.isDetectingAddressFrom || viewModel.isDragging),
            label: 0.label.description,
            labelColor: .red,
            onClickBody: {
                self.viewModel.onClickSearchAddressFrom()
            }, onClickMap: {
                // skip this method
                debugPrint("OnClick map 1")
            }
        )
    }
    
    private var toLocationInput: HomeBottomSheetInput.ButtonInput {
        var label: String = "B"
        
        if viewModel.toLocation != nil {
            label = (viewModel.destinations.count - 1).label.description
        }
        
        return .init(
           title: viewModel.toAddress.nilIfEmpty ?? "no_address".localize,
           isLoading: viewModel.state == .pickLocation ? viewModel.isDetectingAddressTo : false,
           label: label,
           labelColor: .label,
           onClickBody: {
               self.viewModel.onClickSearchAddressTo()
           }, onClickMap: {
               debugPrint("OnClick map 2")
               self.viewModel.onClickpickLocationPointOnMap()
           }
       )
    }
}

#Preview {
    UserSettings.shared.setupForTest()
    return MainTabView()
}
