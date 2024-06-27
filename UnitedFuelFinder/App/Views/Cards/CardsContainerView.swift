//
//  CardsContainerView.swift
//  UnitedFuelFinder
//
//  Created by Jurayev Nodir on 26/06/24.
//

import UIKit
import SwiftUI


struct CardsContainerView: View {
    
    @ObservedObject var viewModel: CardsViewModel
    
    init(viewModel: CardsViewModel) {
        self.viewModel = viewModel
        
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            CardListView(list: viewModel.cardList, isSmall: viewModel.isSmall)
        }
        .padding(.horizontal)
        .font(.semibold(size: 14))
        .frame(maxWidth: .infinity)
        .scrollable(showIndicators: false)
        .onAppear {
            self.viewModel.onAppear()
        }
    }
}

#Preview {
    let view = CardsContainerView(viewModel: .init())
    return view
}
