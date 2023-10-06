//
//  NetRes.swift
//  USDK
//
//  Created by applebro on 06/10/23.
//

import Foundation

public struct NetRes<T: NetResBody>: Codable {
    public let success: Bool
    public let data: T?
    public let error: String?
    public let code: Int?
}
