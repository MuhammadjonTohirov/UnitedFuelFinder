//
//  RegisterProfileView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/10/23.
//

import Foundation
import SwiftUI



struct RegisterProfileView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var phoneNumber: String = ""
    @State private var fuelCardNumber: String = ""
    @State private var screenRect: CGRect = .zero
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 28) {
                topHeading
                    
                personalDetails
                
                addressInfo
                
                Text("")
                    .frame(height: 100)
            }
            .scrollable()
            .keyboardDismissable()
            
            
            VStack {
                Spacer()
                
                SubmitButton {
                    mainRouter?.navigate(to: .main)
                    UserSettings.shared.canShowMain = true
                } label: {
                    Text("continue".localize)
                }
                .padding(.bottom, Padding.medium)
            }
            .ignoresSafeArea(.keyboard, edges: .all)
        }
        .padding(.horizontal, Padding.default)
        .readRect(rect: $screenRect)
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
                YTextField(text: $firstName, placeholder: "first_name".localize, contentType: .givenName)
            }
            YRoundedTextField {
                YTextField(text: $lastName, placeholder: "last_name".localize, contentType: .familyName)
            }
            YRoundedTextField {
                YTextField(text: $phoneNumber, placeholder: "phone_number".localize, contentType: .telephoneNumber)
                    .keyboardType(.decimalPad)
            }
            YRoundedTextField {
                YTextField(text: $fuelCardNumber, placeholder: "fuel_number".localize)
                    .keyboardType(.asciiCapableNumberPad)
            }
        }
    }
    
    private var addressInfo: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("address_info".localize)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.init(.label))
            
            SelectionButton(title: "State", value: "") {
                
            }
            
            SelectionButton(title: "City", value: "") {
                
            }
            
            YRoundedTextField {
                YTextField(text: $phoneNumber, placeholder: "address".localize, contentType: .telephoneNumber)
                    .keyboardType(.decimalPad)
            }
            
            YRoundedTextField {
                YTextField(text: $fuelCardNumber, placeholder: "zip".localize)
                    .keyboardType(.asciiCapableNumberPad)
            }
        }
    }
}


#Preview {
    NavigationView(content: {
        RegisterProfileView()
    })
}
