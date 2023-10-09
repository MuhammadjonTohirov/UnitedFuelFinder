//
//  UnitedUIApp.swift
//  UnitedUI
//
//  Created by applebro on 07/10/23.
//

import SwiftUI

let OVERLAY_WINDOW_TAG = 39102

public struct AppWindowGroup<Content: View> {
    @Binding var overlayWindow: PassThroughWindow?
    
    public var content: () -> Content
    
    public init(overlayWindow: Binding<PassThroughWindow?>, @ViewBuilder content: @escaping () -> Content) {
        self._overlayWindow = overlayWindow
        self.content = content
    }
    
    public var body: some Scene {
        WindowGroup {
            content()
                .onAppear {
                    if overlayWindow == nil {
                        guard let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                            return
                        }
                        
                        let window = PassThroughWindow(windowScene: currentScene)
                        
                        window.tag = OVERLAY_WINDOW_TAG
                        window.backgroundColor = .clear
                        let controller = StatusBarBasedController()
                        controller.view.backgroundColor = .clear
                        window.rootViewController = controller
                        window.isHidden = false
                        window.isUserInteractionEnabled = true
                        
                        self.overlayWindow = window
                        self.overlayWindow?.makeKeyAndVisible()
                    }
                }
        }
    }
}

class StatusBarBasedController: UIViewController {
    var statusBarStyle: UIStatusBarStyle = .default
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}

public class PassThroughWindow: UIWindow {
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else {
            return nil
        }
        
        return rootViewController?.view == view ? nil : view
    }
}
