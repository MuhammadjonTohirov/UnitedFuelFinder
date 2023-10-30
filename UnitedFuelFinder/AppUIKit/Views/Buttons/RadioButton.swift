//
//  RadioButton.swift
//  UnitedUIKit
//
//  Created by applebro on 08/10/23.
//

import SwiftUI

public struct RadioButton<Content: View>: View {
    public var isSelected: Bool
    public var title: () -> Content
    public var action: () -> Void
    @State private var contentRect: CGRect = .zero
    @State private var titleRect: CGRect = .zero
    
    public init(isSelected: Bool, title: @escaping () -> Content, action: @escaping () -> Void) {
        self.isSelected = isSelected
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: action, label: {
            innerBody
        })
    }
    
    var innerBody: some View {
        ZStack {
            Circle()
                .frame(width: 8, height: 8)
                .foregroundStyle(Color.accentColor)
                .opacity(isSelected ? 1 : 0)
                .position(x: titleRect.minX - 16, y: (titleRect.height + 4) / 2)
                
            title()
                .font(.system(size: 16, weight: .semibold))
                .background(content: {
                    GeometryReader(content: { geometry in
                        Rectangle()
                            .foregroundStyle(Color.clear)
                            .onAppear(perform: {
                                titleRect = geometry.frame(in: .global)
                            })
                    })
                })
        }
        .frame(height: titleRect.height)
        .background {
            GeometryReader(content: { geometry in
                Rectangle()
                    .foregroundStyle(Color.clear)
                    .onAppear {
                        contentRect = geometry.frame(in: .global)
                    }
            })
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        RadioButton(isSelected: true, title: {
            Text("English")
                .foregroundStyle(Color.label)
        }, action: {
            
        })
        
        RadioButton(isSelected: true, title: {
            Text("O'zbekcha")
                .foregroundStyle(Color.label)
        }, action: {
            
        })
        
        RadioButton(isSelected: true, title: {
            Text("Русский")
                .foregroundStyle(Color.label)
        }, action: {
            
        })
    }
}