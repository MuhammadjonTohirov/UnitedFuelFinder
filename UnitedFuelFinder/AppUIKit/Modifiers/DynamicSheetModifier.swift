//
//  DynamicHeight.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/06/24.
//

import Foundation
import SwiftUI

extension View {
    func readHeight() -> some View {
        self
            .modifier(ReadHeightModifier())
    }
    
    func dynamicSheet() -> some View {
        self
            .modifier(DynamicHeightModifier())
    }
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat?

    static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
        guard let nextValue = nextValue() else { return }
        value = nextValue
    }
}

private struct DynamicHeightModifier: ViewModifier {
    @State private var detentHeight: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .readHeight()
            .onPreferenceChange(HeightPreferenceKey.self, perform: { value in
                if let value {
                    self.detentHeight = value
                }
            })
            .presentationDetents([.height(detentHeight), .large])
    }
}

private struct ReadHeightModifier: ViewModifier {
    private var sizeView: some View {
        GeometryReader { geometry in
            Color.clear.preference(key: HeightPreferenceKey.self, value: geometry.size.height)
        }
    }

    func body(content: Content) -> some View {
        content.background(sizeView)
    }
}

