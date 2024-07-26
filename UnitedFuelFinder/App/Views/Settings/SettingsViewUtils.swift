//
//  SettingsViewUtils.swift
//  UnitedFuelFinder
//
//  Created by applebro on 11/12/23.
//

import Foundation
import SwiftUI

struct SettingsViewUtils {
    static func row<IMG: View>(image: IMG, title: String, details: String = "", descr: String = "", onClick: @escaping () -> Void) -> some View {
        Button {
            onClick()
        } label: {
            HStack {
                Circle()
                    .frame(width: 32, height: 32, alignment: .center)
                    .foregroundStyle(Color.secondaryBackground)
                    .overlay {
                        image
                    }
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.lato(size: 14, weight: .medium))
                        .foregroundStyle(Color.label)
                    
                    if !descr.isEmpty {
                        Text(descr)
                            .font(.lato(size: 12, weight: .regular))
                            .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                            .multilineTextAlignment(.leading)
                    }
                }

                Spacer()
                
                Text(details)
                    .font(.lato(size: 12, weight: .regular))
                    .foregroundStyle(Color.secondary)

                Icon(systemName: "chevron.right")
                    .size(.init(width: 14, height: 14))
                    .aspectRatio(.fit)
            }
        }
    }
}
