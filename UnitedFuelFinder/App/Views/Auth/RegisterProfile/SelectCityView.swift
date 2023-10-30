//
//  SelectStateView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 27/10/23.
//

import Foundation
import SwiftUI
import RealmSwift

struct SelectCityView: View {
    @Binding var city: DCity?
    @ObservedResults(DCity.self, configuration: Realm.config) var cities
    var stateId: String
    @State private var isLoading: Bool = false
    @State var searchText: String = ""
    
    var body: some View {
        ZStack {
            innerBody
                .opacity(isLoading ? 0.5 : 1)
            
            ProgressView()
                .opacity(isLoading ? 1 : 0)
        }
    }
    
    var innerBody: some View {
        ItemSelectionView(data: cities) { item in
            Button(action: {
                if city == item {
                    city = nil
                    return
                }
                
                city = item
            }, label: {
                VStack(spacing: 0) {
                    HStack {
                        Text(item.name)
                            .foregroundStyle(Color.label)
                            .font(.system(size: 14))
                        Spacer()
                        
                        Image(systemName: "checkmark")
                            .opacity(city == item ? 1 : 0)
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
        .navigationTitle("select_city".localize)
        .onAppear {
            syncCities()
        }
    }
    
    
    private func syncCities() {
        self.isLoading = true
        Task {
            await CommonService.shared.syncCities(forState: stateId)
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}


