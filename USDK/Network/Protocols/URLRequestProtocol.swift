//
//  URLRequestProtocol.swift
//  USDK
//
//  Created by applebro on 06/10/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case put = "PUT"
}

protocol URLRequestProtocol {
    var url: URL {get}
    var body: Data? {get}
    var method: HTTPMethod {get}
    func request() -> URLRequest
}
