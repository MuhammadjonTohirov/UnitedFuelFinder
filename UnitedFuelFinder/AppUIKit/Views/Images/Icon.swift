//
//  Icon.swift
//  UnitedFuelFinder
//
//  Created by applebro on 18/03/24.
//

import Foundation
import SwiftUI

struct Icon: View {
    private var name: String?
    private var systemName: String?
    
    init(name: String) {
        self.name = name
    }
    
    init(systemName: String) {
        self.systemName = systemName
    }
    
    var body: some View {
        image
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(Color.appIcon)
            .frame(width: 24, height: 24)
    }
    
    private var image: Image {
        if let name = name {
            return Image(name)
        } else if let systemName = systemName {
            return Image(systemName: systemName)
        } else {
            return Image(systemName: "")
        }
    }
}
