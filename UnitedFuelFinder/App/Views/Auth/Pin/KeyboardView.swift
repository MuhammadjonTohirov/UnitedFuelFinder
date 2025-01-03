//
//  KeyboardView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 09/10/23.
//

import Foundation
import SwiftUI


struct KeyboardView: View {
    let keyboardHeight: CGFloat = 288.f.sh(limit: 0.2)
    @Binding var text: String
    @ObservedObject var viewModel: KeyboardViewModel
    var onClickLeftBottom: (() -> Void)
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                keyboard(proxy)
                keyboardDividers(proxy)
                    .foregroundColor(.init(uiColor: .secondaryLabel).opacity(0.2))
            }
        }
        .frame(height: keyboardHeight)
    }
    
    @ViewBuilder func keyboardDividers(_ proxy: GeometryProxy) -> some View {
        Rectangle()
            .frame(width: 1, height: keyboardHeight)
            .position(
                x: proxy.frame(in: .local).width / 3,
                y: proxy.frame(in: .local).height / 2
            )
        
        Rectangle()
            .frame(width: 1, height: keyboardHeight)
            .position(
                x: 2 * proxy.frame(in: .local).width / 3,
                y: keyboardHeight / 2
            )

        Rectangle()
            .frame(width: proxy.frame(in: .local).width, height: 1)
            .position(
                x: proxy.frame(in: .local).width / 2,
                y: keyboardHeight / 4
            )
        
        Rectangle()
            .frame(width: proxy.frame(in: .local).width, height: 1)
            .position(
                x: proxy.frame(in: .local).width / 2,
                y: 2 * keyboardHeight / 4
            )
        
        Rectangle()
            .frame(width: proxy.frame(in: .local).width, height: 1)
            .position(
                x: proxy.frame(in: .local).width / 2,
                y: 3 * keyboardHeight / 4
            )
    }
    
    func keyboard(_ proxy: GeometryProxy) -> some View {
        LazyVGrid(columns: [
            GridItem(),
            GridItem(),
            GridItem()
        ], spacing: 48.f.sh(limit: 0.2)) {
            keyboardFirstRow
            keyboardSecondRow
            keyboardThirdRow
            keyItem(.clear(text: viewModel.type.text))
            keyItem(.zero)
            keyItem(.backSpace)
        }
        
        .font(.system(size: 24, weight: .medium))
    }
    
    @ViewBuilder var keyboardFirstRow: some View {
        keyItem(.one)
        keyItem(.two)
        keyItem(.three)
    }
    
    @ViewBuilder var keyboardSecondRow: some View {
        keyItem(.four)
        keyItem(.five)
        keyItem(.six)
    }
    
    @ViewBuilder var keyboardThirdRow: some View {
        keyItem(.seven)
        keyItem(.eight)
        keyItem(.nine)
    }
    
    func keyItem(_ val: Key) -> some View {
        Button {
            SEffect.rigid()
            switch val {
            case .clear:
                text = ""
                onClickLeftBottom()
            case .backSpace:
                _ = text.popLast()
            default:
                if viewModel.maxCharacters <= 0 {
                    text.append("\(val.id)")
                    return
                }
                
                if text.count < viewModel.maxCharacters {
                    text.append("\(val.id)")
                    return
                }
            }
        } label: {
            val.view
                .frame(width: 92.f.sh(limit: 0.2), height: 24.f.sh(limit: 0.2))
                .foregroundColor(.label)
        }
    }
}
