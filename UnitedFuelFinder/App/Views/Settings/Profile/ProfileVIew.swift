//
//  ProfileVIew.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 05/11/23.
//

import SwiftUI



struct ProfileVIew: View {
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 28) {

                VStack(spacing: 8) {
                    Image("icon_man_placeholder")
                        .resizable()
                        .frame(width: 80, height: 80, alignment: .center)
                        .clipShape(Circle())
                    
                    Button(action: {
                        
                    }, label: {
                        Text("edit".localize)
                            .font(.system(size: 13, weight: .medium))
                            .frame(maxWidth: .infinity)
                    })
                }
                .padding(.top, Padding.default/2)
                
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
                    Text("Save")
                }
                .set(isLoading: viewModel.isLoading)
                .set(isEnabled: viewModel.isValidForm)
                .padding(.bottom, Padding.medium)
            }
            .ignoresSafeArea(.keyboard, edges: .all)
        }
        .padding(.horizontal, Padding.default)
        .navigationTitle("edit_profile".localize)
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
            Text("address_info".localize)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.init(.label))
            
            SelectionButton(title: "state".localize, value: viewModel.state?.name ?? "") {
                viewModel.route = .selectState($viewModel.state)
            }
            
            SelectionButton(title: "city".localize, value: viewModel.city?.name ?? "") {
                guard let stateId = viewModel.state?.id else {
                    return
                }
                
                viewModel.route = .selectCity($viewModel.city, stateId)
            }
            
            YTextView(text: $viewModel.address, placeholder: "address".localize.capitalized)
        }
    }
}


#Preview {
    NavigationView {
        ProfileVIew()
    }
}
