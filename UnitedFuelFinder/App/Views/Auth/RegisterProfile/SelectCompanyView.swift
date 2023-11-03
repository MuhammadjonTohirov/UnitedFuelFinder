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
            Button(action: {
                if company == item {
                    company = nil
                    return
                }
                
                company = item
            }, label: {
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .foregroundStyle(Color.label)
                                .font(.system(size: 13, weight: .medium))
                            
                            Text(item.address)
                                .foregroundStyle(Color.init(uiColor: .secondaryLabel))
                                .font(.system(size: 12))
                        }
                        Spacer()
                        
                        Image(systemName: "checkmark")
                            .opacity(company == item ? 1 : 0)
                    }
                    .frame(height: 62)
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
                await CommonService.shared.syncCompanies()
            }
        }
    }
}

#Preview {
    @State var company: DCompany?
    return SelectCompanyView(company: $company)
}
