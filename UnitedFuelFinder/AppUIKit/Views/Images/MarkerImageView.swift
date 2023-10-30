//
//  MarkerImageView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation
import UIKit
import Kingfisher

public class MarkerImageView: UIView {
    private(set) var imageView: UIImageView = .init()
    
    var url: URL?
    var placeholder: UIImage?
    
    init(url: URL? = nil, placeholder: UIImage?) {
        self.placeholder = placeholder
        self.url = url
        super.init(frame: .zero)
        
        setupView()
        setupImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(imageView)
        
//        setup constraints by anchors
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = placeholder
    }
    
    private func setupImage() {
        imageView.kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(0.2))])
    }
    
    static func create(url: URL? = nil, placeholder: UIImage? = nil) -> MarkerImageView {
        return MarkerImageView(url: url, placeholder: placeholder)
    }
}
