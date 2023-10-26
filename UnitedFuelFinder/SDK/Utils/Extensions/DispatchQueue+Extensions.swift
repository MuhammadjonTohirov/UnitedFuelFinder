//
//  DispatchQueue+Extensions.swift
//  USDK
//
//  Created by applebro on 23/10/23.
//

import Foundation

public func mainIfNeeded(_ task: @escaping () -> Void) {
    guard !Thread.isMainThread else {
        task()
        return
    }
    
    DispatchQueue.main.async {
        task()
    }
}
