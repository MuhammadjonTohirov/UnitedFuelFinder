//
//  PreloginView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 26/06/24.
//

import Foundation
import SwiftUI

struct PreloginView: View {
    @StateObject var viewModel = PreloginViewModel()
    
    @State
    private var selectedType: UserType = .driver
    
    var body: some View {
        NavigationStack {
            innerBody
                .navigationDestination(
                    isPresented: $viewModel.showLoginPage
                ) {
                    AuthView(userType: selectedType)
                }
        }
    }
    
    var innerBody: some View {
        Rectangle()
            .foregroundStyle(Color.appDarkGray)
            .ignoresSafeArea()
            .overlay {
                Image("img_welcome")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .padding(.bottom, 50)
            }
            .overlay {
                VStack(spacing: 32) {
                    Spacer()
                    HStack(spacing: 32) {
                        largeRadioButton(
                            title: "driver".localize.capitalized,
                            selected: selectedType == .driver
                        ).onTapGesture {
                            selectedType = .driver
                        }
                        
                        largeRadioButton(
                            title: "company".localize.capitalized,
                            selected: selectedType == .company
                        ).onTapGesture {
                            selectedType = .company
                        }
                    }
                    .frame(width: 240.f.sw())
                    
                    Capsule()
                        .frame(
                            width: 202.f.sw(),
                            height: 48.f.sh()
                        )
                        .foregroundStyle(.accent)
                        .overlay {
                            Text("get.started".localize)
                                .font(.regular(size: 16))
                        }
                        .overlay {
                            Image(systemName: "arrow.right")
                                .frame(width: 50)
                                .horizontal(alignment: .trailing)
                        }
                        .onTapGesture {
                            viewModel.showLoginPage = true
                        }
                        .shadow(color: .accent.opacity(0.5), radius: 8, x: 0, y: 0)
                }
            }
    }
    
    private func largeRadioButton(title: String, selected: Bool) -> some View {
        HStack(spacing: 8) {
            radioView
                .border(
                    selected ? .accent : .gray,
                    width: 2,
                    cornerRadius: 12
                )
                .foregroundStyle(
                    .clear
                )
                .overlay {
                    Circle()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(selected ? .accent : .clear)
                }
            Text(title)
                .font(.bold(size: 16))
                .foregroundStyle(selected ? .accent : .gray)
        }
        .frame(height: 24)
    }
    
    private var radioView: some View {
        Circle()
            .frame(width: 24, height: 24)
    }
    
}

#Preview {
    PreloginView()
}
