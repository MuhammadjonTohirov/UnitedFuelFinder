//
//  ChangeThemeView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 28/12/23.
//

import Foundation
import SwiftUI

// I need a view called ChangeThemeView
// the reason is to change theme for light, dark or system
// create the view

struct ChangeThemeView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: Padding.medium) {
            row(title: Theme.light.name, isSelected: UserSettings.shared.theme == .light) {
                UserSettings.shared.theme = .light
                selectTheme(.light)
                dismiss.callAsFunction()
            }
            
            Divider()
            
            row(title: Theme.dark.name, isSelected: UserSettings.shared.theme == .dark) {
                UserSettings.shared.theme = .dark
                selectTheme(.dark)
                dismiss.callAsFunction()
            }
            
            Divider()
            
            row(title: Theme.system.name, isSelected: UserSettings.shared.theme == .system) {
                UserSettings.shared.theme = .system
                selectTheme(.system)
                dismiss.callAsFunction()
            }
            
            Spacer()
        }
        .navigationTitle("theme".localize)
        .padding(Padding.default)
    }
    
    func row(title: String, isSelected: Bool = false, onClick: @escaping () -> Void) -> some View {
        Button {
            onClick()
        } label: {
            HStack {
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.label)

                Spacer()
                
                Image(systemName: "checkmark.circle.fill")
                    .opacity(isSelected ? 1 : 0)
            }
        }
    }
    
    private func selectTheme(_ theme: Theme) {
        UserSettings.shared.theme = theme
        changeTheme(theme: theme)
    }
    
    func changeTheme(theme: Theme) {
        var style: UIUserInterfaceStyle = .unspecified
        
        switch theme {
        case .system:
            style = .unspecified
        case .light:
            style = .light
        case .dark:
            style = .dark
        }
        
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first!.overrideUserInterfaceStyle = style
    }
}
