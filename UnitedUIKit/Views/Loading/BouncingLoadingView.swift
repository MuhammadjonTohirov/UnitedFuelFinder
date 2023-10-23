//
//  BouncingLoading.swift
//  UnitedUIKit
//
//  Created by applebro on 22/10/23.
//

import Foundation
import SwiftUI

public struct BouncingLoadingView: View {
    @State var animate: Bool = false
    @State var opacity: CGFloat = 1
    @State private var radiusPercentage: CGFloat = 0
    private var message: String = ""
    let circleRadius: CGFloat
    public init(animate: Bool = false, circleRadius: CGFloat = 60, opacity: CGFloat = 1, message: String = "") {
        self.animate = animate
        self.circleRadius = circleRadius
        self.opacity = opacity
        self.message = message
    }
    
    public var body: some View {
        ZStack {
            
            VStack {
                RadialGradient(gradient: Gradient(colors: [
                    Color.accentColor,
                    Color.accentColor.opacity(0.3)
                ]), center: .center, startRadius: 0, endRadius: circleRadius * 1.5)
                .frame(width: circleRadius * radiusPercentage , height: circleRadius * radiusPercentage)
                .opacity(opacity)
                .clipShape(Circle())
                .frame(width: circleRadius, height: circleRadius)
                
                Text(message)
                    .font(.system(size: 13))
                    .background {
                        Capsule()
                            .foregroundStyle(Color.background)
                            .blur(radius: 10)
                    }
            }
                
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.easeIn(duration: 1).repeatForever(autoreverses: false)) {
                radiusPercentage = 1
                opacity = 0
            }
        }
    }
}

#Preview {
    ZStack {
        Text("Text")
        
        BouncingLoadingView(message: "Loading")
    }
}
