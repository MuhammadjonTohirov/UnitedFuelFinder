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
    @State var stations: [StationItem] = []
    var body: some View {
        AllStationsView(from: nil, to: nil, radius: "25 km", stations: stations)
        .onAppear {
            Task {
                let sts = await MainService.shared.findStations(atCity: "1")
                
                DispatchQueue.main.async {
                    stations = sts
                }
            }
        }
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
