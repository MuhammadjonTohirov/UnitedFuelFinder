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
    
    public static let testAccessToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJFVXEwcHJTaVA4bkV6Zy1HZ2J1MVFTVnVXV1ZQU0pEbE9GNEJxSVRkWTJzIn0.eyJleHAiOjE3MzAxMTk0OTAsImlhdCI6MTcxOTc1MTQ5MCwianRpIjoiN2I2ZWU3NmEtMDQyMi00NTdiLTlkMGQtYzcwN2M0MmNiZTQzIiwiaXNzIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6IjU3MjVkOGRjLWIxYWMtNGY5YS1iOGI5LTZlNzEwYjlkNGQ3ZiIsInR5cCI6IkJlYXJlciIsImF6cCI6ImNhYmluZXQiLCJzZXNzaW9uX3N0YXRlIjoiMjdiNGEwNzEtY2M2Ny00MmFlLWFlMTEtYzE4YTNjM2Y3NGUxIiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIiwiZGVmYXVsdC1yb2xlcy11ZmMiXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6ImVtYWlsIHByb2ZpbGUiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6IlJhZGlzIFNhYmlyb3YiLCJyb2xlX2NvZGUiOiJjb21wYW55IiwicHJlZmVycmVkX3VzZXJuYW1lIjoicmFkbGVuLmluY0BnbWFpbC5jb20iLCJnaXZlbl9uYW1lIjoiUmFkaXMiLCJmYW1pbHlfbmFtZSI6IlNhYmlyb3YiLCJlbWFpbCI6InJhZGxlbi5pbmNAZ21haWwuY29tIn0.BSsJgLhFPkly4JAmMq6EdpTz92E91aQFZgewQZj2Ivil9hD5aR8nNW_-dTsI1v1yjsflESGDNWq7bGeKysnTDDrzoJlL7Brn3TzxgIttBqb3jrdau5RVs8UERis9XFa81eEiMLYydDCgmTuaDeXXs7rhpf4g2_dUBCzIxs8k-uk-apzu335XfqEKoDOtJkR2scT_yipJdI47gfAySNbPH-tXNSvpu6aU2yeN5pGdrJ-MGWqVTZc3WFcOt9vawy_cbUgvmGK1txSsMZq0370zk4TFwuEU3cGmwLiHLD4n9GOxLqMITJkOWc2KqNz-NMNioT1vf4bEXNzpLw1zYvpY8g"
    
    public static let testRefreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmMTBmNTBjZS0wYzViLTQwZjEtOTc3MC0yMzhkZmNiMmFkYjcifQ.eyJleHAiOjE3MzUwNjUxODAsImlhdCI6MTcxOTUxMzE4MCwianRpIjoiMTQ4ZDEwYjctYjA3YS00YWFlLWEyNDQtOGIwYTFkNGJiM2ZkIiwiaXNzIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwiYXVkIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwic3ViIjoiNTcyNWQ4ZGMtYjFhYy00ZjlhLWI4YjktNmU3MTBiOWQ0ZDdmIiwidHlwIjoiUmVmcmVzaCIsImF6cCI6ImNhYmluZXQiLCJzZXNzaW9uX3N0YXRlIjoiMjVmYjQ0MzQtMzk5NC00NjI2LWJjMmItNmIyYjBkMzJjNjliIiwic2NvcGUiOiJlbWFpbCBwcm9maWxlIn0.BKS_rWvlreqcBqIQO9ncUNHwbgqyh5XPpZSwOTBnu6M"
    
    public static let testEmail: String = "tokhirov.mukhammadjon@gmail.com"
    
    func setupForTest(){
        UserSettings.shared.userType = .company
        UserSettings.shared.accessToken = UserSettings.testAccessToken
        UserSettings.shared.refreshToken = UserSettings.testRefreshToken
        UserSettings.shared.userEmail = UserSettings.testEmail
        UserSettings.shared.tokenExpireDate = Date().after(days: 2)
        UserSettings.shared.appPin = "0000"
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
    
    @codableWrapper(key: "userType", .driver)
    public var userType: UserType?
    
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
        userType = .driver
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
