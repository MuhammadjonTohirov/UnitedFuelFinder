//
//  WarningAlertView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 04/03/24.
//

import Foundation
import SwiftUI

// I need 4 label title desc, title desc and one confirm button. if click dismiss view

struct WarningAlertView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            smallBody(title: "disclamer.title".localize, desc: "disclamer.desc".localize)
            
            Button(action: {
                dismiss.callAsFunction()
            }, label: {
                Text("ok".localize)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.init(uiColor: .systemBlue))
                    .cornerRadius(8)
            })
        }
        .padding(24)
        .background(Color.init(uiColor: .systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.init(uiColor: .black).opacity(0.2), radius: 8, x: 0, y: 4)
    }
    
    
    private func smallBody(title: String, desc: String) -> some View {
        VStack {
            Text(title)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(Color.init(uiColor: .label))
                .padding(.bottom, 8)
            
            Text(desc)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color.init(uiColor: .label))
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)
        }
    }
}
