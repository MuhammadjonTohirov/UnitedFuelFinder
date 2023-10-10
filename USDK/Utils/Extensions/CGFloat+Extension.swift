//
//  CGFloat+Extension.swift
//  USDK
//
//  Created by applebro on 09/10/23.
//

import UIKit
import SwiftUI

public extension CGFloat {
    static let designWidth: CGFloat = 420
    static let designHeight: CGFloat = 898
    
    func width(_ w: CGFloat, limit: CGFloat = 1.2) -> CGFloat {
        ((self / CGFloat.designWidth) * w).limitTop(self * limit)
    }
    
    func height(_ h: CGFloat, limit: CGFloat = 0.8) -> CGFloat {
        ((self / CGFloat.designHeight) * h).limitBottom(self * limit)
    }
    
    func sw(limit: CGFloat = 1.2) -> CGFloat {
        width(375, limit: limit).limitBottom(self)
    }
    
    func sh(limit: CGFloat = 0.8) -> CGFloat {
        height(812, limit: limit).limitTop(self)
    }
}
