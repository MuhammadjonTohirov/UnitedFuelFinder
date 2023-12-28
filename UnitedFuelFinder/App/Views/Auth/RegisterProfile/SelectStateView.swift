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
    @State private var date: Date = Date()
    @State var searchText: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ItemSelectionView(data: states) { item in
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
                    .font(.system(size: 14))
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
        .navigationTitle("select_state".localize)
        .onAppear {
            Task {
                await CommonService.shared.syncStates()
            }
        }
    }
}


