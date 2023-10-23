//
//  HomeBottomSheetView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 18/10/23.
//

import Foundation
import SwiftUI
import UnitedUIKit
import USDK

struct HomeBottomSheetView: View {
    var input: HomeBottomSheetInput
    
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
            selectFromView
                .transition(.move(edge: .bottom))
        case .destinationView:
            selectToView
                .transition(.move(edge: .bottom))
            
        }
    }
    
    private var selectToView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Destination address")
                .font(.system(size: 24, weight: .semibold))
            
            HStack {
                Text(input.to.isLoading ? "loading_address".localize : input.to.title)
                    .font(.system(size: 13))
                    .frame(height: 32)
                
                Spacer()
                
                Text(input.distance)
                    .font(.system(size: 13))
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
    
    private var selectFromView: some View {
        VStack {
            FromPointButton(text: input.from.title, isLoading: input.from.isLoading, onClickBody: input.from.onClickBody)
                .padding(.top, Padding.small / 2)
                
            ToPointButton(text: input.to.title, isLoading: input.to.isLoading, onClickMap: input.to.onClickMap, onClickBody: input.to.onClickBody)
            
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
        
    }
    
    private var gasStationItem: some View {
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
}
