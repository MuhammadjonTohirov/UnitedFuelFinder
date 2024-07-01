//
//  LoadingView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 08/10/23.
//

import Foundation
import SwiftUI


struct LoadingView: View {
    @StateObject var viewModel: LoadingViewModel
    var body: some View {
        Image("image_splash")
            .resizable()
            .ignoresSafeArea()
            .frame(maxHeight: .infinity)
            .aspectRatio(contentMode: .fill)
            .overlay {
                ZStack {
                    ActivityIndicatorView()
                    Text(viewModel.loadingReason)
                        .font(.medium(size: 24))
                        .foregroundStyle(Color.secondary)
                        .offset(y: 50)
                }
            }
            .onAppear(perform: {
                viewModel.initialize()
            })
    }
}

#Preview {
    LoadingView(viewModel: LoadingViewModel())
}
