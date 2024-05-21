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
    
    public static let testAccessToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJFVXEwcHJTaVA4bkV6Zy1HZ2J1MVFTVnVXV1ZQU0pEbE9GNEJxSVRkWTJzIn0.eyJleHAiOjE3MjYxNzM4MTcsImlhdCI6MTcxNTgwNTgxNywianRpIjoiOWIzZmRhMTAtNTYxNi00ZDk3LWJjODAtNzVkNmMxMDMyNmFlIiwiaXNzIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6IjViY2RiOTQ0LTM3NjYtNDY4Yi1iM2ZiLTUxODY5MDBhMzllOCIsInR5cCI6IkJlYXJlciIsImF6cCI6ImNhYmluZXQiLCJzZXNzaW9uX3N0YXRlIjoiMmU5NWNkNGItODUyNS00Mzg4LTg2ZDAtMGZjMTU5YjAzZTgwIiwiYWNyIjoiMSIsInJlYWxtX2FjY2VzcyI6eyJyb2xlcyI6WyJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIiwiZGVmYXVsdC1yb2xlcy11ZmMiXX0sInJlc291cmNlX2FjY2VzcyI6eyJhY2NvdW50Ijp7InJvbGVzIjpbIm1hbmFnZS1hY2NvdW50IiwibWFuYWdlLWFjY291bnQtbGlua3MiLCJ2aWV3LXByb2ZpbGUiXX19LCJzY29wZSI6ImVtYWlsIHByb2ZpbGUiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwibmFtZSI6Ik11aGFtbWFkam9uIFRvaGlyb3YuIiwicm9sZV9jb2RlIjoiZHJpdmVyIiwicHJlZmVycmVkX3VzZXJuYW1lIjoidG9raGlyb3YubXVraGFtbWFkam9uQGdtYWlsLmNvbSIsImdpdmVuX25hbWUiOiJNdWhhbW1hZGpvbiIsImZhbWlseV9uYW1lIjoiVG9oaXJvdi4iLCJlbWFpbCI6InRva2hpcm92Lm11a2hhbW1hZGpvbkBnbWFpbC5jb20ifQ.gBnlmOBaqlOQkZfuVMlDY-M-O0y7N3O5edNflRQlVGg4GXE9T0-3wrgU-zQvx1gEsuRLlh42fO8DL5M070Mkf82TBm9J3Y7P-flNer2grD4Ue_f7vyeORUxO1obWScy9mxolo4q-M1OLPYO7XcutJRasSUuJkdY_5ZRjre3iCFj3YJKPkq7Pe_0uUhD4GQjpSRUMusD6hwS6C_ltJSHLIStGMAZo2wN3Ripm8urLWzzHPAW90NEL-HucrZYsXYvAW2a3jbLTl7oDCow1hAgOwqZQlrcjl21bgGOZG4RRWB6W3LUVmU2jJt2qphAVWadOcd7QnGOf6iJQzPxEm418ug"
    
    public static let testRefreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmMTBmNTBjZS0wYzViLTQwZjEtOTc3MC0yMzhkZmNiMmFkYjcifQ.eyJleHAiOjE3MDkwODMxNTMsImlhdCI6MTcwODQ3ODM1MywianRpIjoiYWNmNjhlM2QtMGZiNy00MTcyLWE4YjQtMjVmMTE4OWM2NWI3IiwiaXNzIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwiYXVkIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwic3ViIjoiNWYwNmFkOWQtOWNkMy00ZDk0LWJiZjEtMTUyMTMzMDE1OGQ5IiwidHlwIjoiUmVmcmVzaCIsImF6cCI6ImFwaSIsInNlc3Npb25fc3RhdGUiOiI4MzkwMjZlNC04ZWM1LTQ3Y2ItODc5NC1lYjUwYTAzMDgxODUiLCJzY29wZSI6ImVtYWlsIHByb2ZpbGUifQ.W74CRdMJAs1sLf0cS_pfss41EVZqGc1WKSr6bDlT_Uc"
    
    public static let testEmail: String = "tokhirov.mukhammadjon@gmail.com"
    
    func setupForTest(){
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
    
//    @codableWrapper(key: "appVersion")
//    public var appVersion: ServerVersion?
    
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
    
    @codableWrapper(key: "lastFromLocation", nil)
    public var fromLocation: Destination?
    
    @codableWrapper(key: "lastDestination", nil)
    public var destination: Destination?
    
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
        destination = nil
        fromLocation = nil
        theme = .light
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
