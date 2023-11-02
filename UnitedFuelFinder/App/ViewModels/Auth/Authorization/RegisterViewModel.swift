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
    
    var id: String {
        switch self {
        case .selectState:
            return "state"
        case .selectCity:
            return "city"
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
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var fuelCardNumber: String = ""
    @Published var screenRect: CGRect = .zero
    @Published var address: String = ""

    @Published var state: DState?
    @Published var city: DCity?
    @Published var isLoading = false
    @Published var companyId: Int?
    
    var isValidForm: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !phoneNumber.isEmpty &&
        !fuelCardNumber.isEmpty &&
        !address.isEmpty &&
        state != nil &&
        city != nil && companyId != nil
    }
 
    func doRegister(completion: @escaping (Bool) -> Void) {
        Task {
            guard let email = UserSettings.shared.userEmail,
                  let code = UserSettings.shared.lastOTP,
                  let session = UserSettings.shared.session,
                  isValidForm else {
                return
            }
            
            DispatchQueue.main.async {
                self.isLoading = true
            }

            let req: NetReqRegister = .init(firstName: firstName, lastName: lastName,
                                            phone: phoneNumber, email: email, cardNumber: fuelCardNumber,
                                            state: state!.id, city: city!.id, address: address, companyId: companyId!,
                                            confirm: .init(code: code, session: session))
            
            let result = await AuthService.shared.register(with: req)
            
            result.0 ? self.showAlert(message: "registration_success".localize) : self.showError(message: "registration_failure".localize)

            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isLoading = false
                completion(result.0)
            }
        }
    }
}
