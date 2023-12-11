//
//  SettingsViewUtils.swift
//  UnitedFuelFinder
//
//  Created by applebro on 11/12/23.
//

import Foundation
import SwiftUI

struct SettingsViewUtils {
    static func row<IMG: View>(image: IMG, title: String, details: String = "", onClick: @escaping () -> Void) -> some View {
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
                
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.label)

                Spacer()
                
                Text(details)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.secondary)

                Image(systemName: "chevron.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 10, height: 10)
            }
        }
    }
}
