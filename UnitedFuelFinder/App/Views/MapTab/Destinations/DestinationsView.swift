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
            ForEach(0..<viewModel.destinations.count + 1, id: \.self) { index in
                if index == viewModel.destinations.count {
                    Circle()
                        .frame(width: 30, height: 30)
                        .foregroundStyle(.clear)
                        .overlay {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .onTapGesture {
                            viewModel.onClickAddNew()
                        }
                        .horizontal(alignment: .leading)
                } else {
                    destinationItem(index)
                }
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
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Text("close".localize)
                }

            }
        })
        .padding(.top, Padding.default)
        .navigationTitle(
            "all.directions".localize
        )
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(
            .basedOnSize,
            axes: .vertical
        )
        .padding(.horizontal, Padding.default)
    }
    
    private func destinationItem(_ index: Int) -> some View {
        row(
            destination: (offset: index, element: viewModel.destinations[index]),
            rightView: Image(
                systemName: "trash"
            )
            .onTapGesture {
                viewModel.delete(at: index)
            }
            .anyView
        )
        .onDrag({
            draggedItem = viewModel.destinations[index]
            return NSItemProvider(
                object: String(index) as NSString
            )
        })
        .onDrop(
            of: [.plainText],
            delegate: DestinationsViewModel.DropHandler(
                destination: viewModel.destinations[index],
                items: $viewModel.destinations,
                draggedItem: $draggedItem
            )
        )
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
