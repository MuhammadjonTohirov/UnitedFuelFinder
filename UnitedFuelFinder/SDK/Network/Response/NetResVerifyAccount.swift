//
//  NetResVerifyAccount.swift
//  USDK
//
//  Created by applebro on 16/10/23.
//

import Foundation

struct NetResVerifyAccount: NetResBody {
    let code: String
    let session: String
    let exists: Bool
}
