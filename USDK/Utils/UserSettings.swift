//
//  UserSettings.swift
//  USDK
//
//  Created by applebro on 06/10/23.
//

import Foundation
import SwiftKeychainWrapper
import RealmSwift

final public class UserSettings {
    public static let shared = UserSettings()
    
    public private(set) var userAvatarURL: URL = URL.base.appendingPath("api", "Client", "ProfileAvatar")
    
    @codableWrapper(key: "language")
    public var language: Language? {
        didSet {
//            guard let realm = Realm.new, oldValue != language, !isAccessTokenExpired else {
//                return
//            }
//            
//            let categories = realm.objects(DMerchantCategory.self)
//            realm.trySafeWrite {
//                realm.delete(categories)
//            }
//
//            Task {
//                await MainNetworkService.shared.syncMerchantCategories()
//            }
        }
    }
    
//    accessToken
    @codableWrapper(key: "accessToken")
    public var accessToken: String?
}
