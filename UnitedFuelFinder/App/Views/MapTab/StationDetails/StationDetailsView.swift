//
//  StationDetailsView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 07/11/23.
//

import SwiftUI
import RealmSwift
import Kingfisher
 
struct StationDetailsView: View {
    
    @Environment (\.dismiss) var dismiss
    
    @StateObject var viewModel: StationDetailsViewModel = .init()
    
    @State private var commentsPresented: Bool = false
    private var station: StationItem
    init(station: StationItem) {
        self.station = station
    }
    
    private var userInfo: UserInfo? {
        UserSettings.shared.userInfo
    }
    
    var body: some View {
        ZStack {
            innerBody
            
            CoveredLoadingView(isLoading: $viewModel.isLoading, message: "please_wait".localize)
        }
        .background(.appBackground)
        .onAppear {
            viewModel.station = station
            viewModel.onAppear()
        }
        .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 1.5)
    }
    
    var innerBody: some View {
        VStack {
            headerView
                .clipped()
            
            details

            HStack{
                Spacer()
                navigateButton
            }
            .padding(.trailing, Padding.medium)
        }
        .scrollable(showIndicators: false)
        //.ignoresSafeArea(.container)
        .ignoresSafeArea(.container, edges: [.bottom, .top, .horizontal])
        .keyboardDismissable()
        .navigationDestination(isPresented: $commentsPresented, destination: {
            CommentsView()
        })
    }
    func openStation(_ stationItem: StationItem) {
        GLocationManager.shared.openLocationOnMap(stationItem.coordinate, name: stationItem.name)
    }
    private var navigateButton: some View {
        Button(action: {
            if let station = viewModel.station {
                self.openStation(station)
            }
        }, label: {
            Label(
                title: {
                    Text("navigate".localize)
                        .font(.lato(size: 12, weight: .medium))
                },
                icon: {
                    Image(
                        "icon_navigation_point"
                    ).renderingMode(
                        .template
                    )
                    .resizable()
                    .frame(width: 18, height: 18)
                }
            )
            .foregroundStyle(.black)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(content: {
                RoundedRectangle(cornerRadius: 6)
            })
            .font(.lato(size: 12))
            .padding(.vertical, 6)
        })
    }
    
    private var headerView: some View {
        KFImage(URL(string: viewModel.station?.customer?.logoUrl ?? ""))
            .placeholder {
                Image("image_placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipped()
            }
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .aspectRatio(contentMode: .fill)
            .background {
                Rectangle()
                    .foregroundStyle(.white)
            }
            .zIndex(0)
            .frame(
                width: UIApplication.shared.screenFrame.width,
                height: UIApplication.shared.screenFrame.height * 0.45
            )
    }
    
    private var details: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                KFImage(URL(string: viewModel.station?.customer?.iconUrl ?? ""))
                    .placeholder {
                        Image("image_placeholder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 32)
                    }
                    .setProcessor(
                        ResizingImageProcessor(referenceSize: CGSize(width: 32, height: 32))
                    )
                    .cacheMemoryOnly()
                    .fade(duration: 0.25)
                    .frame(height: 32)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(
                        Circle().stroke(Color.secondaryBackground, lineWidth: 1)
                    )
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(viewModel.name)
                        .font(.lato(size: 13, weight: .semibold))
                    
                    Text(viewModel.address ?? "unknown_address".localize)
                        .font(.lato(size: 12))
                }
            }
            .padding(.leading)
            StationDetailsWarning()
                .padding(.horizontal, Padding.default)
            [
                row(
                    title: "distance".localize,
                    detail: Text(viewModel.station?.distanceFromCurrentLocationInfo ?? "")
                        .font(.lato(size: 12, weight: .medium))
                ).anyView,

                row(
                    title: "discounted_price".localize,
                    detail: Text(viewModel.station?.actualPriceInfo ?? "")
                        .font(.lato(size: 12, weight: .bold))
                        .foregroundStyle(Color.init(uiColor: .systemGreen))

                )
                .set(isVisible: userInfo?.showDiscountedPrices ?? false)
                .anyView,
                
                row(
                    title: "discount".localize,
                    detail: Text(viewModel.station?.discountInfo ?? "")
                        .font(.lato(size: 12, weight: .medium))
                )
                .set(isVisible: userInfo?.showDiscountPrices ?? false)
                .anyView,
                
                row(
                    title: "retail_price".localize,
                    detail: Text(viewModel.station?.retailPriceInfo ?? "")
                        .font(.lato(size: 12, weight: .medium))
                ).anyView,
                
                row(
                    title: "price_update".localize,
                    detail: Text(viewModel.station?.priceUpdateInfo ?? "")
                        .font(.lato(size: 12, weight: .medium))
                ).anyView,
            ]
                .vstack(spacing: Padding.small)
                .padding(.horizontal, Padding.medium)
        }
        .padding(.top)
    }
    
    private func row(title: String, detail: any View) -> some View {
        VStack {
            HStack {
                Text(title)
                    .font(.lato(size: 12))
                Spacer()
                AnyView(detail)
            }
            
            Divider()
        }
    }
}

#Preview {
    NavigationView {
        StationDetailsView(station: .init(id: 0, name: "Name", lat: 0, lng: 0, isDeleted: false, cityId: 1, customerId: 1, stateId: nil, priceUpdated: "", note: ""))
    }
}
