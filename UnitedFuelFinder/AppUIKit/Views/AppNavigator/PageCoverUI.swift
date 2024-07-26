//
//  PageCoverUI.swift
//  UnitedFuelFinder
//
//  Created by applebro on 27/12/23.
//

import Foundation
import SwiftUI

struct PageCoverUI<Content: View>: View {
    var content: () -> Content
    var onShow: () -> Void
    var onClose: () -> Void

    @State private var leading: CGFloat = 0
    
    var body: some View {
        Rectangle()
            .ignoresSafeArea()
            .foregroundStyle(Color.background)
            .shadow(color: .black.opacity(0.15), radius: 8, x: -10, y: 0)
            .overlay {
                NavigationView(content: {
                    content()
                        .toolbar(content: {
                            ToolbarItem(placement: .topBarLeading) {
                                Button(action: {
                                    closePage()
                                }, label: {
                                    Icon(systemName: "chevron.left")
                                        .font(.lato(size: 18, weight: .medium))
                                        .foregroundColor(.label)
                                })
                            }
                        })
                })
            }
            .offset(x: leading)
            .gesture(
                DragGesture(minimumDistance: 1, coordinateSpace: .global)
                    .onChanged({ drag in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            leading = (drag.translation.width).limitBottom(0)
                        }
                    })
                    .onEnded({ drag in
                        if drag.predictedEndTranslation.width <= 150 {
                            showPage()
                        } else {
                            closePage()
                        }
                    })
            )
            .transition(.move(edge: .trailing))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.onShow()
                }
            }
    }
    
    private func closePage() {
        withAnimation(.easeInOut(duration: 0.2)) {
            leading = UIApplication.shared.screenFrame.width
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.onClose()
            }
        }
    }
    
    private func showPage() {
        withAnimation(.easeInOut(duration: 0.2)) {
            leading = 0
        }
    }
}

private struct NavigatorModifier<D, C>: ViewModifier where D : Hashable, C : View {
    @Binding var item: D?
    @State private var validItem: D?
    var bodyContent: (D?) -> C?
    
    func body(content: Content) -> some View {
        ZStack {
            content

            if let validItem {
                PageCoverUI(content: {
                    bodyContent(validItem)
                }, onShow: {
                    
                }, onClose: {
                    self.item = nil
                })
            }
        }
        .onChange(of: item, perform: { value in
            withAnimation(.easeInOut(duration: 0.2)) {
                self.validItem = value
            }
        })
    }
}

private struct BoolNavigatorModifier<C>: ViewModifier where C : View {
    @Binding var item: Bool
    
    @State private var show: Bool = false
    
    var bodyContent: (Bool) -> C?
    
    func body(content: Content) -> some View {
        ZStack {
            content

            if show {
                PageCoverUI(content: {
                    bodyContent(show)
                }, onShow: {
                    
                }, onClose: {
                    item = false
                })
            }
        }
        .onChange(of: item, perform: { value in
            withAnimation(.easeInOut(duration: 0.2)) {
                self.show = value
            }
        })
    }
}

extension View {
    func navigate<D, C>(item: Binding<D?>, @ViewBuilder destination: @escaping (D) -> C) -> some View where D : Hashable, C : View {
        modifier(
            NavigatorModifier(item: item, bodyContent: { itm in
                if let itm {
                    return destination(itm)
                }
                
                return nil
            })
        )
    }
    
    func navigate<V>(isPresented: Binding<Bool>, @ViewBuilder destination: @escaping () -> V) -> some View where V : View {
        modifier(
            BoolNavigatorModifier(item: isPresented, bodyContent: { itm in
                if itm {
                    return destination()
                }
                
                return nil
            })
        )
    }
}
