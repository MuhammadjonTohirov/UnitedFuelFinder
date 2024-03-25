//
//  ProfileVIew.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 05/11/23.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct ProfileVIew: View {
    @StateObject var viewModel = ProfileViewModel()
    @State private var showPickerAlert = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 28) {

                VStack(spacing: 8) {
                    if viewModel.imageUrl == nil {
                        KF(
                            imageUrl: UserSettings.shared.userAvatarURL,
                            cacheKey: (UserSettings.shared.photoUpdateDate ?? Date()).toString(),
                            storageExpiration: .expired,
                            memoryExpiration: .expired,
                            placeholder: Image(uiImage: viewModel.avatar)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80.f.sw(), height: 80.f.sw(), alignment: .center)
                                .clipShape(Circle())
                                .anyView
                        )
                        .frame(width: 80.f.sw(), height: 80.f.sw())
                        .background {
                            Circle()
                                .foregroundColor(Color(uiColor: .secondarySystemBackground))
                        }
                    } else {
                        Image(uiImage: viewModel.avatar)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80.f.sw(), height: 80.f.sw(), alignment: .center)
                            .clipShape(Circle())
                            .anyView
                    }
                        
                    Button(action: {
                        showPickerAlert = true
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
                    viewModel.editProfile {
                        dismiss()
                    }
                } label: {
                    Text("Save")
                }
                .set(isLoading: viewModel.isLoading)
                .set(isEnabled: viewModel.isValidForm)
                .padding(.bottom, Padding.medium)
            }
            .ignoresSafeArea(.keyboard, edges: .all)
        }
        .fullScreenCover(isPresented: $viewModel.showImagePicker, content: {
            ImagePicker(
                sourceType: viewModel.sourceType,
                selectedImage: $viewModel.avatar,
                imageUrl: $viewModel.imageUrl)
            .ignoresSafeArea()
        })
        .confirmationDialog("select_image".localize, isPresented: $showPickerAlert) {
            Button("camera".localize) {
                viewModel.sourceType = .camera
                viewModel.showImagePicker = true
            }
            
            Button("gallery".localize) {
                viewModel.sourceType = .photoLibrary
                viewModel.showImagePicker = true
            }
            
            Button("cancel".localize, role: .cancel) {
                viewModel.showImagePicker = false
            }
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
        .background(Color.background)
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
    UserSettings.shared.accessToken = UserSettings.testAccessToken
    return NavigationView {
        ProfileVIew()
    }
}
