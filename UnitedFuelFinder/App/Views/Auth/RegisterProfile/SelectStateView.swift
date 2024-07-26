//
//  SelectStateView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 27/10/23.
//

import Foundation
import SwiftUI
import RealmSwift

struct SelectStateView: View {
    @Binding var state: DState?
    @State private var states: [DState] = []
    @State private var date: Date = Date()
    @State var searchText: String = ""
    @State private var isLoading: Bool = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            if !isLoading {
                innerBody
                    .opacity(isLoading ? 0.5 : 1)
            } else {
                ProgressView()
                    .opacity(isLoading ? 1 : 0)
            }
        }
        .navigationTitle("select_state".localize)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isLoading = true
            Task {
                await CommonService.shared.syncStates()
                
                try await Task.sleep(for: .milliseconds(300))
                
                await MainActor.run {
                    self.states = DState.allStates().map({$0})
                    self.isLoading = false
                }
            }
        }
    }
    
    var innerBody: some View {
        ItemSelectionView(data: states, selectedItem: $state) { item in
            Button(action: {
                if state == item {
                    state = nil
                    return
                }
                
                state = item
                date = Date()
            }, label: {
                Text(item.name)
                    .foregroundStyle(Color.label)
                    .font(.lato(size: 14))
                    .frame(height: 40)
            })
        } onSearching: { item, key in
            if key.isEmpty {
                return true
            }
            
            return item.name.lowercased().contains(key.lowercased())
        }  onSelectChange: { items in
            self.state = items.first
            self.dismiss.callAsFunction()
        }
    }
}


