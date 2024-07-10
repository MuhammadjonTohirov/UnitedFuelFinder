//
//  ReadSizeModifer.swift
//  UnitedUIKit
//
//  Created by applebro on 08/10/23.
//

import SwiftUI

// Read Size Modifier

struct RectModifer: ViewModifier {
    @Binding var rect: CGRect
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: RectPreferenceKey.self, value: proxy.frame(in: .global))
                        .onAppear {
//                            if rect == .zero {
//                                rect = proxy.frame(in: .global)
//                            }
                            rect = proxy.frame(in: .global)
                        }
                }
            )
            .onPreferenceChange(RectPreferenceKey.self) { preferences in
                rect = preferences
            }
    }
}

//SizePreferenceKey

struct RectPreferenceKey: PreferenceKey {
    typealias Value = CGRect
    
    static var defaultValue: Value = .zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = nextValue()
    }
}

public extension View {
    func readRect(rect: Binding<CGRect>) -> some View {
        self.modifier(RectModifer(rect: rect))
    }
}

struct SizePreferenceKey: PreferenceKey {
    typealias Value = CGSize

    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct SizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear.preference(key: SizePreferenceKey.self, value: geometry.size)
                }
            )
    }
}

extension View {
    func onSizeChange(_ onChange: @escaping (CGSize) -> Void) -> some View {
        self.modifier(SizeModifier())
            .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}
