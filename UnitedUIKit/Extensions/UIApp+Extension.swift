//
//  UIApp+Extension.swift
//  UnitedUIKit
//
//  Created by applebro on 07/10/23.
//

import Foundation
import SwiftUI
import USDK

public extension UIApplication {
    func showNotification<Content: View>(swipeToClose: Bool = false, adaptForDynamicIsland: Bool = true, timeout: CGFloat = 1, @ViewBuilder content: @escaping () -> Content) {
        @codableWrapper(key: "inapp_notification_tag", 0)
        var inappNotificationTag: Int?
        
        Logging.l(tag: "UI", "Show notification")
        
        guard let activeView = activeWindow?.rootViewController?.view else {
            Logging.l(tag: "UI", "No active view")
            return
        }
        
        let frame = activeView.frame
        
        let hasDynamicIsland = safeArea.top > 51 && adaptForDynamicIsland
        let tag = inappNotificationTag! + 1
        let config = UIHostingConfiguration(content: {
            NotificationContentView(content: content(), timeout: timeout, swipeToClose: swipeToClose, tag: tag, hasDynamicIsland: hasDynamicIsland)
                .frame(width: frame.width - (hasDynamicIsland ? 20 : 30), height: 120, alignment: .top)
                .contentShape(.rect)
        })
        
        if hasDynamicIsland, let ctrl = UIApplication.shared.activeWindow?.rootViewController as? StatusBarBasedController {
            ctrl.statusBarStyle = .darkContent
            ctrl.setNeedsStatusBarAppearanceUpdate()
        }
                
        let view = config.makeContentView()
        view.tag = tag
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        activeView.addSubview(view)
        
        view.leadingAnchor.constraint(
            equalTo: activeView.leadingAnchor,
            constant: 15
        ).isActive = true
        
        view.trailingAnchor.constraint(
            equalTo: activeView.trailingAnchor,
            constant: -15)
        .isActive = true
        
        view.topAnchor.constraint(
            equalTo: activeView.topAnchor,
            constant: hasDynamicIsland ? (-safeArea.top + 2) : (safeArea.top)).isActive = true
        
    }
}

extension UIApplication {
    var activeWindow: UIWindow? {
        guard let activeView = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: {$0.tag == OVERLAY_WINDOW_TAG}) else {
            return nil
        }
        
        return activeView
    }
    
    public var safeArea: UIEdgeInsets {
        guard let activeView = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            return .zero
        }
        
        return activeView.safeAreaInsets
    }
    
    public var screenFrame: CGRect {
        guard let activeView = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            return .zero
        }
        
        return activeView.frame
    }
    
    public var hasDynamicIsland: Bool {
        safeArea.top > 51
    }
    
    public func dismissKeyboard() {
        guard let activeView = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first else {
            return
        }
        

        activeView.endEditing(true)
    }
}
