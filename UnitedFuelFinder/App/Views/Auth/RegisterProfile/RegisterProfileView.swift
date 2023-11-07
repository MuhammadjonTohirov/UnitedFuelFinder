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
    
    @FocusState private var isFocused: Bool

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
    
    private var organizationRequisites: some View{
        VStack(alignment: .leading, spacing: 16) {
            Text("Organization requisites")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.init(.label))
            
            SelectionButton(title: "Company", value: viewModel.company?.name ?? "") {
                viewModel.route = .selectCompany($viewModel.company)
            }
            
            YRoundedTextField {
                YTextField(text: $viewModel.fuelCardNumber, placeholder: "Card Number: Ex-1254 528 987".localize, contentType: .creditCardNumber)
                    .keyboardType(.numberPad)
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
            
            TextField("", text: $viewModel.address, prompt: Text("Address"), axis: .vertical)
                .padding()
                .textContentType(.streetAddressLine1)
                .font(Font.system(size: 14, weight: .regular))
                .lineLimit(5, reservesSpace: true)
                .padding(2)
                .background(
                    RoundedRectangle(
                        cornerRadius: 8
                    )
                    .stroke(lineWidth: 1).foregroundStyle(
                        isFocused ? Color.black.opacity(0.8) : Color.gray.opacity(0.5)
                    )
                    .padding(.horizontal, 1)
                )
                .focused($isFocused)
        }
    }
}


#Preview {
    NavigationView(content: {
        RegisterProfileView { _ in
            
        }
    })
}
