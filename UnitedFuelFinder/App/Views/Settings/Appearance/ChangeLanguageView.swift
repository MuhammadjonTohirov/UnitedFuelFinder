//
//  ChangeLanguageView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 06/12/23.
//

import Foundation
import SwiftUI

struct ChangeLanguageView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack(spacing: Padding.medium) {
            row(title: Language.english.name, isSelected: UserSettings.shared.language == .english) {
                UserSettings.shared.language = .english
                showMain()
            }
            
            Divider()
            
            row(title: Language.russian.name, isSelected: UserSettings.shared.language == .russian) {
                UserSettings.shared.language = .russian
                showMain()
            }
            
            Divider()
            
            row(title: Language.uzbek.name, isSelected: UserSettings.shared.language == .uzbek) {
                UserSettings.shared.language = .uzbek
                showMain()
            }
            
            Spacer()
        }
        .navigationTitle("language".localize)
        .padding(Padding.default)
    }
    
    func row(title: String, isSelected: Bool = false, onClick: @escaping () -> Void) -> some View {
        Button {
            onClick()
        } label: {
            HStack {
                Text(title)
                    .font(.lato(size: 12, weight: .medium))
                    .foregroundStyle(Color.label)

                Spacer()
                
                Icon(systemName: "checkmark.circle.fill")
                    .opacity(isSelected ? 1 : 0)
            }
        }
    }
    
    private func selectLanguage(_ lang: Language) {
        mainViewModel.set(language: lang)
    }
    
    private func onClickContinue() {
        UserSettings.shared.isLanguageSelected = true
        Task(priority: .high) {
            await appDelegate?.navigate(to: .auth)
        }
    }
    
    private func showMain() {
        Task(priority: .high) {
            try? await Task.sleep(nanoseconds: 200)
            await appDelegate?.navigate(to: .loading)
        }
    }
}

#Preview {
    NavigationView {
        ChangeLanguageView()
            .environmentObject(MainViewModel())
    }
}
