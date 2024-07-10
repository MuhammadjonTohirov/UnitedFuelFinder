//
//  UserSettings.swift
//  USDK
//
//  Created by applebro on 06/10/23.
//

import Foundation
import UIKit
import SwiftKeychainWrapper
import CoreLocation

final public class UserSettings {
    public static let shared = UserSettings()
    
    public private(set) var userAvatarURL: URL = URL.baseAPI.appendingPath("Driver", "DownloadAvatar")
    
    public static let testAccessToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJFVXEwcHJTaVA4bkV6Zy1HZ2J1MVFTVnVXV1ZQU0pEbE9GNEJxSVRkWTJzIn0.eyJleHAiOjE3MzAzOTU5MTMsImlhdCI6MTcyMDAyNzkxMywianRpIjoiNDg2ODUyNTAtM2Q1OC00NjkxLWFlNWEtZTYwZWFhZGM1ODAwIiwiaXNzIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6IjU3MjVkOGRjLWIxYWMtNGY5YS1iOGI5LTZlNzEwYjlkNGQ3ZiIsInR5cCI6IkJlYXJlciIsImF6cCI6ImNhYmluZXQiLCJzZXNzaW9uX3N0YXRlIjoiODE4ZWI4ZmUtNWU4NS00OGY5LTljZTItOTEwM2JmODE4YzRhIiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIiwiZGVmYXVsdC1yb2xlcy11ZmMiXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6ImVtYWlsIHByb2ZpbGUiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6IlJhZGlzIFNhYmlyb3YiLCJyb2xlX2NvZGUiOiJjb21wYW55IiwicHJlZmVycmVkX3VzZXJuYW1lIjoicmFkbGVuLmluY0BnbWFpbC5jb20iLCJnaXZlbl9uYW1lIjoiUmFkaXMiLCJmYW1pbHlfbmFtZSI6IlNhYmlyb3YiLCJlbWFpbCI6InJhZGxlbi5pbmNAZ21haWwuY29tIn0.DTCgZV8o8l1DKLXun5o4aL61YJsYb7OaVdusY6B12qC_Gp2cqNUy03BVDKtJvemvGoUKRJ_85eo5Arc-ZcXirmha1L7sQdgLZRvtIyF8VSP_FMYlb_SbPG2dj3UHX4qAJuAcanwKzSY4EQ1Vm-Ql2y1stDaqoTzApb1ZjnuDkHOo_QqtJbAgSdnUlKpCD9vMP5i9V499MB0-ixuTvUQOmwQHavNiA1_DqRi5CCWVbxJ4fNoHtgoJHuKEqMmproy2aF7vqug5VwHCJHKLABMCHBMDWHrNev0bNYfiD-HNrfl3WleBrSKPNBQj-HpNE6HBpqSUUHYncS9yA6MdpMy8-g"
    
    public static let testRefreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmMTBmNTBjZS0wYzViLTQwZjEtOTc3MC0yMzhkZmNiMmFkYjcifQ.eyJleHAiOjE3MzUwNjUxODAsImlhdCI6MTcxOTUxMzE4MCwianRpIjoiMTQ4ZDEwYjctYjA3YS00YWFlLWEyNDQtOGIwYTFkNGJiM2ZkIiwiaXNzIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwiYXVkIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwic3ViIjoiNTcyNWQ4ZGMtYjFhYy00ZjlhLWI4YjktNmU3MTBiOWQ0ZDdmIiwidHlwIjoiUmVmcmVzaCIsImF6cCI6ImNhYmluZXQiLCJzZXNzaW9uX3N0YXRlIjoiMjVmYjQ0MzQtMzk5NC00NjI2LWJjMmItNmIyYjBkMzJjNjliIiwic2NvcGUiOiJlbWFpbCBwcm9maWxlIn0.BKS_rWvlreqcBqIQO9ncUNHwbgqyh5XPpZSwOTBnu6M"
    
    public static let testEmail: String = "tokhirov.mukhammadjon@gmail.com"
    
