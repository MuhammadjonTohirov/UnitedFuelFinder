//
//  IntroView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 15/05/24.
//

import Foundation
import SwiftUI

struct IntroView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .foregroundStyle(.accent)
            
            VStack {
                Image("image_united_ff")
                    .padding(.top, Padding.medium)
                
                Spacer()
            }
            
            Text("""
            Explore
            Fuel on
            Your way
            """)
            .font(.system(size: 50, weight: .black))
        }
    }
}

#Preview {
    IntroView()
}
