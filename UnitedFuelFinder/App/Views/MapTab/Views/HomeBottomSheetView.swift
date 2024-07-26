//
//  HomeBottomSheetView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 18/10/23.
//

import Foundation
import SwiftUI

struct HomeBottomSheetView: View {
    var input: HomeBottomSheetInput
    var hasMoreButton: Bool
    private var isSearching: Bool = false
    private var onClickMoreButton: (() -> Void)? = nil
    private var onClickNavigate: ((StationItem) -> Void)? = nil
    private var onClickOpen: ((StationItem) -> Void)? = nil
    private var showAllStationsButton = false
    
    init(input: HomeBottomSheetInput, hasMoreButton: Bool, isSearching: Bool = false,
         onClickMoreButton: (() -> Void)? = nil,
         onClickNavigate: ((StationItem) -> Void)? = nil,
         onClickOpen: ((StationItem) -> Void)? = nil
    ) {
        self.input = input
        self.hasMoreButton = hasMoreButton
        self.onClickMoreButton = onClickMoreButton
        self.onClickNavigate = onClickNavigate
        self.onClickOpen = onClickOpen
        self.isSearching = isSearching
    }
    
    var body: some View {
        innerBody
            .padding(Padding.medium)
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.background)
                    .ignoresSafeArea()
                    .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 0)
            }
    }
    
    @ViewBuilder
    private var innerBody: some View {
        switch input.state {
        case .mainView:
            mainFormView
                .transition(.move(edge: .bottom))
        case .destinationView:
            pickLocationView
                .transition(.move(edge: .bottom))
            
        }
    }
    
    private var pickLocationView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("destination_address".localize)
                .font(.lato(size: 24, weight: .semibold))
            
            HStack {
                Text(input.pickedAddress.isEmpty ? "loading_address".localize : input.pickedAddress)
                    .font(.lato(size: 13))
                    .frame(height: 32)
                
                Spacer()
                
                Text(input.distance)
                    .font(.lato(size: 13))
                    .foregroundStyle(Color.init(uiColor: .secondaryLabel))
            }
            
            SubmitButton {
                self.input.onClickReady()
            } label: {
                Text("done".localize)
            }.padding(.top, Padding.small)
            
        }
        .frame(maxWidth: .infinity)
    }
    
    private var mainFormView: some View {
        VStack {
            PointButton(
                text: input.from.title,
                isLoading: input.from.isLoading,
                label: input.from.label,
                labelColor: input.from.labelColor,
                onClickBody: input.from.onClickBody
            )
            .padding(.top, Padding.small / 2)
            
            PointButton(
                text: input.to.title,
                isLoading: input.to.isLoading,
                label: input.to.label,
                labelColor: input.to.labelColor,
                onClickMap: input.to.onClickMap,
                onClickBody: input.to.onClickBody
            )
            
            allDestinationsButton
                .set(isVisible: showAllStationsButton)
        }
    }
    
    private var allDestinationsButton: some View {
        HStack {
            SubmitButton {
                input.onClickAllDestinations()
            } label: {
                Text("all.directions".localize)
            }

            RoundedRectangle(cornerRadius: 8)
                .frame(width: 50, height: 50)
                .foregroundStyle(.background)
                .overlay {
                    Icon(systemName: "plus.circle.fill")
                }
                .onTapGesture {
                    input.onClickAddDestination()
                }
        }
    }
}

extension HomeBottomSheetView {
    func set(showAllButtons: Bool) -> Self {
        var v = self
        v.showAllStationsButton = showAllButtons
        return v
    }
}

#Preview {
    HomeBottomSheetView(
        input: .init(
            from: .init(title: "A", isLoading: false, onClickBody: {
                // on click from body
            }, onClickMap: {
                // on click map from body
            }),
            to: .init(title: "B", isLoading: false, onClickBody: {
                // on click to body
            }, onClickMap: {
                // on click map to body
            }),
            pickedAddress: "",
            onClickReady: {
                
            },
            onClickAllDestinations: {},
            onClickAddDestination: {},
            distance: "10"
        ),
        hasMoreButton: false,
        isSearching: true,
        onClickOpen:  { st in
            
        })
}
