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
        Image("image_splash")
            .resizable()
            .ignoresSafeArea()
            .frame(maxHeight: .infinity)
            .aspectRatio(contentMode: .fill)
            .overlay {
                ActivityIndicatorView()
            }
            .onAppear(perform: {
                viewModel.initialize()
            })
    }
}

#Preview {
    LoadingView(viewModel: LoadingViewModel())
}