    func setupForTest(){
        UserSettings.shared.accessToken = UserSettings.testAccessToken
        UserSettings.shared.refreshToken = UserSettings.testRefreshToken
        UserSettings.shared.userEmail = UserSettings.testEmail
        UserSettings.shared.tokenExpireDate = Date().after(days: 2)
        UserSettings.shared.appPin = "0000"
        UserSettings.shared.userInfo = .init(email: "abbos@mail.ru", phone: "935852415", cardNumber: "1232 1232 1233 3212", stations: [
            "1", "2", "3", "4", "0", "5"
        ])
        UserSettings.shared.userInfo?.roleCode = "company"
        UserSettings.shared.userInfo?.permissionList = [
            "view_invoices", "view_transactions"
        ]
    }
    
    @codableWrapper(key: "currentAppVersion")
    public var currentVersion: String?
    
    @codableWrapper(key: "actualAppVersion")
    public var actualAppVersion: String?
    
    @codableWrapper(key: "language", Language.english)
    public var language: Language? {
        didSet {
            UserDefaults.standard.setValue([language?.code ?? "en"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
    
    // map radiusis
    public let maxRadius: Int = 50

    @codableWrapper(key: "userEmail")
    public var userEmail: String?
    
    @codableWrapper(key: "userInfo")
    public var userInfo: UserInfo?
    
    @codableWrapper(key: "accessToken")
    public var accessToken: String?
    
    @codableWrapper(key: "refreshToken")
    public var refreshToken: String?
    
    @codableWrapper(key: "tokenExpireDate")
    public var tokenExpireDate: Date?
    
    @codableWrapper(key: "refreshTokenExpireDate")
    public var refreshTokenExpireDate: Date?
    
    @codableWrapper(key: "lastActiveDate")
    public var lastActiveDate: Date?
    
    @codableWrapper(key: "photoUpdate")
    public var photoUpdateDate: Date?
    
    @codableWrapper(key: "currentAPIVersion")
    public var currentAPIVersion: ServerVersion?
    
    private var _userType: UserType?
    
    public var userType: UserType? {
        if let _userType {
            return _userType
        }
        
        _userType = userInfo?.roleCode == "company" ? .company : .driver
        
        return _userType
    }
    
    @codableWrapper(key: "appPin")
    public var appPin: String?
    
    public var hasValidToken: Bool {
        return accessToken?.nilIfEmpty != nil && refreshToken?.nilIfEmpty != nil
    }
    
    @codableWrapper(key: "isLanguageSelected", false)
    public var isLanguageSelected: Bool?
    
    @codableWrapper(key: "lastOTP", nil)
    public var lastOTP: String?
    
    @codableWrapper(key: "session", nil)
    public var session: String?
    
    @codableWrapper(key: "nearestItemsLogic", .currentLocation)
    public var mapCenterType: MapCenterType?
    
    @codableWrapper(key: "theme", nil)
    public var theme: Theme?
    
    func clear() {
        accessToken = nil
        refreshToken = nil
        tokenExpireDate = nil
        lastActiveDate = nil
        appPin = nil
        isLanguageSelected = nil
        lastOTP = nil
        session = nil
        userInfo = nil
        userEmail = nil
        language = .english
        currentVersion = nil
        theme = .light
        clearUserDefaults()
    }
    
    func setInterfaceStyle(style: UIUserInterfaceStyle) {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first!.overrideUserInterfaceStyle = style
        switch style {
        case .light:
            self.theme = .light
        case .dark:
            self.theme = .dark
        default:
            self.theme = .system
        }
    }
    
    
    private func clearUserDefaults() {
        let storage: UserDefaults = UserDefaults(suiteName: "uz.xcoder.YuzPay") ?? .standard
        
        for key in storage.dictionaryRepresentation().keys {
            storage.removeObject(forKey: key)
        }
    }
}

public enum Theme: Codable {
    case system
    case light
    case dark
    
    var name: String {
        switch self {
        case .system:
            return "system".localize
        case .light:
            return "light".localize
        case .dark:
            return "dark".localize
        }
    }
    
    var style: UIUserInterfaceStyle {
        switch self {
        case .system:
            return .unspecified
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

extension CLLocationCoordinate2D: Codable {
    public init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.singleValueContainer()
        let values = try container.decode([Double].self)
        
        latitude = values[0]
        longitude = values[1]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode([latitude, longitude])
    }
}
