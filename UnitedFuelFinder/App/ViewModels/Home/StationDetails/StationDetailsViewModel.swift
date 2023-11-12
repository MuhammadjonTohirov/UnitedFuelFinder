//
//  StationDetailsViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/11/23.
//

import Foundation

class StationDetailsViewModel: NSObject, ObservableObject, Alertable {
    var alert: AlertToast = .init(displayMode: .alert, type: .complete(.black))
    
    @Published var shouldShowAlert: Bool = false
    
    private var didAppear = false

    var station: StationItem?

    @Published var commentList: [StationCommentItem] = []
    
    @Published var isLoading: Bool = false
    
    @Published var comment: String = ""
    
    var rating: Int = 0

    var name: String {
        station?.name ?? ""
    }
    
    var address: String? {
        station?.address ?? ""
    }
    
    func onAppear() {
        
        if !didAppear {
            didViewAppear()
        }
        
        didAppear = true
    }
    
    private func didViewAppear() {
        
        self.loadFeedbacks()
    }
    
    func loadFeedbacks() {
        guard let station else {
            return
        }
        
        showLoader()
        
        Task {
            let comments = await MainService.shared.feedbacksFor(station: station.id)
            
            await MainActor.run(body: {
                self.commentList = comments
            })
            
            hideLoader()
        }
    }
    
    func postFeedback() {
        guard let station else {
            return
        }
        
        Task {
            guard !comment.isEmpty && rating != 0 else {
                return
            }
            
            self.showLoader()
            
            if await MainService.shared.postFeedbackFor(station: station.id, rate: rating, comment: comment) {
                showAlert(message: "Feedback posted successfully")
            } else {
                showError(message: "Feedback post failed")
            }
            
            self.hideLoader()
        }
    }
    
    func deleteFeedback(id: Int) {
        Task {
            self.showLoader()
            if await MainService.shared.deleteFeedback(id: id) {
                showAlert(message: "Feedback deleted successfully")
            } else {
                showError(message: "Feedback delete failed")
            }
            self.hideLoader()
        }
    }
    
    private func showLoader() {
        DispatchQueue.main.async {
            self.isLoading = true
        }
    }
    
    private func hideLoader() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
