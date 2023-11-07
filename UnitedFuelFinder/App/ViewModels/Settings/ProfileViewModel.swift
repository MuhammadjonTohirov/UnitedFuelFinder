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
        
        firstName = user.fullName
        lastName = ""
        phoneNumber = user.phone
        address = user.address ?? ""
        
        if let _stateKey = user.state, let _state = DState.item(id: _stateKey) {
            self.state = _state
        }
        
        if let _city = DCity.item(id: user.cityId ?? -1) {
            self.city = _city
        }
    }
}
