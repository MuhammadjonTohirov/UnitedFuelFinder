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
        .searchable(text: $searchText)
    }
}

struct TestView: View {
    
    var body: some View {
        EmptyView()
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
