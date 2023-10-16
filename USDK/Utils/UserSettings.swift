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
    
    @codableWrapper(key: "language", Language.english)
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
    
    @codableWrapper(key: "lastActiveDate")
    public var lastActiveDate: Date?
    
    @codableWrapper(key: "appPin")
    public var appPin: String?
    
    @codableWrapper(key: "canShowMain", false)
    public var canShowMain: Bool?
    
    @codableWrapper(key: "isLanguageSelected", false)
    public var isLanguageSelected: Bool?
    
    @codableWrapper(key: "lastOTP", nil)
    public var lastOTP: String?
}
