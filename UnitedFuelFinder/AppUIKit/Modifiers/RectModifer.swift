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
//                        .preference(
//                            key: SizePreferenceKey.self,
//                            value: proxy.frame(in: .global)
//                        )
                        .onAppear {
                            if rect == .zero {
                                rect = proxy.frame(in: .global)
                            }
                        }
                }
            )
            .onPreferenceChange(SizePreferenceKey.self) { preferences in
                if rect == .zero {
                    Logging.l(
                        tag: "RectModifier",
                        "On change preferneces \(preferences)"
                    )
                    rect = preferences
                }
            }
    }
}

//SizePreferenceKey

struct SizePreferenceKey: PreferenceKey {
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

