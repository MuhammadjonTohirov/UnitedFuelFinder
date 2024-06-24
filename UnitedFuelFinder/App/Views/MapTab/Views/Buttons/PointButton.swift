//
//  ToPointButton.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/10/23.
//

import Foundation
import SwiftUI

struct PointButton: View {
    var text: String
    var isLoading: Bool
    var label: String = "B"
    var labelColor: Color = .label
    var onClickMap: (() -> Void)? = nil
    var onClickBody: () -> Void
    
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 50)
                .foregroundStyle(Color.secondaryBackground)
                .onTapGesture(perform: onClickBody)
                .overlay {
                    HStack {
                        leftView
                        
                        if isLoading {
                            HStack {
                                ProgressView()
                            }
                            .frame(maxWidth: .infinity)
                        } else {
                            Text(text)
                                .lineLimit(1)
                                .font(.system(size: 13))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 10)
                }
                .onTapGesture(perform: onClickBody)
            
            if let onClickMap {
                Button(action: {onClickMap()}, label: {
                    RoundedRectangle(cornerRadius: 8)
                        .frame(width: 50, height: 50)
                        .foregroundStyle(Color.appIcon)
                        .overlay {
                            Image(systemName: "map.fill")
                                .renderingMode(.template)
                                .foregroundStyle(Color.background)
                        }
                        
                })
            }
        }
    }
    
    private var leftView: some View {
        Circle()
            .foregroundStyle(labelColor)
            .frame(width: 19.f.sw(), height: 19.f.sw())
            .overlay {
                Text(label)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.background)
            }
    }
}

#Preview {
    PointButton(text: "", isLoading: false, label: "C") {
        
    } onClickBody: {
        
    }
}
