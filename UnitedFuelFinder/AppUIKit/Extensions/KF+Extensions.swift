//
//  KF+Extensions.swift
//  UnitedFuelFinder
//
//  Created by applebro on 15/02/24.
//

import SwiftUI
import Kingfisher

struct KF: View {
    var imageUrl: URL?
    var cacheKey: String?
    @State private var didAppear = false
    var storageExpiration: StorageExpiration? = nil
    var memoryExpiration: StorageExpiration? = nil
    var placeholder: AnyView
    
    var body: some View {
        if let url = imageUrl {
            KFImage(
                source: Source.network(
                    Kingfisher.KF.ImageResource(
                        downloadURL: url,
                        cacheKey: cacheKey ?? "\(url.absoluteString)_\(UserSettings.shared.userEmail ?? "")"
                    )
                )
            )
                .setHTTPHeader(name: "Authorization", value: "Bearer \(UserSettings.shared.accessToken ?? "")")
                .resizable()
                .placeholder({
                    placeholder
                })
                .aspectRatio(contentMode: .fill)
                .mask({
                    Circle()
                })
                .onAppear {
                    
                }
        } else {
            placeholder
        }
    }
}

extension KFImage {
    func setHTTPHeader(name: String, value: String) -> KFImage {
        let modifier = AnyModifier { request in
            var newRequest = request
            newRequest.httpMethod = "GET"
            newRequest.setValue(value, forHTTPHeaderField: name)
            return newRequest
        }
        
        return self.requestModifier(modifier)
    }
}
