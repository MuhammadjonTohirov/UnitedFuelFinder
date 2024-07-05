//
//  Network.swift
//  USDK
//
//  Created by applebro on 06/10/23.
//

import Foundation
import UIKit

public protocol NetworkDelegate {
    func onAuthRequired()
}

public func setNetworkDelegate(_ delegate: NetworkDelegate?) {
    Network.delegate = delegate
}

struct Network {
    static var delegate: NetworkDelegate?
    
    static func send<T: NetResBody>(
        request: URLRequestProtocol,
        session: URLSession = URLSession.shared,
        refreshTokenIfNeeded: Bool = true
    ) async -> NetRes<T>? {
        do {
            Logging.l("--- --- REQUEST --- ---")
            Logging.l(request.url.absoluteString)
            Logging.l(request.request().allHTTPHeaderFields ?? [:])
            
            if refreshTokenIfNeeded {
                if (UserSettings.shared.tokenExpireDate?.timeIntervalSinceNow ?? 0) < 3600 {
                    let result = await AuthService.shared.refreshToken()
                    if !result {
                        return NetRes(success: false, data: nil, error: "cannot_do_refresh_token", code: -1)
                    }
                }
            }
            var requestJson:[String : Any]? = nil
            if let requestBody = request.request().httpBody,
               let json = try JSONSerialization.jsonObject(with: requestBody, options: .fragmentsAllowed) as? [String: Any]
            {
                Logging.l(json)
                requestJson = json
            }
            
            let result = try await session.data(
                for: request.request()
            )
            
            let path = request.request().url?.relativePath ?? ""
            
            if path.contains("Config") {
                print(request)
            }
            
            let data = result.0
            let code = (result.1 as! HTTPURLResponse).statusCode
            let string = String(data: data, encoding: .utf8) ?? ""
            
            if code == 401 {
                debugPrint("Cancel all tasks where 401 code")
                await session.cancelAllTasks()
                UserSettings.shared.clear()
                delegate?.onAuthRequired()
                return .init(success: false, data: nil, error: "401 error code", code: nil)
            }
                    
            Logging.l("--- --- RESPONSE --- ---")
            
            let res = try JSONDecoder().decode(NetRes<T>.self, from: data)
            
            let statusCode = res.code ?? 0
            
            if (res.asData?.count ?? 0) < 10000 {
                Logging.l(res.asString)
            }
            return res
            
        } catch let error {
            Logging.l("Error: \(error)")
            Logging.l(request.url.relativePath)
            Logging.l("Error: endline")
            let error = "\(request.url.absoluteString)\n\((error as NSError).description)"
            return .init(success: false, data: nil, error: error, code: nil)
        }
    }
    
    private static func onFail(forUrl url: String) {
        Logging.l("--- --- RESPONSE --- ---")
        Logging.l("nil data received from \(url)")
    }
    
    static func upload<T: NetResBody>(body: T.Type, request: URLRequestProtocol, completion: @escaping (NetRes<T>?) -> Void) {
        Logging.l("--- --- REQUEST --- ---")
        Logging.l(request.url.absoluteString)
        
        if let requestBody = request.request().httpBody, let json = try? JSONSerialization.jsonObject(with: requestBody, options: .fragmentsAllowed) as? [String: Any] {
            Logging.l(json)
        }
        
        URLSession.shared.uploadTask(with: request.request(), from: request.body) { data, a, error in
            guard let data = data, let res = try? JSONDecoder().decode(NetRes<T>.self, from: data) else {
                Logging.l(error?.localizedDescription ?? "Unable to parse data")
                completion(nil)
                return
            }
            
            Logging.l("--- --- RESPONSE --- ---")
            Logging.l(res.asString)
            
            completion(res)
        }.resume()
    }
    
    static func upload<T: NetResBody>(body: T.Type, request: URLRequestProtocol, fileUrl: URL, completion: @escaping (NetRes<T>?) -> Void) {
        Logging.l("--- --- REQUEST --- ---")
        Logging.l(request.url.absoluteString)
        
        if let requestBody = request.request().httpBody, let json = try? JSONSerialization.jsonObject(with: requestBody, options: .fragmentsAllowed) as? [String: Any] {
            Logging.l(json)
        }
        
        URLSession.shared.uploadTask(with: request.request(), fromFile: fileUrl) { data, a, error in
            guard let data = data, let res = try? JSONDecoder().decode(NetRes<T>.self, from: data) else {
                Logging.l(error?.localizedDescription ?? "Unable to parse data")
                completion(nil)
                return
            }
            
            Logging.l("--- --- RESPONSE --- ---")
            Logging.l(res.asString)
            
            completion(res)
        }.resume()
    }
}

class NetUploadHandler: NSObject, URLSessionDataDelegate {
    var onFinishUpload: (_ data: Data?) -> Void
    
    init(onFinishUpload: @escaping (_: Data?) -> Void) {
        self.onFinishUpload = onFinishUpload
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        onFinishUpload(data)
    }
}
