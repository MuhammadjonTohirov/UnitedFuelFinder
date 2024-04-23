//
//  RichAlertView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 22/01/24.
//

import Foundation
import SwiftUI

enum RichAlertType {
    case success
    case failure
    case custom(image: AnyView)
    
    @ViewBuilder
    var image: some View {
        switch self {
        case .success:
            Image(systemName: "checkmark.seal.fill")
                .resizable()
                .frame(width: 56, height: 56, alignment: .center)
                .foregroundStyle(Color.green)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .frame(width: 56, height: 56, alignment: .center)
                .foregroundStyle(Color.red)
        case .custom(let image):
            image
        }
    }
}

struct RichAlertView: View {
    var type: RichAlertType
    var title: String
    var message: AnyView?
    
    @Binding var presented: Bool
    var onDismiss: () -> Void
    @State private var bodySize: CGRect = .zero
    @State private var alertSize: CGRect = .zero
    
    @State private var offset: CGFloat = 0
    @State private var opacity: CGFloat = 0
    
    var body: some View {
        Rectangle()
            .readRect(rect: $bodySize)
            .foregroundStyle(Color.black.opacity(0.05))
            .overlay {
                VStack(spacing: 24) {
                    type.image
                    
                    Text(title)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    
                    if let message = message {
                        message
                            .multilineTextAlignment(.center)
                    }
                    
                    SubmitButton {
                        presented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.21) {
                            onDismiss()
                        }
                    } label: {
                        Text("ok".localize)
                    }
                }
                .padding([.horizontal, .bottom], 20)
                .padding([.top], 24)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(Color.background)
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 0)
                }
                .padding()
                .readRect(rect: $alertSize)
                .onChange(of: alertSize, perform: { value in
                    print("alert size", value)
                    
                    offset = bodySize.height / 2 + alertSize.height / 2
                    
                    if presented {
                        show()
                    }
                })
                .onChange(of: bodySize, perform: { value in
                    print("body size", value)
                })
                .offset(y: offset)
            }
            .onChange(of: presented, perform: { value in
                presented ? show() : hide()
            })
            .opacity(opacity)
    }
    
    private func show() {
        withAnimation {
            offset = bodySize.height / 2 - alertSize.height / 2
            opacity = 1
        }
    }
    
    private func hide() {
        withAnimation {
            offset = bodySize.height / 2 + alertSize.height / 2
            opacity = 0
        }
    }
}

struct RichAlertViewModifier: ViewModifier {
    var type: RichAlertType
    var title: String
    var message: AnyView?
    
    @Binding
    var isPresented: Bool
    var onDismiss: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
            RichAlertView(
                type: type,
                title: title,
                message: message,
                presented: $isPresented,
                onDismiss: onDismiss
            )
            .ignoresSafeArea()
            .allowsHitTesting(isPresented)
        }
    }
}





struct UpdateAlerView: View {
    var type: RichAlertType
    var title: String
    var message: AnyView?
    var btnTitle: String
    
    @Binding var presented: Bool
    var onDismiss: () -> Void
    @State private var bodySize: CGRect = .zero
    @State private var alertSize: CGRect = .zero
    
    @State private var offset: CGFloat = 0
    @State private var opacity: CGFloat = 0
    
    var body: some View {
        Rectangle()
            .readRect(rect: $bodySize)
            .foregroundStyle(Color.black.opacity(0.05))
            .overlay {
                VStack(spacing: 24) {
                    type.image
                    
                    Text(title)
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    
                    if let message = message {
                        message
                            .multilineTextAlignment(.center)
                    }
                    
                    SubmitButton {
                        presented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.21) {
                            onDismiss()
                        }
                    } label: {
                        Text(btnTitle)
                        //Text("Update".localize)
                    }
                }
                .padding([.horizontal, .bottom], 20)
                .padding([.top], 24)
                .background {
                    RoundedRectangle(cornerRadius: 16)
                        .foregroundStyle(Color.background)
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 0)
                }
                .padding()
                .readRect(rect: $alertSize)
                .onChange(of: alertSize, perform: { value in
                    print("alert size", value)
                    
                    offset = bodySize.height / 2 + alertSize.height / 2
                    
                    if presented {
                        show()
                    }
                })
                .onChange(of: bodySize, perform: { value in
                    print("body size", value)
                })
                .offset(y: offset)
            }
            .onChange(of: presented, perform: { value in
                presented ? show() : hide()
            })
            .opacity(opacity)
    }
    
    private func show() {
        withAnimation {
            offset = bodySize.height / 2 - alertSize.height / 2
            opacity = 1
        }
    }
    
    private func hide() {
        withAnimation {
            offset = bodySize.height / 2 + alertSize.height / 2
            opacity = 0
        }
    }
}

struct UpdateAlerViewModifier: ViewModifier {
    var type: RichAlertType
    var title: String
    var message: AnyView?
    var btnTitle: String?
    @Binding
    var isPresented: Bool
    var onDismiss: () -> Void
    
    func body(content: Content) -> some View {
        ZStack {
            content
            UpdateAlerView(
                type: type,
                title: title,
                message: message, btnTitle: btnTitle ?? "OK",
                presented: $isPresented,
                onDismiss: onDismiss
            )
            .ignoresSafeArea()
            .allowsHitTesting(isPresented)
        }
    }
}
extension View {
    func richAlert(
        type: RichAlertType,
        title: String,
        message: String? = nil,
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> Void
    ) -> some View {
        self.modifier(
            RichAlertViewModifier(
                type: type,
                title: title,
                message: message != nil ? Text(message!).font(.system(size: 14, weight: .medium, design: .rounded)).anyView : nil,
                isPresented: isPresented.animation(.easeInOut(duration: 0.2)),
                onDismiss: onDismiss
            )
        )
    }
    
    func richAlert(
        type: RichAlertType,
        title: String,
        message: AnyView,
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> Void
    ) -> some View {
        self.modifier(
            RichAlertViewModifier(
                type: type,
                title: title,
                message: message,
                isPresented: isPresented.animation(.easeInOut(duration: 0.2)),
                onDismiss: onDismiss
            )
        )
    }
    func warningAlert(
        type: RichAlertType,
        title: String,
        message: AnyView,
        btnTitle:String?,
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> Void
    ) -> some View {
        self.modifier(
            UpdateAlerViewModifier(
                type: type,
                title: title,
                message: message,
                btnTitle: btnTitle,
                isPresented: isPresented.animation(.easeInOut(duration: 0.2)),
                onDismiss: onDismiss
            )
        )
    }
}
