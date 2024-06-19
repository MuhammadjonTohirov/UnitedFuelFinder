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
    @EnvironmentObject var viewModel: SearchAddressViewModel
    @Environment(\.dismiss) var dismiss
    @State private var searchCancellables = Set<AnyCancellable>()
    
    private var text: String
    var title: String = "search_address".localize
    
    init() {
        self.text = ""
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
                    Text("cancel".localize)
                }

            }
        })
        .navigationTitle(title)
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.dispose()
        }
    }
    
    private var innerBody: some View {
        VStack(alignment: .leading) {
            HStack {
                YRoundedTextField(
                    focused: true,
                    radius: 8
                ) {
                    YTextField(
                        text: $viewModel.addressText,
                        placeholder: "search".localize
                    )
                }
                
                Image(systemName: "map.fill")
                    .padding(.leading, 6)
                    .onClick {
                        viewModel.onClickMap()
                    }
            }
            
            if viewModel.addressList.isEmpty && viewModel.addressHistoryList.isEmpty {
                Text("no_results".localize)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                    .padding(Padding.large)
                    .horizontal(alignment: .center)
            } else {
                if viewModel.addressList.isEmpty {
                    ForEach(viewModel.addressHistoryList, id: \.id) { address in
                        addressView(address)
                    }
                } else {
                    ForEach(viewModel.addressList, id: \.id) { address in
                        addressView(address)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .scrollable(showIndicators: false)
    }
    
    private func addressView(_ address: SearchAddressItem) -> some View {
        VStack {
            Button {
                viewModel.onClickAddress(address)
            } label: {
                HStack(alignment: .center) {
                    address
                        .icon
                        .renderingMode(.template)
                        .foregroundStyle(Color(address.type == .history ? .secondaryLabel : .accent))
                    
                    Text(address.address?.nilIfEmpty ?? address.title)
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
}

#Preview {
    UserSettings.shared.setupForTest()
    return NavigationStack {
        SearchAddressView()
        .environmentObject(SearchAddressViewModel())
    }
}
