//
//  SelectLanguageView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/10/23.
//

import Foundation
import SwiftUI



struct SelectLanguageView: View {
    @State private var submitButtonRect: CGRect = .zero
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        ZStack {
            languagesView
                .padding(.bottom, 40)
            VStack {
                Spacer()
                
                SubmitButton {
                    onClickContinue()
                } label: {
                    Text("continue".localize)
                }
                .padding(16)
            }
        }.onAppear {
            mainViewModel.language = (UserSettings.shared.language ?? .english)
        }
    }
    
    private var languagesView: some View {
        VStack(spacing: 40) {
            RadioButton(isSelected: mainViewModel.language == Language.english, title: {
                Text(Language.english.name)
            }, action: {
                selectLanguage(.english)
            }).set(enabled: true)
            
            RadioButton(isSelected: mainViewModel.language == Language.uzbek, title: {
                Text(Language.uzbek.name)
            }, action: {
                selectLanguage(.uzbek)
            })
            .set(enabled: false)
            
            RadioButton(isSelected: mainViewModel.language == Language.russian, title: {
                Text(Language.russian.name)
            }, action: {
                selectLanguage(.russian)
            })
            .set(enabled: false)
        }
    }
    
    private func selectLanguage(_ lang: Language) {
        mainViewModel.set(language: lang)
    }
    
    private func onClickContinue() {
        UserSettings.shared.isLanguageSelected = true
        mainRouter?.navigate(to: .auth)
    }
}

#Preview {
    SelectLanguageView()
        .environmentObject(MainViewModel())
}
