//
//  CloseKeyboardModifier.swift
//  UnitedUIKit
//
//  Created by applebro on 23/10/23.
//

import Foundation
import SwiftUI

struct CloseKeyboardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbar(content:  {
                ToolbarItem(placement: .keyboard) {
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }, label: {
                        Image(systemName: "keyboard.chevron.compact.down")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(UIColor.systemGray))
                    })
                }
            })
    }
}

