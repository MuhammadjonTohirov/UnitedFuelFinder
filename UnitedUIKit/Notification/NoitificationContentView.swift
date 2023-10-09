//
//  NoitificationContentView.swift
//  UnitedUIKit
//
//  Created by applebro on 08/10/23.
//

import Foundation
import SwiftUI
import USDK

struct NotificationContentView<Content: View>: View {
    var content: Content
    var timeout: CGFloat
    var swipeToClose: Bool
    var tag: Int
    var hasDynamicIsland = false
    
    @State private var transitionAnimation: Bool = false
    
    var body: some View {
        content
            .blur(radius: transitionAnimation ? 0 : 10)
            .disabled(!transitionAnimation)
            .mask {
                if hasDynamicIsland {
                    RoundedRectangle(cornerRadius: 50, style: .continuous)
                } else {
                    Rectangle()
                }
            }
            .gesture(
                DragGesture().onEnded({ value in
                    if -value.translation.height > 50 && swipeToClose {
                        if #available(iOS 17.0, *) {
                            withAnimation(.smooth(duration: 0.3), completionCriteria: .logicallyComplete) {
                                transitionAnimation = false
                            } completion: {
                                removeNotificationView()
                            }
                        } else {
                            withAnimation(.smooth(duration: 0.3)) {
                                transitionAnimation = false
                            }
                            
                            removeNotificationView()
                        }
                    }
                })
            )
            .offset(y: offsetY)
            .scaleEffect(hasDynamicIsland ? (transitionAnimation ? 1 : 0.001) : 1, anchor: .init(x: 0.5, y: 0.01))
            .onAppear(perform: {
                Task {
                    guard !transitionAnimation else {
                        return
                    }
                    
                    withAnimation(.smooth(duration: 0.3)) {
                        transitionAnimation = true
                    }
                    
                    try await Task.sleep(for: .seconds(timeout < 1 ? 1 : timeout))
                    
                    if #available(iOS 17.0, *) {
                        withAnimation(.smooth(duration: 0.3), completionCriteria: .logicallyComplete) {
                            transitionAnimation = false
                        } completion: {
                            removeNotificationView()
                        }
                    } else {
                        withAnimation(.smooth(duration: 0.3)) {
                            transitionAnimation = false
                        }
                        
                        removeNotificationView()
                    }
                }
            })
    }
    
    private var offsetY: CGFloat {
        if hasDynamicIsland {
            return 0
        }
        
        return transitionAnimation ? 0 : -(safeArea.top + 130)
    }
    
    private var safeArea: UIEdgeInsets {
        UIApplication.shared.safeArea
    }
    
    private func removeNotificationView() {
        guard let activeView = UIApplication.shared.activeWindow?.rootViewController?.view else {
            return
        }
        
        guard let view = activeView.viewWithTag(tag) else {
            return
        }
        
        Logging.l(tag: "InAppNotification", "Remove notification body with tag \(tag)")
        view.removeFromSuperview()
        
        if hasDynamicIsland, let ctrl = UIApplication.shared.activeWindow?.rootViewController as? StatusBarBasedController, ctrl.view.subviews.isEmpty {
            ctrl.statusBarStyle = .default
            ctrl.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
