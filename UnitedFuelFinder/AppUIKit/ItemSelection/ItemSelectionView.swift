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
    var data: [C]
    var multiSelect: Bool = false
    
    @StateObject private var viewModel = ItemSelectionViewModel<C>()
    @Binding var selectedItem: C?
    
    var listItem: (C) -> any View
    var onSearching: (C, String) -> Bool
    var onSelectChange: (Set<C>) -> Void
    
    //@Environment (\.dismiss) var dismiss
    
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
                        .overlay {
                            Rectangle()
                                .foregroundStyle(Color.background.opacity(0.05))
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
                    //dismiss.callAsFunction()
                    
                }, label: {
                    Text("done".localize)
                })
            }
        })
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
    
    private func onSelect(_ item: C) {
        self.selectedItem = item
        if viewModel.selectedObjectsIds.contains(item.id) {
            viewModel.selectedObjectsIds.remove(item.id)
        }
        
        if !multiSelect {
            viewModel.selectedObjectsIds.removeAll()
        }
        
        viewModel.selectedObjectsIds.insert(item.id)
        
        if !multiSelect {
            //dismiss.callAsFunction()
        }
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

class LabelView: UIView {
//    contains icon and UIlabel in horizontal
    var icon: UIImageView = UIImageView()
    var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(icon)
        self.addSubview(label)
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        // regenerate constraints with padding 4
        NSLayoutConstraint.activate([
            icon.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            icon.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            icon.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            icon.widthAnchor.constraint(equalToConstant: 22),
            icon.heightAnchor.constraint(equalToConstant: 22),
            
            label.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
        
        self.backgroundColor = UIColor.systemGray5
        
        self.icon.contentMode = .scaleAspectFit
        
        self.label.font = .systemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIcon(_ image: UIImage?) {
        icon.image = image
    }
    
    func setText(_ text: String) {
        label.text = text
    }
    
    func setTextColor(_ color: UIColor) {
        label.textColor = color
    }
    
    func setIconColor(_ color: UIColor) {
        icon.tintColor = color
    }
    
    func setBackgroudColor(_ color: UIColor) {
        self.backgroundColor = color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.height / 2
    }
}

struct TestWrapper: View {
    @State var alert = true
    var body: some View {
        Button {
            alert = true
        } label: {
            Text("Alert")
        }
        .richAlert(type: .custom(image: Image("icon_success_check").resizable().frame(width: 56, height: 56, alignment: .center).anyView), title: "Successfully Registered", message: "This user should be confirmed by company administrator after registration process.", isPresented: $alert) {
            Logging.l("On finish alert")
        }
    }
}

#Preview(body: {
    TestWrapper()
})
