//
//  NetResStationComment.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/11/23.
//

import Foundation

//{
//      "id": 3,
//      "driverId": "a84622c9-c15f-4171-989d-657d187c94b1",
//      "driverName": "IOS Dev1",
//      "postTime": "2023-11-12T18:09:24.786563",
//      "favoriteStar": 4,
//      "comment": "Yaxshi ekan",
//      "isConfirmed": true,
//      "confirmDate": "2023-11-12T18:11:52.987581",
//      "stationId": 932,
//      "isMain": true,
//      "isDeleted": false,
//      "operatorId": "4cbbbc98-ef33-4c5d-ab58-0035856f5e95",
//      "operatorName": null
//    }

struct NetResStationComment: NetResBody {
    var id: Int
    var driverId: String?
    var driverName: String?
    var postTime: String?
    var favoriteStar: Int?
    var comment: String?
    var isConfirmed: Bool?
    var confirmDate: String?
    var stationId: Int?
    var isMain: Bool?
    var isDeleted: Bool?
    var operatorId: String?
    var operatorName: String?
}

extension NetResStationComment {
//    2023-11-12T18:09:24.786563
    var asModel: StationCommentItem {
        let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"
        return .init(id: "\(self.id)", senderName: self.driverName ?? "unknown".localize, comment: comment ?? "", date: Date.from(string: postTime ?? "", format: dateFormat) ?? Date(), rate: favoriteStar ?? 0)
    }
}
