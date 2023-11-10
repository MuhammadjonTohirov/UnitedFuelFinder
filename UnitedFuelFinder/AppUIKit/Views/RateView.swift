//
//  RateView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/11/23.
//

import Foundation
import SwiftUI

public struct RateView: View {
    public var starsCount: Int = 5
    @State public var rate: Int = 2
    public var canRate: Bool = true
    
    var onChangeRate: ((Int) -> Void)?
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<starsCount, id: \.self) { i in
                Image(rate > i ? "icon_star_fill" : "icon_star_empty")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture {
                        if canRate {
                            rate = i + 1
                            SEffect.rigid()
                            onChangeRate?(rate)
                        }
                    }
            }
        }
    }
    
    func set(onRateChange: @escaping (Int) -> Void) -> Self {
        var v = self
        v.onChangeRate = onRateChange
        return v
    }
}

#Preview {
    RateView(starsCount: 5, rate: 3)
        .frame(height: 20)
}
