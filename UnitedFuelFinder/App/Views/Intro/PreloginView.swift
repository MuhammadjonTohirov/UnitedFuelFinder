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
    private var selectedType: UserType?
    
    private var color: Color {
//        selectedType == nil ? .gray : .accent
        .accent
    }
    
    var body: some View {
        NavigationStack {
            innerBody
                .navigationDestination(
                    isPresented: $viewModel.showLoginPage
                ) {
                    if let selectedType {
                        AuthView()
                    }
                }
        }
    }
    
    var innerBody: some View {
        Rectangle()
            .foregroundStyle(Color.appDarkGray)
            .overlay {
                Image("img_welcome")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
                    .padding(.bottom, 50)
            }
            .ignoresSafeArea()
            .overlay {
                VStack(spacing: 32) {
                    Spacer()
                    HStack(spacing: 32) {
                        largeRadioButton(
                            title: "driver".localize.capitalized,
                            selected: selectedType == .driver
                        ).onTapGesture {
                            selectedType = .driver
                        }.opacity(0)
                        
                        largeRadioButton(
                            title: "company".localize.capitalized,
                            selected: selectedType == .company
                        ).onTapGesture {
                            selectedType = .company
                        }.opacity(0)
                    }
                    .frame(width: 240.f.sw())
                    
                    Capsule()
                        .frame(
                            width: 202.f.sw(),
                            height: 48.f.sh()
                        )
                        .foregroundStyle(color)
                        .overlay {
                            Text("get.started".localize)
                                .font(.regular(size: 16))
                        }
                        .overlay {
                            Icon(systemName: "arrow.right")
                                .frame(width: 50)
                                .horizontal(alignment: .trailing)
                        }
                        .onTapGesture {
                            if selectedType == nil {
                                selectedType = .driver
                            }
                            
                            viewModel.showLoginPage = true
                        }
                        .shadow(color: color, radius: 8, x: 0, y: 0)
                        .padding(.bottom, 20)
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
