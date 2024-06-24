//
//  ViewController+Extensions.swift
//  UnitedFuelFinder
//
//  Created by applebro on 15/05/24.
//

import Foundation
import UIKit
import SwiftUI

// viewcontroller as swiftui
public extension UIViewController {
    var asSwiftUI: some View {
        UIViewControllerWrapper(rootViewController: self)
    }
}

private struct UIViewControllerWrapper: UIViewControllerRepresentable {
    let rootViewController: UIViewController

    func makeUIViewController(context: Context) -> UIViewController {
        rootViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
