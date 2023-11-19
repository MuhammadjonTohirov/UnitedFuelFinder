//
//  ProfileViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 06/11/23.
//

import Foundation

class ProfileViewModel: NSObject, ObservableObject, Alertable {
    var alert: AlertToast = .init(displayMode: .alert, type: .regular)
    
    @Published var shouldShowAlert: Bool = false
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var screenRect: CGRect = .zero
    @Published var address: String = ""
    
    @Published var state: DState?
    @Published var city: DCity?
    @Published var isLoading = false
    
    @Published var route: RegisterRoute? {
        didSet {
            showScreen = route != nil
        }
    }
    
    private var didAppear: Bool = false
    
    @Published var showScreen: Bool = false
    
    var isValidForm: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !phoneNumber.isEmpty &&
        !address.isEmpty &&
        state != nil &&
        city != nil
    }
    
    func onAppear() {
        guard let user = UserSettings.shared.userInfo, !didAppear else {
            return
        }
        
        didAppear = true
        var nameComponents = user.fullName.components(separatedBy: " ")
        
        firstName = nameComponents.first ?? ""
        nameComponents.removeFirst()
        lastName = nameComponents.joined(separator: " ")
        phoneNumber = user.phone
        address = user.address ?? ""
        
        if let _stateKey = user.state, let _state = DState.item(id: _stateKey) {
            self.state = _state
        }
        
        if let _city = DCity.item(id: user.cityId ?? -1) {
            self.city = _city
        }
    }
    
    func editProfile() {
        guard let stateId = state?.id, let cityId = city?.id else {
            return
        }
        self.isLoading = true
        Task {
            if await AuthService.shared.editUserInfo(
                firstName: firstName,
                lastName: lastName, phone: phoneNumber, state: stateId,
                city: cityId, address: address) {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.showAlert(message: "profile_updated".localize)
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.showError(message: "profile_updated_failed".localize)
                }
            }
        }
    }
}