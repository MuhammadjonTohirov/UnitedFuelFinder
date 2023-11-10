//
//  SelectCompanyView.swift
//  UnitedFuelFinder
//
//  Created by Sardorbek Saydamatov on 02/11/23.
//

import SwiftUI
import RealmSwift

struct SelectCompanyView: View {
    @Binding var company: DCompany?
    @ObservedResults(DCompany.self, configuration: Realm.config) var companies
    
    @State var searchText: String = ""
    
    var body: some View {
        ItemSelectionView(data: companies) { item in
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .foregroundStyle(Color.label)
                    .font(.system(size: 13, weight: .medium))
                    
                Text(item.address)
                    .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                    .font(.system(size: 12))
            }
            .frame(height: 56)
        } onSearching: { item, key in
            if key.isEmpty {
                return true
            }
            
            return item.name.lowercased().contains(key.lowercased())
        }  onSelectChange: { items in
            self.company = items.first
        }
        .navigationTitle("select_state".localize)
        .onAppear {
            Task {
                await CommonService.shared.syncCompanies()
            }
        }
    }
}

#Preview {
    @State var company: DCompany?
    return SelectCompanyView(company: $company)
}
