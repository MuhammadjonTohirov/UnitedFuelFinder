//
//  MainNetworkRouter+Data.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/03/24.
//

import Foundation

extension MainNetworkRouter {
    var body: Data? {
        switch self {
        case .filterStations(let request), .discountedStations(let request, _), .filterStations2(let request):
            return request.asData
        case .postFeedback(_, let request):
            return request.asData
        case .uploadAvatar(let photoUrl):
            return autoreleasepool {
                guard let data = try? Data.init(contentsOf: photoUrl) else {
                    return nil
                }
                let form = MultipartForm(
                    parts: [
                        .init(
                            name: "File",
                            data: data,
                            filename: photoUrl.lastPathComponent,
                            contentType: photoUrl.mimeType
                        ),
                    ],
                    boundary: "Boundary-\(photoUrl.lastPathComponent)")
                return form.bodyData
            }
        default:
            return nil
        }
    }
}
