//
//  ContactUsView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 16/10/23.
//

import Foundation
import SwiftUI

struct ContactUsView: View {
    var body: some View {
        VStack(spacing: 12) {
            row(image: Image("icon_contact")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.bottom, 2)
                .padding(.leading, 2), title: "UFC Client Service", details: "+1(888) 502 3442"
            )
            Divider()
            row(image: Image("icon_contact")
                .resizable()
                .frame(width: 24, height: 24),
                title: "Help Desk", details: "+1(888) 502 3442"
            )
            Divider()
            row(image: Image("icon_email")
                .resizable()
                .frame(width: 24, height: 24),
                title: "Email", details: "info@unitedtransportllc.org"
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
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 11, weight: .regular))
                    .foregroundStyle(Color.secondary)
                
                Text(details)
                    .font(.system(size: 12, weight: .regular))
            }
            
            Spacer()
        }
    }
}

#Preview {
    ContactUsView()
}
