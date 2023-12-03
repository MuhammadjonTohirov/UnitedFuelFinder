//
//  URL+Extensions.swift
//  YuzPay
//
//  Created by applebro on 11/02/23.
//

import Foundation
import UniformTypeIdentifiers

public extension URL {
    
    static var base: URL {
//        Pro: http://15.235.212.129:5000/
//        Dev: "http://178.33.123.109:5000"
        .init(string: "http://15.235.212.129:5000/")!
    }
    
    static var baseAPI: URL {
        base.appendingPath("api")
    }
    
    static var keyHeader: (key: String, value: String) {
        ("X-APP-SERIAL", "f27b97551c2a585fcea2e8395ebe8facff1e4a7981dba6d381b2c50066a8e3b9")
    }
    
    static var langHeader: (key: String, value: String) {
        ("X-LANG-CODE", (UserSettings.shared.language ?? .russian).smallCode)
    }
    
    static let googleMapsApiKey = "AIzaSyBFH2jjU7u1bSJA2ELl50rhCzLATJ4JoMo"
    
    func appendingPath(_ pathList: Any...) -> URL {
        var url = self
        pathList.forEach { path in
            if #available(iOS 16.0, *) {
                url = url.appending(component: "\(path)")
            } else {
                url = url.appendingPathComponent("\(path)")
            }
        }
        
        return url
    }
    
    static func googleRoutingAPI(from: String, to: String) -> URL? {
        return URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(from)&destination=\(to)&key=\(URL.googleMapsApiKey)")
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch {
            
        }
        return nil
    }
    
    var exists: Bool {
        FileManager.default.fileExists(atPath: self.path)
    }
    
    var fileSizeBeautifiedString: String {
        return ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file)
    }
    
    var mimeType: String {
        mimeTypeForPath(pathExtension: self.pathExtension)
    }

    private func mimeTypeForPath(pathExtension: String) -> String {
        return UTType(filenameExtension: pathExtension)?.preferredMIMEType ?? ""
    }
    
    func queries(_ queries: URLQueryItem...) -> URL {
        var components = URLComponents(string: self.absoluteString)
        components?.queryItems = Array(queries)
        return components?.url ?? self
    }
}

extension Language {
    fileprivate var smallCode: String {
        switch self {
        case .uzbek:
            return "uz"

        case .russian:
            return "ru"

        case .english:
            return "en"
        }
    }
}
