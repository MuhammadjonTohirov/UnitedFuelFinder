//
//  NotificationsViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/11/23.
//

import Foundation

class NotificationModel: Identifiable, Equatable {
    var id: String
    var title: String
    var body: String
    var isRead: Bool
    var createdAt: Date
    
    init(id: String, title: String, body: String, isRead: Bool, createdAt: Date) {
        self.id = id
        self.title = title
        self.body = body
        self.isRead = isRead
        self.createdAt = createdAt
    }
    
    static func == (lhs: NotificationModel, rhs: NotificationModel) -> Bool {
        return lhs.id == rhs.id
    }
}

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    @Published var isLoading: Bool = false
    
    func onAppear() {
        isLoading = true
//        add mock data
        notifications.append(NotificationModel(id: "1", title: "Test".localize, body: "Lorem ipsum dolor sit amet consectetur. Ac luctus amet nibh dictum faucibus eu. Tincidunt urna id amet tristique enim massa viverra aliquet. ".localize, isRead: false, createdAt: Date()))
        notifications.append(NotificationModel(id: "2", title: "Test".localize, body: "Lorem ipsum dolor sit amet consectetur. Ac luctus amet nibh dictum faucibus eu. Tincidunt urna id amet tristique enim massa viverra aliquet. ".localize, isRead: false, createdAt: Date()))
        isLoading = false
//        NotificationsService.shared.getNotifications { [weak self] result in
//            guard let self = self else { return }
//            self.isLoading = false
//            switch result {
//            case .success(let notifications):
//                self.notifications = notifications
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
    
    func onDisappear() {
//        NotificationsService.shared.markAllAsRead()
        
    }
    
    func onClearAll() {
//        notifications = []
//        NotificationsService.shared.clearAll { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success:
//                self.notifications = []
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
}
