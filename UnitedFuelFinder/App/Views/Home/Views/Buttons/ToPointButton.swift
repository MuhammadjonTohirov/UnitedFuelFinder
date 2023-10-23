//
//  ToPointButton.swift
//  UnitedFuelFinder
//
//  Created by applebro on 19/10/23.
//

import Foundation
import SwiftUI

struct ToPointButton: View {
    var text: String
    var isLoading: Bool
    var onClickMap: () -> Void
    var onClickBody: () -> Void
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 8)
                .frame(height: 40)
                .foregroundStyle(Color.secondaryBackground)
                .overlay {
                    HStack {
                        Image("icon_pin_search")
                            .renderingMode(.template)
                            .foregroundStyle(Color.label)

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
                }
            
            Button(action: {onClickMap()}, label: {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 51, height: 40)
                    .foregroundStyle(Color.secondaryBackground)
                    .overlay {
                        Image(systemName: "map.fill")
                    }
                    
            })
        }
    }
}
