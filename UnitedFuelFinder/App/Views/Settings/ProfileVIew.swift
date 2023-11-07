//
//  ProfileVIew.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 05/11/23.
//

import SwiftUI



struct ProfileVIew: View {
    @StateObject var viewModel = ProfileViewModel()
    @FocusState private var isAddressFocused: Bool

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 28) {
                personalDetails
                
                addressInfo
                
                Text("")
                    .frame(height: 100)
            }
            .scrollable()
            .keyboardDismissable()
            .toast($viewModel.shouldShowAlert, viewModel.alert, duration: 1.5)
            
            VStack {
                Spacer()
                
                SubmitButton {
                    viewModel.editProfile()
                } label: {
                    Text("Save".localize)
                }
                .set(isLoading: viewModel.isLoading)
                .set(isEnabled: viewModel.isValidForm)
                .padding(.bottom, Padding.medium)
            }
            .ignoresSafeArea(.keyboard, edges: .all)
        }
        .padding(.horizontal, Padding.default)
        .navigationBarTitleDisplayMode(.inline)
        .readRect(rect: $viewModel.screenRect)
        .sheet(isPresented: $viewModel.showScreen, content: {
            viewModel.route?.screen
        })
        .onAppear {
            viewModel.onAppear()
        }
    }
    
    
    private var personalDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("edit_profile".localize)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(.init(.label))
                .padding(.vertical, Padding.large)
            
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
                        isAddressFocused ? Color.black.opacity(0.8) : Color.gray.opacity(0.5)
                    )
                    .padding(.horizontal, 1)
                )
                .focused($isAddressFocused)
        }
    }
}


#Preview {
    ProfileVIew()
}
