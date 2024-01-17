//
//  OTPViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/10/23.
//

import SwiftUI

protocol OtpModelDelegate: NSObject {
    func otp(model: OtpViewModel, isSuccess: Bool)
}

final class OtpViewModel: ObservableObject {
    var title: String = "confirm_otp".localize
    var username: String = "935852415"
    
    var wholeNumber: String {
        username
    }
    
    @Published var otp: String = ""
    @Published var isValidForm = false
    @Published var counter: String = ""
    @Published var shouldResend = false
    @Published var otpErrorMessage = "" {
        didSet {
            DispatchQueue.main.async {
                self.showAlert = !self.otpErrorMessage.isNilOrEmpty
            }
        }
    }
    @Published var loading = false
    @Published var showAlert: Bool = false
    
    var resetOTP: (() async -> Void)?
    var confirmOTP: ((String) async -> (Bool, String?))?
    
    weak var delegate: OtpModelDelegate?
    
    private var maxCounterValue: Double = 120
    private var counterValue: Double = 0
    private var timer: Timer?
    
    init(title: String = "confirm_otp".localize, username: String, maxCounterValue: Double = 120) {
        self.title = title
        self.username = username
        self.maxCounterValue = maxCounterValue
    }
    
    func onTypingOtp() {
        isValidForm = otp.count == 6
        
        if isValidForm {
            onClickConfirm()
        }
    }
    
    func onAppear() {
        startCounter()
    }
    
    private func startCounter() {
        resetCounter()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onDownCounting), userInfo: nil, repeats: true)
    }
    
    private func resetCounter() {
        counterValue = maxCounterValue
        reloadCounterValue()
        invalidateTimer()
        shouldResend = false
    }
    
    private func reloadCounterValue() {
        counter = Date.formattedSeconds(counterValue, false)
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func onDownCounting() {
        counterValue -= 1
        
        if counterValue <= 0 {
            invalidateTimer()
            shouldResend = true
        }
        
        reloadCounterValue()
    }
    
    func requestForOTP() {
        resetCounter()
        showLoader()
        
        Task {
            try await Task.sleep(for: .seconds(1))
            self.hideLoader()
        }
    }
    
    func onClickConfirm() {
        self.showLoader()
        
        Task {
            guard let result = await self.confirmOTP?(otp) else {
                return
            }
            
            let isOK = result.0

            DispatchQueue.main.async {
                self.hideLoader()

                if !isOK {
                    self.otpErrorMessage = result.1?.nilIfEmpty ?? "invalid_otp".localize
                    
                    return
                }
            }
        }
    }
    
    private func onResultConfirm(_ result: Bool, _ error: String?) {
        self.hideLoader()
        self.otpErrorMessage = result ? "" : (error ?? "not_valid_otp".localize)
        self.delegate?.otp(model: self, isSuccess: result)
    }
    
    private func showLoader() {
        DispatchQueue.main.async {
            self.loading = true
        }
    }
    
    private func hideLoader() {
        DispatchQueue.main.async {
            self.loading = false
        }
    }
}
