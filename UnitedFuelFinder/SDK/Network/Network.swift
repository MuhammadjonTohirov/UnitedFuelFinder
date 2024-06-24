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
            
            
            let data = result.0
            let code = (result.1 as! HTTPURLResponse).statusCode
            let string = String(data: data, encoding: .utf8) ?? ""
            
            if code == 401 {
                debugPrint("Cancel all tasks where 401 code")
                await session.cancelAllTasks()
                UserSettings.shared.clear()
                delegate?.onAuthRequired()
                return nil
            }
                    
            Logging.l("--- --- RESPONSE --- ---")
            
            
            let res = try JSONDecoder().decode(NetRes<T>.self, from: data)
            
            let statusCode = res.code ?? 0
            
            if (res.asData?.count ?? 0) < 10000 {
                Logging.l(res.asString)
            }
            if statusCode != 200 || code != 200{
                let items = request.request().allHTTPHeaderFields ?? [:]
                var headerString = ""
                for key in items.keys{
                    if key == "Authorization"{
                        continue
                    }
                    headerString.append("\(key) : \(items[key] ?? "")")
                    headerString.append("\n")
                }
                await Network.sendToTgBot(statusCode:code, responseString: string, bodyJson: requestJson, url:request.url.absoluteString, header: headerString)

            }
            //if statusCode != 200{
            //                return nil
            //          }
            return res
            
        } catch let error {
            Logging.l("Error: \(error)")
            Logging.l(request.url.relativePath)
            Logging.l("Error: endline")
            return nil
        }
    }
    @MainActor
    private static func sendToTgBot(statusCode:Int, responseString:String, bodyJson:[String:Any]?, url:String, header:String? = nil) async ->(){
        let tgToken = "6567816800:AAGhAlrnyL2gdNyo-AwCbo6BzesTQbG7kG0"
        let tgChatId = "-1002034734956"
        
        let phone = "Phone"
        let system = "iOS"
        let path =  url
        let bodyString = bodyJson?.description ?? "" //String(data: body, encoding: .utf8) ?? ""
        
        let responseStr = responseString
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss, EEEE"
        dateFormatter.locale = Locale(identifier: "en")
        let dateString = dateFormatter.string(from: Date())
        
        let version = Bundle.main.appVersion
        let build = Bundle.main.appBuild
        
        var params = ["User" : phone] as [String : String]
        params.removeValue(forKey: "User")
        params["System"] = system + " V:\(version).\(build)"
        params["Path"] = path
        params["Body"] = bodyString
        params["ServerResponse"] = responseStr ?? ""
        let codeString = "\(statusCode)"
        params["ResponseStatus"] = codeString
        
        
        var text = ""
        text.append("#iOS Error \n\n")
        text.append("\(dateString) \n\n")
        
        if path.contains("card") ||
            path.contains("cards") ||
            path.contains("categories") {
            text.append("@elyor_office \n\n")
        } else{
            text.append("@elyor_office \n\n")
        }
        
        for key in params.keys{
            if let val = params[key]{
                text.append("<b textColor=Red> ")
                text.append(key)
                text.append("</b> ")
                text.append(":")
                text.append(val)
                text.append("\n")
            }
        }
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""
        let deviceType = UIDevice.current.name
        //text.append("<span class=\"tg-spoiler\">Device:\(deviceId) , name: \(deviceType)</span>")
        text.append("\n")
        text.append("<span class=\"tg-spoiler\">Header:\n \(header ?? "")</span>")
        
        let urlString = "https://api.telegram.org/bot\(tgToken)/sendMessage?parse_mode=html&chat_id=\(tgChatId)&text=\(text)"
        let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: escapedString)!

        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
        }
        task.resume()
    }
    
//    private static func onReceive(code: Int, session: URLSession) async -> Bool {
//        if code == 401 {
//            await session.cancelAllTasks()
//            UserSettings.shared.clear()
//            delegate?.onAuthRequired()
//            return false
//        }
//        
//        return true
//    }
    
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
