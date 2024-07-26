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
                        Icon(systemName: "keyboard.chevron.compact.down")
                            .frame(width: 24, height: 24, alignment: .center)
                            .font(.lato(size: 20, weight: .semibold))
                            .foregroundColor(Color(UIColor.systemGray))
                    })
                }
            })
    }
}

