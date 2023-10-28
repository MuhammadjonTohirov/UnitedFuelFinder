//
//  UserSettings.swift
//  USDK
//
//  Created by applebro on 06/10/23.
//

import Foundation
import SwiftKeychainWrapper
//import RealmSwift

final public class UserSettings {
    public static let shared = UserSettings()
    
    public private(set) var userAvatarURL: URL = URL.baseAPI.appendingPath("Client", "ProfileAvatar")
    
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

    @codableWrapper(key: "userEmail")
    public var userEmail: String?
    
    @codableWrapper(key: "accessToken")
    public var accessToken: String?
    
    @codableWrapper(key: "refreshToken")
    public var refreshToken: String?
    
    @codableWrapper(key: "tokenExpireDate")
    public var tokenExpireDate: Date?
    
    @codableWrapper(key: "lastActiveDate")
    public var lastActiveDate: Date?
    
    @codableWrapper(key: "appPin")
    public var appPin: String?
    
    public var canShowMain: Bool {
        return accessToken?.nilIfEmpty != nil && Date() < tokenExpireDate ?? Date() && userEmail?.nilIfEmpty != nil
    }
    
    @codableWrapper(key: "isLanguageSelected", false)
    public var isLanguageSelected: Bool?
    
    @codableWrapper(key: "lastOTP", nil)
    public var lastOTP: String?
    
    @codableWrapper(key: "session", nil)
    public var session: String?
}
