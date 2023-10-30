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
    @ObservedResults(DState.self, configuration: Realm.config) var states
    
    @State var searchText: String = ""
    
    var body: some View {
        ItemSelectionView(data: states) { item in
            Button(action: {
                if state == item {
                    state = nil
                    return
                }
                
                state = item
            }, label: {
                VStack(spacing: 0) {
                    HStack {
                        Text(item.name)
                            .foregroundStyle(Color.label)
                            .font(.system(size: 14))
                        Spacer()
                        
                        Image(systemName: "checkmark")
                            .opacity(state == item ? 1 : 0)
                    }
                    .frame(height: 48)
                    Divider()
                }
            })
        } onSearching: { item, key in
            if key.isEmpty {
                return true
            }
            
            return item.name.lowercased().contains(key.lowercased())
        }
        .navigationTitle("select_state".localize)
        .onAppear {
            Task {
                await CommonService.shared.syncStates()
            }
        }
    }
}


