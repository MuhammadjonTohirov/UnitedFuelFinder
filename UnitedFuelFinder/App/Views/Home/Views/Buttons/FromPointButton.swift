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
    
    var fromPointView: some View {
        HStack {
            Image("icon_point_circle")
                .renderingMode(.template)
                .foregroundStyle(Color.label)

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
            Divider()
                .padding(6)
            Circle()
                .frame(width: 32, height: 32, alignment: .center)
                .foregroundStyle(Color.clear)
                .overlay {
                    Image(systemName: "arrow.forward")
                }.onTapGesture(perform: onClickBody)
        }
        .padding(.horizontal, 10)
        .frame(height: 40)
        .background {
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.secondaryBackground)
        }
    }
}

