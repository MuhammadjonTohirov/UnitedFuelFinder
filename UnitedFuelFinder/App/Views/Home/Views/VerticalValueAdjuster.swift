//
//  VerticalValueAdjuster.swift
//  UnitedFuelFinder
//
//  Created by applebro on 14/11/23.
//

import Foundation
import SwiftUI

struct VerticalValueAdjuster: View {
    @State private var bodyRect: CGRect = .zero
    @State private var rect: CGRect = .zero
    @State private var barRect: CGRect = .zero
    @State private var indicatorHeight: CGFloat = 80
    
    @State private var latestIndicatorHeight: CGFloat = 80
    @State private var isDragging = false
    @State private var bodyWidth: CGFloat = 8
    
    var maxValue: CGFloat = 100
    @Binding var currentValue: CGFloat
    var bodyHeight: CGFloat = 128
    
    var onEnd: ((_ value: Double, _ percentage: Double) -> Void)
    
    private var calculatedBarHeight: CGFloat {
        rect.height * (currentValue / maxValue)
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                .frame(width: bodyWidth, height: bodyHeight)
                .readRect(rect: $rect)
                .position(x: bodyRect.width / 2, y: rect.height / 2)
                .transaction { transaction in
                    transaction.animation = .bouncy
                }

            RoundedRectangle(cornerRadius: 6)
                .frame(width: bodyWidth, height: indicatorHeight)
                .foregroundStyle(Color.init(uiColor: .secondarySystemBackground))
                .readRect(rect: $barRect)
                .position(
                    x: bodyRect.width / 2,
                    y: rect.height / 2 + (rect.height - indicatorHeight) / 2
                )
                .transaction { transaction in
                    transaction.animation = .bouncy
                }
                .shadow(color: Color.black.opacity(0.4), radius: 4)
            
            Text("\(Int(currentValue)) mi")
                .position(.init(x: bodyRect.width / 2, y: -16))
                .opacity(isDragging ? 1 : 0)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                .shadow(color: Color.black.opacity(0.7), radius: 10)
        }
        .onChange(of: indicatorHeight, perform: { value in
            let p = value / rect.height
            currentValue = p * maxValue
        })
        .frame(width: 48, height: bodyHeight)
        .background {
            Rectangle()
                .readRect(rect: $bodyRect)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onChanged { value in
                            let calculatedValue = (latestIndicatorHeight - value.translation.height).limitTop(rect.height).limitBottom(rect.height * 0.1)
                            
                            if Int(calculatedValue) != Int(indicatorHeight) {
                                indicatorHeight = calculatedValue
                            }
                        }.onEnded({ value in
                            onEndDragging()
                        })
                        .onChanged({ valueChanged in
                            if abs(valueChanged.velocity.height) > 0 {
                                onStartDragging()
                            }
                        })
                )
                .foregroundStyle(Color.background.opacity(0.01))
        }
        .onAppear {
            self.indicatorHeight = calculatedBarHeight
            self.latestIndicatorHeight = calculatedBarHeight
        }
    }
    
    private func onStartDragging() {
        withAnimation(.linear(duration: 0.2)) {
            isDragging = true
            bodyWidth = 32
        }
    }
    
    private func onEndDragging() {
        latestIndicatorHeight = indicatorHeight
        self.onEnd(currentValue, currentValue / maxValue)
        withAnimation(.linear(duration: 0.2)) {
            isDragging = false
            bodyWidth = 8
        }
    }
}

#Preview {
    @State var val: CGFloat = 25
    return VerticalValueAdjuster(maxValue: 150, currentValue: $val) { a, b in
        
    }
}
