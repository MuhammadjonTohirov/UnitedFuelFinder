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
    
    public private(set) var userAvatarURL: URL = URL.baseAPI.appendingPath("Client", "ProfileAvatar")
    
    public static let testAccessToken = "eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJFVXEwcHJTaVA4bkV6Zy1HZ2J1MVFTVnVXV1ZQU0pEbE9GNEJxSVRkWTJzIn0.eyJleHAiOjE3MDY4MDIxMTAsImlhdCI6MTcwNjcxNTcxMCwianRpIjoiZDVmZjg3NjktOWMxNi00NTY1LTgyYTItOWVjNzQyYzZjMzgxIiwiaXNzIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwiYXVkIjoiYWNjb3VudCIsInN1YiI6IjVmMDZhZDlkLTljZDMtNGQ5NC1iYmYxLTE1MjEzMzAxNThkOSIsInR5cCI6IkJlYXJlciIsImF6cCI6ImFwaSIsInNlc3Npb25fc3RhdGUiOiJjMjk4M2ViZi0xMDIyLTRmN2EtYTExYS04N2ZjNzg2ZjdjMWQiLCJhY3IiOiIxIiwicmVhbG1fYWNjZXNzIjp7InJvbGVzIjpbIm9mZmxpbmVfYWNjZXNzIiwidW1hX2F1dGhvcml6YXRpb24iLCJkZWZhdWx0LXJvbGVzLXVmYyJdfSwicmVzb3VyY2VfYWNjZXNzIjp7ImFjY291bnQiOnsicm9sZXMiOlsibWFuYWdlLWFjY291bnQiLCJtYW5hZ2UtYWNjb3VudC1saW5rcyIsInZpZXctcHJvZmlsZSJdfX0sInNjb3BlIjoiZW1haWwgcHJvZmlsZSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJuYW1lIjoiTXVoYW1tYWRqb24gVG9oaXJvdiIsInJvbGVfY29kZSI6ImRyaXZlciIsInByZWZlcnJlZF91c2VybmFtZSI6InRva2hpcm92Lm11a2hhbW1hZGpvbkBnbWFpbC5jb20iLCJnaXZlbl9uYW1lIjoiTXVoYW1tYWRqb24iLCJmYW1pbHlfbmFtZSI6IlRvaGlyb3YiLCJlbWFpbCI6InRva2hpcm92Lm11a2hhbW1hZGpvbkBnbWFpbC5jb20ifQ.guG49RpQedW6VVBC5tiBlJ4_D-6IKLbyQ6BHZop08GlziqkY8CT3GptmYX5A7yWHvxzcm1iQmlAMGWV_SZYknME8d_BD9ANmbUKK885ln7FW19Dwrarg8BEfyuqlNQ5GKmnS9PGua4j7DUkECU-rLuWl3xnzG2QL0oJOqhk8SKsCzQ2JQpz3ANVUNt3U04SczgLMaTXXNzm13nP3z5-krCCnZKhLzk0dhoHvcycixewhTNnnyQt5b673nCXAKXg6arfOVDnfhrcVpbAKBlrTxyXIRVkF9V8R0pwaOaYbHjl7YCWP_D6xUzJdMwGuRZwSX9r5dpyJxEJ0SMBL6P9RrQ"
    
    public static let testRefreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICJmMTBmNTBjZS0wYzViLTQwZjEtOTc3MC0yMzhkZmNiMmFkYjcifQ.eyJleHAiOjE3MDcxNTQzMzMsImlhdCI6MTcwNjcxNTcxMCwianRpIjoiNzMxNzNjYWQtMmUzNy00OWJhLWI0YWUtMWE0MmY3MTFhMmJjIiwiaXNzIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwiYXVkIjoiaHR0cDovLzE1LjIzNS4yMTIuMTI5OjgwODAvYXV0aC9yZWFsbXMvVUZDIiwic3ViIjoiNWYwNmFkOWQtOWNkMy00ZDk0LWJiZjEtMTUyMTMzMDE1OGQ5IiwidHlwIjoiUmVmcmVzaCIsImF6cCI6ImFwaSIsInNlc3Npb25fc3RhdGUiOiJjMjk4M2ViZi0xMDIyLTRmN2EtYTExYS04N2ZjNzg2ZjdjMWQiLCJzY29wZSI6ImVtYWlsIHByb2ZpbGUifQ.aNI5KWSSGVIlk3nvJ3fj8A2LVwnHM59XpB0KIsB76XE"
    
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
    
    @codableWrapper(key: "lastActiveDate")
    public var lastActiveDate: Date?
    
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
