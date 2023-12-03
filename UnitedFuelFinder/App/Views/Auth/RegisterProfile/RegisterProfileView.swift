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
    @Environment (\.presentationMode) private var presentationMode

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 28) {
                topHeading
                    .padding(.top, Padding.large)
                
                personalDetails
                
                organizationRequisites
                
                addressInfo
                
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
                    viewModel.doRegister { success in
                        success ? presentationMode.wrappedValue.dismiss() : ()
                    }
                    
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
        
    }
    
    private var topHeading: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(
                "lets_create_account".localize
            )
            .font(.system(size: 24, weight: .semibold))
            
            Text(
                "insert_creds".localize
            )
            .font(.system(size: 14, weight: .semibold))
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
                    .keyboardType(.decimalPad)
            }
        }
    }
    
    private var organizationRequisites: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Organization requisites")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.init(.label))
            
            YRoundedTextField {
                YTextField(text: $viewModel.companyName, placeholder: "Company name")
            }
            
            YRoundedTextField {
                YTextField(text: $viewModel.fuelCardNumber, placeholder: "Card Number: Ex-1254 528 987".localize)
            }
        }
    }
    
    private var addressInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Address Information".localize)
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
            Text("Offer".localize)
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
                debugPrint("Show offer")
            }
            .padding(.top, Padding.small)
            .padding(.bottom, Padding.large)
        }
    }
}


#Preview {
    NavigationView(content: {
        RegisterProfileView { _ in
            
        }
    })
}
