//
//  TestUI.swift
//  UnitedFuelFinder
//
//  Created by applebro on 27/12/23.
//

import Foundation
import SwiftUI

enum TestPage: Identifiable, Hashable {
    static func == (lhs: TestPage, rhs: TestPage) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
    
    var id: String {
        switch self {
        case .page1:
            return "page1"
        case .page2:
            return "page2"
        }
    }
    
    case page1(showNewPage: () -> Void)
    case page2
    
    @ViewBuilder
    func screen() -> some View {
        switch self {
        case .page1(let showNewPage):
            VStack {
                ScrollView {
                    VStack {
                        Text("page 1")
                            .onTapGesture {
                                showNewPage()
                            }
                        
                        Text("page 1")
                        Text("page 1")
                        Text("page 1")
                        Text("page 1")
                        Text("page 1")
                    }
                }
            }
            
        case .page2:
            Text("Page 2")
        }
    }
}

struct TestUI: View {
 
    var body: some View {
        TestWrapper()
    }
}

#Preview {
    TestUI()
}
