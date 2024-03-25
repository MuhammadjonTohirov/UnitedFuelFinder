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


extension Float {
    var asMoney: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
}

extension CGFloat {
///  from meters
    var asMile: CGFloat {
        self * 0.000621371192
    }

/// from miles
    var asMeters: CGFloat {
        self * 1609.344
    }
    
    var kmToMile: CGFloat {
        self * 0.621371
    }
    
    var mileToKm: CGFloat {
        self * 1.60934
    }
}
