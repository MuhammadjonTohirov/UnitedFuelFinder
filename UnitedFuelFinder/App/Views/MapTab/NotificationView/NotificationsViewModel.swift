//
//  NotificationsViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/11/23.
//

import Foundation

class NotificationModel: Identifiable, Equatable {
    var id: Int
    var title: String
    var body: String
    var isRead: Bool
    var createdAt: String?
    
    init(id: Int, title: String, body: String, isRead: Bool, createdAt: String) {
        self.id = id
        self.title = title
        self.body = body
        self.isRead = isRead
        self.createdAt = createdAt
    }
    
    static func == (lhs: NotificationModel, rhs: NotificationModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func create(with log: AuditLog) -> NotificationModel {
        return NotificationModel(id: log.id ?? 0, title: log.action ?? "", body: log.note ?? "", isRead: true, createdAt: log.dateInfo)
    }
}

class NotificationsViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    @Published var isLoading: Bool = false
    
    func onAppear() {
        loadNotifications()
    }
    
    private func loadNotifications() {
        isLoading = true
        
        Task {
            let logs = await MainService.shared.getAuditLogs()
            
            await MainActor.run {
                self.notifications = logs.map { NotificationModel.create(with: $0) }.sorted(by: {$0.id > $1.id})
                self.isLoading = false
            }
        }
    }
}
