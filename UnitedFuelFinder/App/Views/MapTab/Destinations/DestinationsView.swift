//
//  DestinationsView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 08/06/24.
//

import Foundation
import SwiftUI

struct DestinationsView: View {
    @EnvironmentObject var viewModel: DestinationsViewModel
    @State var draggedItem: MapDestination?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ForEach(
                Array(viewModel.destinations.enumerated()),
                id: \.offset
            ) { item in
                row(
                    destination: item,
                    rightView: Image(
                        systemName: "trash"
                    )
                    .onTapGesture {
                        viewModel.delete(at: item.offset)
                    }
                    .anyView
                )
                .onDrag({
                    draggedItem = item.element
                    return NSItemProvider(
                        object: String(item.offset) as NSString
                    )
                })
                .onDrop(
                    of: [.plainText],
                    delegate: DestinationsViewModel.DropHandler(
                        destination: item.element,
                        items: $viewModel.destinations,
                        draggedItem: $draggedItem
                    )
                )
            }
            .vertical(alignment: .top)
            .scrollable()
            SubmitButton {
                viewModel.commitChanges()
            } label: {
                Text("commit".localize)
            }
            .padding(.bottom, Padding.default)
            .vertical(alignment: .bottom)
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Text("close".localize)
            }
        })
        .padding(.top, Padding.default)
        .navigationTitle(
            "all.destinations".localize
        )
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(
            .basedOnSize,
            axes: .vertical
        )
        .padding(.horizontal, Padding.default)
    }
    
    private func row(
        destination: (offset: Int, element: MapDestination),
        rightView: AnyView
    ) -> some View {
        HStack {
            PointButton(
                text: destination.element.address ?? "",
                isLoading: false,
                label: destination.offset.label.description,
                labelColor: labelColor(destination.offset)
            ) {
                self.viewModel.delegate?.editDestination(
                    model: viewModel,
                    destination: destination.element
                )
            }
            
            Rectangle()
                .foregroundStyle(.background)
                .frame(width: 32, height: 32)
                .overlay(content: {
                    rightView
                })
                .padding(
                    .leading,
                    Padding.small * 1.5
                )
                .onTapGesture {
                    
                }
        }
    }
    
    private func labelColor(_ offset: Int) -> Color {
        LabelColor(allDestinationsCount: viewModel.destinations.count, offset: offset).color
    }
}

struct LabelColor {
    var color: Color
    
    init(allDestinationsCount: Int, offset: Int) {
        if offset == 0 {
            color = .red
            return
        }
        
        if offset == allDestinationsCount - 1 {
            color = .label
            return
        }
        
        color = .blue
    }
}

#Preview {
    let viewModel = DestinationsViewModel()
    viewModel.destinations = [
        .init(location: .init(latitude: 0, longitude: 0), address: "ABC1"),
        .init(location: .init(latitude: 0, longitude: 2), address: "ABC2"),
        .init(location: .init(latitude: 0, longitude: 3), address: "ABC3")
    ]
    return NavigationStack {
        DestinationsView()
            .environmentObject(viewModel)
    }
}
