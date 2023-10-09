//
//  AppDestination.swift
//  UnitedFuelFinder
//
//  Created by applebro on 08/10/23.
//

import Foundation
import SwiftUI

protocol ScreenRoute: Hashable, Identifiable {
    associatedtype Content: View
    var screen: Content {get}
    
    var id: String {get}
}

enum AppDestination: Hashable, ScreenRoute {
    static func == (lhs: AppDestination, rhs: AppDestination) -> Bool {
        lhs.id == rhs.id
    }

    var id: String {
        switch self {
        case .intro:
            return "intro"
        case .auth:
            return "auth"
        case .main:
            return "main"
        case .loading:
            return "loading"
        case .language:
            return "language"
        case .pin:
            return "pin"
        case .test:
            return "test"
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    case intro
    case auth
    case main
    case language
    case loading
    case pin
    case test
    
    @ViewBuilder var screen: some View {
        switch self {
        case .language:
            SelectLanguageView()
        case .loading:
            LoadingView(viewModel: LoadingViewModel())
        default:
            EmptyView()
        }
    }
}
