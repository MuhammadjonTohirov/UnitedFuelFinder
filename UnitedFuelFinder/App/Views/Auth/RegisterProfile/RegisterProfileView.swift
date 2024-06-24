//
//  RegisterProfileView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/10/23.
//

import Foundation
import SwiftUI

struct RegisterProfileView: View {
    @StateObject var viewModel = RegisterViewModel()

    var onRegisterResult: (Bool) -> Void
    @Environment (\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 28) {
                topHeading
                    .padding(.top, Padding.large)
                
                personalDetails
                
                organizationRequisites
                
//                addressInfo
                
                offerView
                
                Text("")
                    .frame(height: 100)
            }
            .scrollable()
            .keyboardDismissable()
            .toast($viewModel.shouldShowAlert, viewModel.alert)
            
            VStack {
                Spacer()
                
                SubmitButton {
                    onClickRegister()
                } label: {
                    Text("continue".localize)
                }
                .set(isLoading: viewModel.isLoading)
                .set(isEnabled: viewModel.isValidForm)
                .padding(.bottom, Padding.medium)
            }
            .ignoresSafeArea(.keyboard, edges: .all)
        }
        .padding(.horizontal, Padding.default)
        .readRect(rect: $viewModel.screenRect)
        .sheet(isPresented: $viewModel.showScreen, content: {
            viewModel.route?.screen
        })
        .onAppear {
            appDelegate?.transparentNavigationSetup()
        }
        .richAlert(
            type: .custom(image: Image("icon_success_check").resizable().frame(width: 56, height: 56, alignment: .center).anyView),
            title: "registration_success".localize,
            message: "register_warning".localize,
            isPresented: $viewModel.showRegisterWarning) {
                dismissView()
            }
        .background(.appBackground)
    }
    
    private func onClickRegister() {
        viewModel.doRegister { success in
            success ? viewModel.onSuccessRegister() : ()
        }
    }
    
    @ViewBuilder
    private var credentials: some View {
        YRoundedTextField {
            YTextField(
                text: $viewModel.email,
                placeholder: "email".localize,
                contentType: .emailAddress,
                autoCapitalization: .never,
                left: {
                    Image(systemName: "person.fill")
                        .frame(width: 24)
                        .padding(.horizontal, Padding.small)
                }
            )
        }
        
        YRoundedTextField {
            YTextField(
                text: $viewModel.password1,
                placeholder: "new.password".localize,
                isSecure: true,
                contentType: .newPassword,
                autoCapitalization: .never,
                left: {
                    Image("jcon_key")
                        .renderingMode(.template)
                        .frame(width: 24)
                        .padding(.horizontal, Padding.small)
                }
            )
        }
        
        YRoundedTextField {
            YTextField(
                text: $viewModel.password2,
                placeholder: "confirm.password".localize,
                isSecure: true,
                contentType: .newPassword,
                autoCapitalization: .never,
                left: {
                    Image("jcon_key")
                        .renderingMode(.template)
                        .frame(width: 24)
                        .padding(.horizontal, Padding.small)
                }
            )
        }
    }
    
    private var topHeading: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(
                "lets_create_account".localize
            )
            .font(.system(size: 24, weight: .semibold))
            
            credentials
        }
    }
    
    private var personalDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("personal_details".localize)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.init(.label))
            
            YRoundedTextField {
                YTextField(text: $viewModel.firstName, placeholder: "first_name".localize, contentType: .givenName)
            }
            
            YRoundedTextField {
                YTextField(text: $viewModel.lastName, placeholder: "last_name".localize, contentType: .familyName)
            }
            
            YRoundedTextField {
                YTextField(text: $viewModel.phoneNumber, placeholder: "phone_number".localize, contentType: .telephoneNumber)
                    .keyboardType(.phonePad)
            }
        }
    }
    
    private var organizationRequisites: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("organization_reqs".localize)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.init(.label))
            
            YRoundedTextField {
                YTextField(text: $viewModel.companyName, placeholder: "Company name")
            }
            
//            YRoundedTextField {
//                YTextField(text: $viewModel.fuelCardNumber, placeholder: "Card Number: Ex-1254 5284 9871 1243".localize)
//                    .keyboardType(.decimalPad)
//                    .set(format: "XXXX XXXX XXXX XXXX")
//            }
        }
    }
    
    private var addressInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("address_info".localize)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.init(.label))
            
            SelectionButton(title: "State", value: viewModel.state?.name ?? "") {
                viewModel.route = .selectState($viewModel.state)
            }
            
            SelectionButton(title: "City", value: viewModel.city?.name ?? "") {
                guard let stateId = viewModel.state?.id else {
                    return
                }
                
                viewModel.route = .selectCity($viewModel.city, stateId)
            }
            
            YTextView(text: $viewModel.address, placeholder: "address".localize.capitalized)
        }
    }
    
    private var offerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("auth_offer".localize)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.init(.label))
            
            Text("auth_offer_description".localize)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(.init(.label.opacity(0.7)))
                .lineSpacing(4)
            
            CheckButton(
                isSelected: $viewModel.isOfferAccepted,
                text: "auth_agree_offer".localize.highlight(
                    text: "auth_offer".localize,
                    color: .accent
                ).toSwiftUI
            ) {
                // open URL.publicOffer in browser
                openPdfUrl(URL.publicOffer)
            }
            .padding(.top, Padding.small)
            .padding(.bottom, Padding.large)
        }
    }
    
    private func dismissView() {
        dismiss.callAsFunction()
    }
    
    private func openPdfUrl(_ url: URL) {
        UIApplication.shared.open(url)
    }
}

#Preview {
    NavigationView(content: {
        RegisterProfileView { _ in
            
        }
    })
}
