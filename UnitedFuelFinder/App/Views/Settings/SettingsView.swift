//
//  SettingsView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 16/10/23.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(spacing: 12) {
            row(image: Image("icon_edit")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.bottom, 2)
                .padding(.leading, 2), title: "Edit profile"
            )
            Divider()
            row(image: Image("icon_feedback")
                .resizable()
                .frame(width: 24, height: 24),
                title: "Edit profile"
            )
            
            Divider()
            
            row(image: Image("icon_lang")
                .resizable()
                .frame(width: 24, height: 24),
                title: "Language", details: "English"
            )
            
            Divider()
            
            row(image: Image("icon_contact")
                .resizable()
                .frame(width: 24, height: 24),
                title: "Contact"
            )
            
            Divider()
            
            row(image: Image("icon_logout")
                .resizable()
                .frame(width: 22, height: 22).padding(.leading, -2),
                title: "Contact"
            )
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    func row<IMG: View>(image: IMG, title: String, details: String = "") -> some View {
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


#Preview {
    SettingsView()
}
