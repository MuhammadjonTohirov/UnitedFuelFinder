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
    
    public static let testAccessToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJFVXEwcHJTaVA4bkV6Zy1HZ2J1MVFTVnVXV1ZQU0pEbE9GNEJxSVRkWTJzIn0.eyJleHAiOjE3MTAzMDMwNzAsImlhdCI6MTcwOTQzOTA3MCwianRpIjoiMDI3OGZmNTQtMzM1OS00NDJiLWIxMTUtZTZmNDFkMzdiZWM2IiwiaXNzIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6IjVmMDZhZDlkLTljZDMtNGQ5NC1iYmYxLTE1MjEzMzAxNThkOSIsInR5cCI6IkJlYXJlciIsImF6cCI6ImFwaSIsInNlc3Npb25fc3RhdGUiOiIzNWE3ZGQzZi1lMWZmLTRiN2UtYTcyMS05MjBkNDJhODNmYTAiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iLCJkZWZhdWx0LXJvbGVzLXVmYyJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoiZW1haWwgcHJvZmlsZSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoiTXVoYW1tYWRqb24gVG9oaXJvdiIsInJvbGVfY29kZSI6ImRyaXZlciIsInByZWZlcnJlZF91c2VybmFtZSI6InRva2hpcm92Lm11a2hhbW1hZGpvbkBnbWFpbC5jb20iLCJnaXZlbl9uYW1lIjoiTXVoYW1tYWRqb24iLCJmYW1pbHlfbmFtZSI6IlRvaGlyb3YiLCJlbWFpbCI6InRva2hpcm92Lm11a2hhbW1hZGpvbkBnbWFpbC5jb20ifQ.Qe_XDfCz_320kaRWiGVEt6iiRYGtEwvNyzW_uX3SLb37b5HtgxXM3o9rlbJEQz-j7yAnYWQVVT9hjAx0vX6aHCYG0sAgCRZjA2IreUW_2ksRVIcDMwLLT9waID79ZU6hzi7a7zTT4qWQSeIxalmr1v0S9CxfbRiIUBjmvpEi-TIrT52CHKG77rxd6PxE7OXLTNWHumvePugSqNc6JhF2s0jwpJEyG1X_zISUcNPrup4j_QdJvEJZ7t8bZcxUkR-mRGKUPxmBBtks1X6kfEXs7hiaH4e_JD05TDkzjxmV9Q0tECN34I83apr4vCw_kFzrL71YreWNo14r1kJZl-C92w"
    
    public static let testRefreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmMTBmNTBjZS0wYzViLTQwZjEtOTc3MC0yMzhkZmNiMmFkYjcifQ.eyJleHAiOjE3MDkwODMxNTMsImlhdCI6MTcwODQ3ODM1MywianRpIjoiYWNmNjhlM2QtMGZiNy00MTcyLWE4YjQtMjVmMTE4OWM2NWI3IiwiaXNzIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwiYXVkIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwic3ViIjoiNWYwNmFkOWQtOWNkMy00ZDk0LWJiZjEtMTUyMTMzMDE1OGQ5IiwidHlwIjoiUmVmcmVzaCIsImF6cCI6ImFwaSIsInNlc3Npb25fc3RhdGUiOiI4MzkwMjZlNC04ZWM1LTQ3Y2ItODc5NC1lYjUwYTAzMDgxODUiLCJzY29wZSI6ImVtYWlsIHByb2ZpbGUifQ.W74CRdMJAs1sLf0cS_pfss41EVZqGc1WKSr6bDlT_Uc"
    
    public static let testEmail: String = "tokhirov.mukhammadjon@gmail.com"
    
    @codableWrapper(key: "currentAppVersion")
    public var currentVersion: String?
    
    @codableWrapper(key: "language", Language.english)
    public var language: Language? {
        didSet {
            UserDefaults.standard.setValue([language?.code ?? "en"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
    
    // map radiusis
    public let maxRadius: Int = 300

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
    
    @codableWrapper(key: "appPin")
    public var appPin: String?
    
    public var hasValidToken: Bool {
        return accessToken?.nilIfEmpty != nil && userEmail?.nilIfEmpty != nil
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
    
    @codableWrapper(key: "theme", .system)
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
    }
    
    func setInterfaceStyle(style: UIUserInterfaceStyle) {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first!.overrideUserInterfaceStyle = style
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
