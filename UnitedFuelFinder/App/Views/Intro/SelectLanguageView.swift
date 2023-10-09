//
//  SelectLanguageView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 03/10/23.
//

import Foundation
import SwiftUI
import UnitedUIKit
import USDK

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
                    .foregroundStyle(Color.label)
            }, action: {
                selectLanguage(.english)
            })
            
            RadioButton(isSelected: mainViewModel.language == Language.uzbek, title: {
                Text(Language.uzbek.name)
                    .foregroundStyle(Color.label)
            }, action: {
                selectLanguage(.uzbek)
            })
            
            RadioButton(isSelected: mainViewModel.language == Language.russian, title: {
                Text(Language.russian.name)
                    .foregroundStyle(Color.label)
            }, action: {
                selectLanguage(.russian)
            })
        }
    }
    
    private func selectLanguage(_ lang: Language) {
        mainViewModel.set(language: lang)
    }
}

#Preview {
    SelectLanguageView()
        .environmentObject(MainViewModel())
}
