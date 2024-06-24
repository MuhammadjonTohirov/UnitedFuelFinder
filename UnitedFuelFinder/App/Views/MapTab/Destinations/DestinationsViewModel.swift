//
//  DestinationsViewModel.swift
//  UnitedFuelFinder
//
//  Created by applebro on 10/06/24.
//

import Foundation
import SwiftUI

protocol DestinationsDelegate: AnyObject {
    func commitChanges(model: DestinationsViewModel, destinations: [MapDestination])
    func editDestination(model: DestinationsViewModel, destination: MapDestination)
    func addDestination(model: DestinationsViewModel, destinations: [MapDestination])
}

final class DestinationsViewModel: ObservableObject {
    @Published var destinations: [MapDestination] = []
    weak var delegate: DestinationsDelegate?
    
    func delete(at index: Int) {
        destinations.remove(at: index)
    }
    
    func commitChanges() {
        self.delegate?.commitChanges(
            model: self,
            destinations: destinations
        )
    }
    
    func onClickAddNew() {
        self.delegate?.addDestination(model: self, destinations: destinations)
    }
}

extension DestinationsViewModel {
    struct DropHandler: DropDelegate {
        let destination: MapDestination
        @Binding var items: [MapDestination]
        @Binding var draggedItem: MapDestination?
        
        func performDrop(info: DropInfo) -> Bool {
            return true
        }
        
        func dropUpdated(info: DropInfo) -> DropProposal? {
            DropProposal(operation: .move)
        }
        
        func dropEntered(info: DropInfo) {
            if let draggedItem {
                let fromIndex = items.firstIndex(where: {$0.id == draggedItem.id})
                if let fromIndex {
                    let toIndex = items.firstIndex(where: {$0.id == destination.id})
                    if let toIndex, fromIndex != toIndex {
                        withAnimation {
                            self.items.move(
                                fromOffsets: IndexSet(
                                    integer: fromIndex),
                                toOffset: (toIndex > fromIndex ? (toIndex + 1) : toIndex)
                            )
                        }
                    }
                }
            }
        }
    }

}
