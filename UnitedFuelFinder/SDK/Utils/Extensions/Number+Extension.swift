//
//  Number+Extension.swift
//  USDK
//
//  Created by applebro on 09/10/23.
//

import SwiftUI

public extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let value = Int(self * 100)
        return Double(value) / 100
    }
}

public extension Double {
    func limitTop(_ n: Double) -> Double {
        return (self > n) ? n : self
    }
    
    func limitBottom(_ n: Double) -> Double {
        return (self < n) ? n : self
    }
    
    var f: CGFloat {
        CGFloat(self)
    }
    
    var asFloat: Float {
        Float(self)
    }
}

public extension Int {
    func limitTop(_ n: Int) -> Int {
        return (self > n) ? n : self
    }
    
    func limitBottom(_ n: Int) -> Int {
        return (self < n) ? n : self
    }
    
    var f: CGFloat {
        CGFloat(self)
    }
}

public extension Int64 {
    func limitTop(_ n: Int64) -> Int64 {
        return (self > n) ? n : self
    }
    
    func limitBottom(_ n: Int64) -> Int64 {
        return (self < n) ? n : self
    }
    
    var f: CGFloat {
        CGFloat(self)
    }
}

public extension CGFloat {
    func limitTop(_ n: CGFloat) -> CGFloat {
        return (self > n) ? n : self
    }
    
    func limitBottom(_ n: CGFloat) -> CGFloat {
        return (self < n) ? n : self
    }
}

extension Float {
    var asDouble: Double {
        Double(self)
    }
}

extension Int {
    var asDouble: Double {
        Double(self)
    }
}

extension Double {
    var asInt: Int {
        Int(self)
    }
}
