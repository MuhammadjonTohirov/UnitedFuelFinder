//
//  ProfileViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 06/11/23.
//

import Foundation
import UIKit

class ProfileViewModel: NSObject, ObservableObject, Alertable {
    var alert: AlertToast = .init(displayMode: .alert, type: .regular)
    
    @Published var shouldShowAlert: Bool = false
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var screenRect: CGRect = .zero
    @Published var address: String = ""
    @Published var companyName: String = ""
    @Published var fuelCardNumber: String = ""
    
    @Published var showImagePicker = false
    
    @Published var imageUrl: URL?
    @Published var avatar: UIImage = #imageLiteral(resourceName: "icon_man_placeholder")

    var sourceType: UIImagePickerController.SourceType = UIImagePickerController.SourceType.camera

    @Published var state: DState? {
        didSet {
            if oldValue != state {
                city = nil
            }
        }
    }
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
        !phoneNumber.isEmpty
//        !address.isEmpty &&
//        state != nil &&
//        city != nil
    }
    
    func onAppear() {
        @Sendable func _onAppear() {
            guard let user = UserSettings.shared.userInfo, !didAppear else {
                return
            }
            
            didAppear = true
            var nameComponents = user.fullName.components(separatedBy: " ")
            
            firstName = user.firstName ?? nameComponents.first ?? ""
            
            nameComponents.removeFirst()
            
            lastName = user.lastName ?? nameComponents.joined(separator: " ")
            phoneNumber = user.phone
            address = user.address ?? ""
            companyName = user.companyName ?? ""
            fuelCardNumber = user.cardNumber
            
            if let _stateKey = user.stateId, let _state = DState.item(id: _stateKey) {
                self.state = _state
            }
            
            if let _city = DCity.item(id: user.cityId ?? Int(user.cityName ?? "-1") ?? -1) {
                self.city = _city
            }
        }
        
        if UserSettings.shared.userInfo == nil {
            Task {
                await AuthService.shared.syncUserInfo()
                guard let user = UserSettings.shared.userInfo else {
                    return
                }
                
                if DCity.item(id: user.cityId ?? Int(user.cityName ?? "-1") ?? -1) == nil {
                    await CommonService.shared.syncCities(forState: user.stateId ?? "")
                }
                
                await MainActor.run {
                    _onAppear()
                }
            }
        } else {
            _onAppear()
        }
    }
    
    func editProfile(completion: @escaping () -> Void) {
        self.isLoading = true
        
        uploadAvatar { [weak self] isOK in
            guard let self, isOK else {
                return
            }
            let stateId = self.state?.id
            let cityId = self.city?.id
            
            Task {
                if await AuthService.shared.editUserInfo(
                    firstName: self.firstName,
                    lastName: self.lastName,
                    phone: self.phoneNumber,
                    state: stateId,
                    city: cityId,
                    address: self.address.nilIfEmpty,
                    company: self.companyName,
                    cardNumber: ""//self.fuelCardNumber
                ) {
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.showAlert(message: "profile_updated".localize)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            completion()
                        }
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
    
    func uploadAvatar(completion: @escaping (Bool) -> Void) {
        if let url = imageUrl {
            Network.upload(
                body: String.self,
                request: MainNetworkRouter.uploadAvatar(imageUrl: url)) { result in
                    let isOK = result?.success ?? false
                    if isOK {
                        UserSettings.shared.photoUpdateDate = Date()
                    }
                    completion(isOK)
                }
            return
        } 
        
        completion(true)
    }
}
