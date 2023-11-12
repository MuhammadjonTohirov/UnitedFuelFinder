//
//  StationCommentItem.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/11/23.
//

import Foundation

struct StationCommentItem: Identifiable {
    var id: String
    private var senderName: String
    var comment: String
    var date: Date
    var rate: Int
    
    init(id: String, senderName: String, comment: String, date: Date, rate: Int) {
        self.id = id
        self.senderName = senderName
        self.comment = comment
        self.date = date
        self.rate = rate
    }
    
    var isMine: Bool {
        UserSettings.shared.userInfo?.id == id
    }
    
    var canDelete: Bool {
        isMine
    }
    
    var senderValue: String {
        isMine ? "you".localize : senderName
    }
    
    var dateValue: String {
        date.toExtendedString(format: "HH:mm dd/MM/YYYY")
    }
}
