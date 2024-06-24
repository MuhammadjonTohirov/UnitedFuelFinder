//
//  RegisterViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 27/10/23.
//

import Foundation
import SwiftUI

enum RegisterRoute: ScreenRoute {
    case selectState(_ state: Binding<DState?>)
    case selectCity(_ city: Binding<DCity?>, _ stateId: String)
    case selectCompany(_ company: Binding<DCompany?>)
    
    var id: String {
        switch self {
        case .selectState:
            return "state"
        case .selectCity:
            return "city"
        case .selectCompany:
            return "company"
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    @ViewBuilder
    var screen: some View {
        switch self {
        case let .selectState(state):
            NavigationView {
                SelectStateView(state: state)
            }
        case .selectCity(let city, let stateId):
            NavigationView {
                SelectCityView(city: city, stateId: stateId)
            }
        case .selectCompany(let company):
            NavigationView {
                SelectCompanyView(company: company)
            }
        }
    }
}

class RegisterViewModel: NSObject, ObservableObject, Alertable {
    var alert: AlertToast = .init(displayMode: .alert, type: .regular)
    
    @Published var shouldShowAlert: Bool = false
    
    @Published var route: RegisterRoute? {
        didSet {
            showScreen = route != nil
        }
    }
    
    @Published var showScreen: Bool = false
    @Published var isOfferAccepted: Bool = false

    @Published var email: String = ""
    @Published var password1: String = ""
    @Published var password2: String = ""

    
    @Published var firstName: String = ""
    @Published var lastName: String = ""

    @Published var phoneNumber: String = ""
    @Published var companyName: String = ""
    @Published var fuelCardNumber: String = ""

    @Published var screenRect: CGRect = .zero
    @Published var address: String = ""

    @Published var state: DState?
    @Published var city: DCity?

    @Published var isLoading = false
    
    @Published var showRegisterWarning = false
    
    var isValidForm: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !phoneNumber.isEmpty &&
        //!fuelCardNumber.isEmpty &&
        //!address.isEmpty &&
        !email.isEmpty &&
        !password1.isEmpty &&
        !password2.isEmpty &&
        password1 == password2 &&
//        state != nil &&
//        city != nil && 
        !companyName.isEmpty &&
        isOfferAccepted
    }
 
    func doRegister(completion: @escaping (Bool) -> Void) {
        let stateModel = self.state?.asModel
        let cityModel = self.city?.asModel
        
        Task {
            guard isValidForm else {
                return
            }
            
            DispatchQueue.main.async {
                self.isLoading = true
            }
            
            let req: NetReqRegister = .init(
                firstName: firstName, lastName: lastName,
                phone: phoneNumber, email: email, password: password1,
                cardNumber: fuelCardNumber,
                state: stateModel?.id, city: cityModel?.id, address: address.nilIfEmpty, 
                companyName: companyName
            )
            
            let result = await AuthService.shared.register(with: req)
            if result.0{
                self.showAlert(message: "registration_success".localize)
            } else{
                let message = result.1?.localizedDescription ?? "registration_failure".localize
                self.showError(message: message)
            }
            //result.0 ? self.showAlert(message: "registration_success".localize) : self.showError(message: "registration_failure".localize)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoading = false
                completion(result.0)
            }
        }
    }
    
    func onSuccessRegister() {
        self.showRegisterWarning = true
    }
}
