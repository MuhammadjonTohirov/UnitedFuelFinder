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
    private var aspectRatio: ContentMode = .fit
    private var renderingMode: Image.TemplateRenderingMode = .template
    private var isResizable: Bool = true
    private var size: CGSize = .init(width: 24, height: 24)
    private var color: Color = .appIcon
    
    init(name: String) {
        self.name = name
    }
    
    init(systemName: String) {
        self.systemName = systemName
    }
    
    var body: some View {
        _body
            .renderingMode(renderingMode)
            .aspectRatio(contentMode: aspectRatio)
            .foregroundStyle(color)
            .frame(width: size.width, height: size.height)
    }
    
    private var _body: Image {
        if isResizable {
            image.resizable()
        } else {
            image
        }
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

extension Icon {
    func aspectRatio(_ ratio: ContentMode) -> Self {
        var v = self
        v.aspectRatio = ratio
        return v
    }
    
    func renderingMode(_ mode: Image.TemplateRenderingMode) -> Self {
        var v = self
        v.renderingMode = mode
        return v
    }
    
    func resizable(_ resizable: Bool = true) -> Self {
        var v = self
        v.isResizable = resizable
        return v
    }
    
    func size(_ size: CGSize) -> Self {
        var v = self
        v.size = size
        return v
    }
    
    func iconColor(_ color: Color) -> Self {
        var v = self
        v.color = color
        return v
    }
}
