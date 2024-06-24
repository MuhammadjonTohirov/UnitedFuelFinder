//
//  AuthView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/10/23.
//

import Foundation
import SwiftUI

struct AuthView: View {
    @StateObject var viewModel: AuthorizationViewModel = .init()
    @State var showAlert: Bool = false
    
    var body: some View {
        mainBody
    }
    
    private var mainBody: some View {
        NavigationStack {
            DarkAuthBody()
                .environmentObject(viewModel)
                .keyboardDismissable()
                .alert("warning".localize,
                       isPresented: $viewModel.shouldShowAlert,
                       actions: {
                    Button("ok".localize.uppercased()) {
                        viewModel.hideAlert()
                    }
                }, message: {
                    Text(viewModel.alert.title ?? "")
                })
                .navigationDestination(isPresented: $viewModel.present) {
                    viewModel.route?.screen
                        .background(.appBackground)
                }
        }
        .ignoresSafeArea(.keyboard, edges: .all)
    }
    
    @ViewBuilder
    private var form: some View {
        YRoundedTextField {
            YTextField(
                text: $viewModel.username,
                placeholder: "sample@domain.com",
                contentType: UITextContentType.emailAddress,
                autoCapitalization: .never,
                left: {
                    Image(systemName: "person.fill")
                        .frame(width: 24)
                        .padding(.horizontal, Padding.small)
                }
            )
            .keyboardType(.emailAddress)
        }
        .set(error: viewModel.emailError ?? "")
        .padding(
            .horizontal, Padding.medium
        )
        
        YRoundedTextField {
            YTextField(
                text: $viewModel.password,
                placeholder: "••••••••",
                isSecure: true,
                contentType: UITextContentType.password,
                autoCapitalization: .never,
                left: {
                    Image("jcon_key")
                        .renderingMode(.template)
                        .frame(width: 24)
                        .padding(.horizontal, Padding.small)
                }
            )
            .keyboardType(.default)
        }
        .padding(
            .horizontal, Padding.medium
        )
    }
}


#Preview {
    UserSettings.shared.language = .english
    return AuthView()
}
