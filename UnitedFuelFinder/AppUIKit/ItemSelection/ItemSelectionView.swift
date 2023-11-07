//
//  ItemSelectionView.swift
//  UnitedUIKit
//
//  Created by applebro on 26/10/23.
//

import Foundation
import SwiftUI
import RealmSwift

public struct ItemSelectionView<C: Object & Identifiable>: View {
    var data: Results<C>
    @State private var searchText: String = ""
    @State private var isSearchPresented: Bool = true
    var listItem: (C) -> any View
    var onSearching: (C, String) -> Bool
    
    @Environment (\.presentationMode) var presentationMode
    
    public var body: some View {
        LazyVStack(content: {
            ForEach(data.filter({
                onSearching($0, searchText)
            })) { item in
                AnyView(listItem(item))
            }
        })
        .scrollable()
        .padding(.horizontal, Padding.default)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("done".localize)
                })
            }
        })
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
}

struct TestView: View {
    @State var stations: [StationItem] = []
    var body: some View {
        HomeView()
    }
}

#Preview {
    NavigationView {
        TestView()
    }
}

extension UUID: Identifiable {
    public var id: String {
        self.uuidString
    }
}

extension String: Identifiable {
    public var id: String {
        self
    }
}
