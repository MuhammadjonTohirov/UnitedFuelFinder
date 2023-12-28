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
    @ObservedResults(DCity.self, configuration: Realm.config) var cities
    @Binding var city: DCity?
    var stateId: String
    
    @State private var isLoading: Bool = false
    @State var searchText: String = ""
    @Environment(\.dismiss) var dismiss
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
            Text(item.name)
                .foregroundStyle(Color.label)
                .font(.system(size: 14))
                .frame(height: 42)
        } onSearching: { item, key in
            if key.isEmpty {
                return true
            }
            
            return item.name.lowercased().contains(key.lowercased())
        } onSelectChange: { items in
            self.city = items.first
            self.dismiss.callAsFunction()
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

class SelectCityPreviewModel: ObservableObject {
    @Published var city: DCity?
}

struct SelectCityPreview: View {
    @StateObject var vm = SelectCityPreviewModel()
    
    var body: some View {
        SelectCityView(city: $vm.city, stateId: "NY")
    }
}

#Preview {
    SelectCityPreview()
}
