//
//  TMapsViewWrapper.swift
//  UnitedFuelFinder
//
//  Created by applebro on 15/05/24.
//

import Foundation
import SwiftUI

struct TMapsViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> TrimbleViewController {
        let view = TrimbleViewController()
        return view
    }
    
    func updateUIViewController(_ uiViewController: TrimbleViewController, context: Context) {
    }
}
