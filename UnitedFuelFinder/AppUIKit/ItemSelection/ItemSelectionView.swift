//
//  ItemSelectionView.swift
//  UnitedUIKit
//
//  Created by applebro on 26/10/23.
//

import Foundation
import SwiftUI

public struct ItemSelectionView<C: Identifiable>: View {
    @State var searchText = ""
    @State var items: [C]
    
    var listItem: (C) -> any View
    var onSearching: (C, String) -> Bool
    
//    dismisser
    @Environment (\.presentationMode) var presentationMode
    
    public var body: some View {
        NavigationView {
            LazyVStack(content: {
                ForEach(items.filter({ item in
                    onSearching(item, searchText)
                })) { item in
                    AnyView(listItem(item))
                }
            })
            .padding(.horizontal, Padding.default)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Select Item")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Done")
                    })
                }
            })
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Cancel")
                    })
                }
            })
            .searchable(text: $searchText)
        }
    }
}

#Preview {
    var items: [String] = ["Abbc", "Ab", "Abcd"]
    return ItemSelectionView(items: items) { item in
        Text(item)
    } onSearching: { item, searchText in
        if searchText.isEmpty {
            return true
        }
        
        return item.contains(searchText)
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
