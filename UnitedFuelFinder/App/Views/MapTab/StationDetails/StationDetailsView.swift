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
    private var station: StationItem
    
    init(station: StationItem) {
        self.station = station
    }
    
    @State private var commentsPresented: Bool = false
    
    var body: some View {
        ZStack {
            innerBody
            
            CoveredLoadingView(isLoading: $viewModel.isLoading, message: "please_wait".localize)
        }
        .background(.appBackground)
        .onAppear {
            self.viewModel.station = station
            viewModel.onAppear()
        }
        .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 1.5)
    }
    
    var innerBody: some View {
        VStack {
            headerView
            
            details
                .background {
                    Rectangle()
                        .foregroundStyle(.background)
                }
                .zIndex(1)
            postFeedbacks
        
            comments
                .opacity(self.viewModel.commentList.isEmpty ? 0 : 1)
                .padding(.bottom, 50)
        }
        .scrollable(showIndicators: false)
        //.ignoresSafeArea(.container)
        .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
            
        .keyboardDismissable()
        .navigationDestination(isPresented: $commentsPresented, destination: {
            CommentsView()
        })
    }
    
    private var headerView: some View {
        GeometryReader(content: { geometry in
            KFImage(URL(string: viewModel.station?.customer?.logoUrl ?? ""))
                .placeholder {
                    Image("image_placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipped()
                        
                }
                .cacheMemoryOnly()
                .fade(duration: 0.25)
                .aspectRatio(contentMode: .fill)
                .stretchable(in: geometry)
        })
        .zIndex(0)
        .frame(height: UIApplication.shared.screenFrame.height * 0.45)
        .ignoresSafeArea(.container, edges: [.bottom, .horizontal])
        //.ignoresSafeArea()
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
                        .font(.system(size: 13, weight: .semibold))
                    
                    Text(viewModel.address ?? "unknown_address".localize)
                        .font(.system(size: 12))
                }
            }
            .padding(.leading)            
            
            [
                row(
                    title: "distance".localize,
                    detail: Text(viewModel.station?.distanceFromCurrentLocationInfo ?? "")
                        .font(.system(size: 12, weight: .medium))
                ),
                
                row(
                    title: "discounted_price".localize,
                    detail: Text(viewModel.station?.actualPriceInfo ?? "")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(Color.init(uiColor: .systemGreen))

                ),
                
                row(
                    title: "discount".localize,
                    detail: Text(viewModel.station?.discountInfo ?? "")
                        .font(.system(size: 12, weight: .medium))
                ),
                
                row(
                    title: "retail_price".localize,
                    detail: Text(viewModel.station?.retailPriceInfo ?? "")
                        .font(.system(size: 12, weight: .medium))
                ),
            ].vstack(spacing: Padding.small)
                .padding(.horizontal, Padding.medium)
        }
        .padding(.top)
    }
    
    private func row(title: String, detail: any View) -> some View {
        VStack {
            HStack {
                Text(title)
                    .font(.system(size: 12))
                Spacer()
                AnyView(detail)
            }
            
            Divider()
        }
    }
    private var postFeedbacks: some View {
        VStack(alignment: .leading) {
            Text("post_feedback".localize)
                .padding(.top)
                .padding(.horizontal)
                .font(.system(size: 14, weight: .medium))
            
            YTextView(
                text: $viewModel.comment,
                placeholder: "write_comment".localize
            )
            .padding(.horizontal, Padding.medium)
            
            starRating
        }
    }
    
    private var starRating: some View {
        HStack(spacing: 5) {
            RateView(starsCount: 5, rate: 0)
                .set(onRateChange: { rate in
                    Logging.l(tag: "StationDetails", "Rate \(rate)")
                    viewModel.rating = rate
                })
                .frame(width: 100, height: 20)
                .padding(.leading, Padding.small / 2)
            Spacer()
            
            Button(action: {
                viewModel.postFeedback()
            }, label: {
                Text("post".localize.capitalized)
                    .font(.system(size: 13, weight: .semibold))
            })
            .frame(width: 99, height: 40)
            .foregroundStyle(Color.label)
            .background(Color.init(uiColor: .secondarySystemBackground))
            .cornerRadius(6)
        }
        .padding(.horizontal, Padding.medium)
        .padding(.bottom)
    }
    
    private var comments: some View {
        VStack(alignment: .leading) {
            Divider()
                .padding(.bottom)

            Text("latest_comments".localize)
                .fontWeight(.semibold)
                .padding(.leading)
            
            ForEach(viewModel.commentList, id: \.id) { comment in
                comment.view
                    .set(onClickDelete: {
                        viewModel.deleteFeedback(id: comment.id.asInt)
                    })
                    .padding(.horizontal, Padding.medium)
                    .padding(.vertical, Padding.small / 2)
            }
            
            SubmitButton {
                self.commentsPresented = true
            } label: {
                Text("more_comments".localize)
            }
            .padding(Padding.medium)
        }
    }
}

#Preview {
    NavigationView {
        StationDetailsView(station: .init(id: 0, name: "Name", lat: 0, lng: 0, isDeleted: false, cityId: 1, customerId: 1, stateId: nil, priceUpdated: "", note: ""))
    }
}
