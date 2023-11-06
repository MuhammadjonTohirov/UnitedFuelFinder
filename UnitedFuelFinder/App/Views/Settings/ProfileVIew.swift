//
//  ProfileVIew.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 05/11/23.
//

import SwiftUI



struct ProfileVIew: View {
    @StateObject var viewModel = RegisterViewModel()
    @FocusState private var isFocused: Bool
    var onRegisterResult: (Bool) -> Void
    @Environment (\.presentationMode) private var presentationMode

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 28) {
                    
                personalDetails
                
                addressInfo
                
                Text("")
                    .frame(height: 100)
            }
            .keyboardDismissable()
            .toast($viewModel.shouldShowAlert, viewModel.alert)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.init(.label))
                    })
                }
            })
            
            VStack {
                Spacer()
                
                SubmitButton {
                    viewModel.doRegister { success in
                        success ? presentationMode.wrappedValue.dismiss() : ()
                    }
                    
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
        .readRect(rect: $viewModel.screenRect)
        .sheet(isPresented: $viewModel.showScreen, content: {
            viewModel.route?.screen
        })
        
    }
    
    
    private var personalDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Edit profile")
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
                .font(Font.custom("SF Compact", size: 13))
                .lineLimit(5, reservesSpace: true)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color.black.opacity(0.8) : Color.gray.opacity(0.5), lineWidth: 0.6)
                    )
                .focused($isFocused)        }
    }
}


#Preview {
    NavigationView(content: {
        ProfileVIew { _ in
            
        }
    })
}
