//
//  Array+Extensions.swift
//  YuzSDK
//
//  Created by applebro on 28/04/23.
//

import Foundation
import SwiftUI

public extension Array {
    func item(at: Int) -> Element? {
        if self.count > at && at >= 0 {
            return self[at]
        }
        
        return nil
    }
    
    var nilIfEmpty: [Element]? {
        self.isEmpty ? nil : self
    }
    
    var nilOrEmpty: Bool {
        nilIfEmpty == nil
    }
    
    mutating func replace(item: Element, with newItem: Element) where Element: Hashable {
        if let index = self.firstIndex(of: item) {
            replace(itemAt: index, with: newItem)
        }
    }
    
    mutating func replace(itemAt index: Int, with newItem: Element) {
        self.remove(at: index)
        self.insert(newItem, at: index)
    }
}

extension Array: NetResBody where Element: Codable {
    func mapTo<T>(_ type: T.Type) -> [T] where T: Codable {
        do {
            let data = try JSONEncoder().encode(self)
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print(error)
            return []
        }
    }
    
    func mapTo<T>(_ type: T.Type) -> T where T: Codable {
        do {
            let data = try JSONEncoder().encode(self)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(error)
            return self as! T
        }
    }
}

extension Array where Element: View {
    func vstack(alignment: HorizontalAlignment = .center, spacing: CGFloat = 4) -> some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(self.indices, id: \.self) { index in
                self[index]
            }
        }
    }
}

extension Array where Element == AnyView {
    func vstack(alignment: HorizontalAlignment = .center, spacing: CGFloat = 4) -> some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(self.indices, id: \.self) { index in
                self[index]
            }
        }
    }
}
