//
//  ItemSelectionView.swift
//  UnitedUIKit
//
//  Created by applebro on 26/10/23.
//

import Foundation
import SwiftUI
import RealmSwift

internal class ItemSelectionViewModel<C: Object & Identifiable>: ObservableObject {
    @Published var searchText: String = ""
    @Published var isSearchPresented: Bool = true
    
    var selectedObjectsIds: Set<C.ID> = []
}

public struct ItemSelectionView<C: Object & Identifiable>: View {
    var data: Results<C>
    var multiSelect: Bool = false
    
    @StateObject private var viewModel = ItemSelectionViewModel<C>()
    
    var listItem: (C) -> any View
    var onSearching: (C, String) -> Bool
    var onSelectChange: (Set<C>) -> Void
    
    @Environment (\.presentationMode) var presentationMode
    
    public var body: some View {
        LazyVStack(content: {
            ForEach(data.filter({
                onSearching($0, viewModel.searchText)
            })) { item in
                VStack {
                    Button(action: {
                        self.onSelect(item)
                        self.onSelectChange(Set(data.filter({self.viewModel.selectedObjectsIds.contains($0.id)})))
                    }, label: {
                        HStack {
                            AnyView(listItem(item))
                            
                            Spacer()

                            Image(systemName: "checkmark")
                                .opacity(viewModel.selectedObjectsIds.contains(item.id) ? 1 : 0)
                        }
                    })
                    
                    Divider()
                }
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
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
    
    private func onSelect(_ item: C) {
        if viewModel.selectedObjectsIds.contains(item.id) {
            viewModel.selectedObjectsIds.remove(item.id)
        }
        
        if !multiSelect {
            viewModel.selectedObjectsIds.removeAll()
        }
        
        viewModel.selectedObjectsIds.insert(item.id)
    }
}

struct TestView: View {
    @State var stations: [StationItem] = []
    var body: some View {
        HomeView()
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
