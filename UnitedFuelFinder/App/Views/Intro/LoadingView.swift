//
//  LoadingView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 08/10/23.
//

import Foundation
import SwiftUI


struct LoadingView: View {
    var viewModel: LoadingViewModelProtocol
    var body: some View {
        ActivityIndicatorView()
            .onAppear(perform: {
                viewModel.initialize()
            })
    }
}

#Preview {
    LoadingView(viewModel: LoadingViewModel())
}
