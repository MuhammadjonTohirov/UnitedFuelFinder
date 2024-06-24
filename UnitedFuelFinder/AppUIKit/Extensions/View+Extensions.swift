//
//  VIew+Extension.swift
//  YuzPay
//
//  Created by applebro on 22/12/22.
//

import Foundation
import SwiftUI

public extension View {
    func toast(_ presenting: Binding<Bool>, _ alert: @autoclosure @escaping () -> AlertToast, duration: CGFloat = 0.5) -> some View {
        self.toast(isPresenting: presenting) {
            alert()
        }
        .onChange(of: presenting.wrappedValue) { newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    presenting.wrappedValue = false
                }
                
                SEffect.rigid()
            }
        }
    }
    
    func scrollable(
        axis: Axis.Set = .vertical,
        showIndicators: Bool = false,
        scrollable: Bool = true
    ) -> AnyView {
        if scrollable {
            return self
                .modifier(ScrollableModifier(axis: axis, indicators: showIndicators))
                .anyView
        }
        
        return self.anyView
    }
    
    func horizontal(alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vertical(alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func didAppear(action: @escaping () -> Void) -> some View {
        self.onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                action()
            }
        }
    }
    
    func set(isVisible: Bool) -> some View {
        if isVisible {
            return AnyView(self)
        }
        
        return AnyView(
            EmptyView().frame(width: 0, height: 0)
        )
    }
}

extension View {

    @ViewBuilder
    func stretchable(in geo: GeometryProxy) -> some View {
        let width = geo.size.width
        let height = geo.size.height
        let minY = geo.frame(in: .global).minY
        let useStandard = minY <= 0
        self.frame(width: width, height: height + (useStandard ? 0 : minY))
            .offset(y: useStandard ? 0 : -minY)
    }
    
    var anyView: AnyView {
        AnyView(self)
    }
}

extension View {
    @ViewBuilder func set(hasDismiss: Bool) -> some View {
        if hasDismiss {
            self.modifier(TopLeftDismissModifier())
        } else {
            self
        }
    }
}


private struct ViewRepresented<T: UIView>: UIViewRepresentable {
    private(set) var view: T

    init(_ view: T) {
        self.view = view
    }

    func makeUIView(context: Context) -> some UIView {
        view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
}

public extension UIView {
    var asSwiftUI: some View {
        ViewRepresented(self)
    }
}

extension Text {
    init(_ string: String, configure: ((inout AttributedString) -> Void)) {
        var attributedString = AttributedString(string)
        configure(&attributedString)
        self.init(attributedString)
    }
}

extension View {
    func border(_ color: Color, width: CGFloat = 1, cornerRadius: CGFloat) -> some View {
        self
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(color, lineWidth: width)
            )
    }
    
    func onClick(_ action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            self
        }
    }
}
