//
//  String+Extensions.swift
//  YuzSDK
//
//  Created by applebro on 28/04/23.
//

import Foundation
import UIKit

extension String: NetResBody {
    
}


public extension Encodable {
    /// Turns json into a Dictionary
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
    
    /// Turn json into a string
    var asString: String {
        guard let jsonData = try? JSONEncoder().encode(self) else {
            return ""
        }
        
        return String(data: jsonData, encoding: .utf8) ?? ""
    }
    
    func toJSONString(_ encoder: JSONEncoder = JSONEncoder()) throws -> NSString {
        let data = try encoder.encode(self)
        let result = String(decoding: data, as: UTF8.self)
        return NSString(string: result)
    }
    
    var asData: Data? {
        try? JSONEncoder().encode(self)
    }
}

public extension Substring {
    var asString: String {
        String(self)
    }
}

public extension String {
    
    var asInt: Int {
        Int(self) ?? 0
    }
    
    var isInt: Bool {
        Int(self) != nil
    }
    
    var numberFormatted: String {
        var str = self.replacingOccurrences(of: ",", with: ".")
        
        if str.last == "." && str.count > 1 {
            let newString = str.dropLast()
            return String(newString).numberFormatted
        }
        
        let hasMultipleDots = str.filter { $0 == "." }.count > 1
        
        if hasMultipleDots {
            let lastDotIndex = str.lastIndex(of: ".") ?? str.startIndex
            str = String(str.prefix(upTo: lastDotIndex))
        }
        
        return str
    }
    
    func localize(language: Language) -> String {
        let path = Bundle.main.path(forResource: language.code, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: self, comment: self)
    }
    
    var localize: String {
        return localize(language: UserSettings.shared.language ?? .russian)
    }

    func localize(arguments: CVarArg...) -> String {
        String.init(format: self.localize, arguments: arguments)
    }
    
//    attributed string localize
    func localize(attributes: [NSAttributedString.Key: Any]) -> AttributedString {
        return AttributedString(NSAttributedString(string: self, attributes: attributes))
    }
    
    func highlight(text: String, color: UIColor) -> NSAttributedString {
        guard let range = self.range(of: text) else {
            return NSAttributedString(string: self)
        }
        
        let _range = NSRange(range, in: self)
        
        let attr = NSMutableAttributedString(string: self)
        attr.addAttribute(.foregroundColor, value: color, range: _range)
        return attr
    }
    
    func onlyNumberFormat(with mask: String) -> String {
        let text = self
        let numbers = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        return numbers.format(with: mask)
    }
    
    func format(with mask: String) -> String {
        let text = self
        
        var result = ""
        var index = text.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < text.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(text[index])

                // move numbers iterator to the next index
                index = text.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    var maskAsCardNumber: String {
        var text = self.replacingOccurrences(of: " ", with: "")
        if text.count < 16 {
            return ""
        }

        let replace = "••••••••"
        let range: Range<Index> = self.index(self.startIndex, offsetBy: 4)..<self.index(self.startIndex, offsetBy: 4 + replace.count)

        text = text.replacingCharacters(in: range, with: replace)
        
        return text.format(with: "XXXX XXXX XXXX XXXX")
    }
    
    /// •••• xxxx
    var maskAsMiniCardNumber: String {
        var text = self.replacingOccurrences(of: " ", with: "")
        if text.count < 9 {
            return ""
        }
        text.removeFirst(text.count - 8)
        let replace = "••••"
        let range: Range<Index> = self.index(self.startIndex, offsetBy: 0)..<self.index(self.startIndex, offsetBy: replace.count)

        text = text.replacingCharacters(in: range, with: replace)
        
        return text.format(with: "XXXX XXXX")
    }
    
    var nilIfEmpty: String? {
        return self.isEmpty ? nil : self
    }
    
    var isNilOrEmpty: Bool {
        return self.nilIfEmpty == nil
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }
}

extension Bool: NetResBody {
    
}

public extension NSAttributedString {
    var toSwiftUI: AttributedString {
        AttributedString(self)
    }
}

// format: 1992.12.20
public typealias ServerVersion = String

extension ServerVersion {
    
    func isNewVersion(_ version: ServerVersion) -> Bool {
        let current = self
        let new = version
        
        let currentComponents = current.components(separatedBy: ".")
        let newComponents = new.components(separatedBy: ".")
        
        guard currentComponents.count == newComponents.count else {
            return false
        }
        
        for i in 0..<currentComponents.count {
            let currentComponent = currentComponents[i]
            let newComponent = newComponents[i]
            
            guard let current = Int(currentComponent), let new = Int(newComponent) else {
                return false
            }
            
            if current < new {
                return true
            }
        }
        
        return false
    }
}
