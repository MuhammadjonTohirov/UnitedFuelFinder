//
//  FromPointButton.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/10/23.
//

import Foundation
import SwiftUI

struct FromPointButton: View {
    let text: String
    let isLoading: Bool
    var onClickBody: () -> Void
    
    var body: some View {
        fromPointView
    }
    
    private var fromPointView: some View {
        HStack {
            leftView
            
            if isLoading {
                HStack {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .animation(nil, value: text)
            } else {
                Text(text)
                    .lineLimit(1)
                    .font(.system(size: 13))
                    .animation(nil, value: text)
            }
            
            Spacer()
        }
        .padding(.horizontal, 10)
        .frame(height: 40)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.secondaryBackground)
                .onTapGesture(perform: onClickBody)
        }
        .onTapGesture(perform: onClickBody)
    }
    
    private var leftView: some View {
        Circle()
            .frame(width: 19.f.sw(), height: 19.f.sw())
            .overlay {
                Text("A")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.white)
            }
    }
}

#Preview {
    FromPointButton(text: "", isLoading: false) {
        
    }
}

