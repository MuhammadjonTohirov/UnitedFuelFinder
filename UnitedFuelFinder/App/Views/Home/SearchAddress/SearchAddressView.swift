//
//  SearchAddressView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 07/11/23.
//

import Foundation
import SwiftUI
import GoogleMaps
import Combine

struct SearchAddressView: View {
    @StateObject var viewModel = SearchAddressViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var searchCancellables = Set<AnyCancellable>()
    private var text: String
    var title: String = "search_address".localize
    
    var onResult: ((SearchAddressViewModel.SearchAddressResult) -> Void)?
    
    init(title: String = "search_address".localize, text: String = "", onResult: ((SearchAddressViewModel.SearchAddressResult) -> Void)? = nil) {
        self.title = title
        self.onResult = onResult
        self.text = text
    }
    
    var body: some View {
        ZStack {
            innerBody
            ProgressView()
                .opacity(viewModel.isLoading ? 1 : 0)
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Text("done".localize)
                }

            }
        })
        .navigationTitle(title)
        .onAppear {
            viewModel.addressText = text
            viewModel.onAppear()
        }
    }
    
    private var innerBody: some View {
        VStack(alignment: .leading) {
            if viewModel.addressList.isEmpty {
                Text("no_results".localize)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                    .padding(Padding.large)
            } else {
                ForEach(viewModel.addressList, id: \.title) { address in
                    addressView(address)
                }
            }
        }
        .padding(.horizontal, 16)
        .scrollable(showIndicators: false)
        .searchable(text: $viewModel.addressText)
    }
    
    private func addressView(_ address: SearchAddressItem) -> some View {
        VStack {
            Button {
                viewModel.onClickAddress(address) { res in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if let res {
                            onSuccessResult(res)
                        }
                    }
                }
            } label: {
                HStack(alignment: .center) {
                    address
                        .icon
                        .renderingMode(.template)
                        .foregroundStyle(Color(address.type == .history ? .secondaryLabel : .accent))
                    
                    Text(address.title)
                        .font(.system(size: 13, weight: .regular))
                        .padding(.vertical, Padding.small)
                        .foregroundStyle(Color.label)
                        .lineLimit(1)
                        .foregroundStyle(Color(address.type == .history ? .secondaryLabel : .label))
                    Spacer()
                }
                .background {
                    Rectangle().foregroundStyle(Color.clear)
                }
            }

            Divider()
        }
    }
    
    private func onSuccessResult(_ res: SearchAddressViewModel.SearchAddressResult) {
        onResult?(res)
        mainIfNeeded {
            self.dismiss.callAsFunction()
        }
    }
}

#Preview {
    return NavigationView {
        SearchAddressView(title: "search_address".localize) { res in
            print(res.address, res.lat, res.lng)
        }
    }
}
