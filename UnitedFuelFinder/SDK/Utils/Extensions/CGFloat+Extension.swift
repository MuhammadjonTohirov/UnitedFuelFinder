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


public extension Float {
    var asMoney: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = ""
        formatter.generatesDecimalNumbers = false
        formatter.alwaysShowsDecimalSeparator = false
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = ","
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
    
    var asMoneyBeautiful: AttributedString {
        let attr = NSMutableAttributedString()
        
        let left = self.rounded(.down).asDouble.asInt
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencySymbol = ""
        formatter.generatesDecimalNumbers = false
        formatter.alwaysShowsDecimalSeparator = false
        let leftStr = formatter.string(from: NSNumber(value: left)) ?? ""
        
        let right = (self.asDouble.truncatingRemainder(dividingBy: 1) * 100).asInt
        
        attr.append(.init(
            string: "$",
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .black),
                .foregroundColor: Color.black,
                .baselineOffset: 6
            ]
        ))
        attr.append(.init(
            string: leftStr,
            attributes: [
                .font: UIFont.systemFont(ofSize: 28, weight: .bold),
                .foregroundColor: Color.black
            ]
        ))
        
        attr.append(.init(
            string: "." + right.asString,
            attributes: [
                .font: UIFont.systemFont(ofSize: 18, weight: .black),
                .foregroundColor: Color.black
            ]
        ))
        
        // convert to attributed string
        return convertToAttributedString(attr)
    }
    
    // Sample function to demonstrate conversion
    private func convertToAttributedString(_ mutableAttributedString: NSMutableAttributedString) -> AttributedString {
        // Use the initializer to convert
        return AttributedString(mutableAttributedString)
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
