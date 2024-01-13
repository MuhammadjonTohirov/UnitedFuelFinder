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
    @State private var companies: [DCompany] = []
    
    @State var searchText: String = ""
    
    var body: some View {
        ItemSelectionView(data: companies, selectedItem: $company) { item in
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
                
                try await Task.sleep(for: .milliseconds(300))
                
                await MainActor.run {
                    self.companies = DCompany.allCompanies().map({$0})
                }
            }
        }
    }
}

#Preview {
    @State var company: DCompany?
    return SelectCompanyView(company: $company)
}
