//
//  MarkerImageView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation
import UIKit
import SwiftUI
import Kingfisher

public class MarkerImageView: UIView, Identifiable {
    public var id: String
    
    private(set) lazy var imageView: UIImageView = .init()
    private(set) var url: URL?
    private(set) var placeholder: UIImage?
    private(set) lazy var nameLabel: UILabel = .init()
    private(set) lazy var label: UILabel = .init()
    private(set) lazy var backgroundImageView = UIImageView()
    
    init(id: String, url: URL? = nil, placeholder: UIImage?) {
        self.id = id
        self.placeholder = placeholder
        self.url = url
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        setupView()
        setupImage()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundImageView.frame = self.bounds
    }
    
    private func setupView() {
        self.addSubview(backgroundImageView)
        self.addSubview(nameLabel)
        self.addSubview(imageView)
        self.addSubview(label)
        
        self.label.font = .systemFont(ofSize: 11, weight: .bold)
        self.label.textAlignment = .center
        self.label.numberOfLines = 1
        
        self.nameLabel.font = .systemFont(ofSize: 11, weight: .medium)
        self.nameLabel.textAlignment = .center
        self.nameLabel.numberOfLines = 1

        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 4).isActive = true
        self.nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -8).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3).isActive = true
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -18).isActive = true
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.image = placeholder
    }
    
    func set(url: URL?, placeholder: UIImage?, backgroundColor color: UIColor = .clear) {
        self.placeholder = placeholder
        self.url = url
        setupImage()
    }
    
    @discardableResult
    func set(price: String) -> Self {
        self.label.text = price
        return self
    }
    
    @discardableResult
    func set(name: String) -> Self {
        self.nameLabel.text = name
        return self
    }
    
    private func setupImage() {
        backgroundImageView.image = UIImage(named: "icon_station_pin_2")
        imageView.contentMode = .scaleAspectFit
        backgroundImageView.contentMode = .scaleAspectFit
        imageView.kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(0.2)), .scaleFactor(0.1)])
    }
    
    static func create(url: URL? = nil, placeholder: UIImage? = nil) -> MarkerImageView {
        return MarkerImageView(id: "marker_item", url: url, placeholder: placeholder)
    }
}

#Preview {
    MarkerImageView(
        id: "0012",
        placeholder: UIImage(named: "image_ta")
    )
    .set(name: "№281")
    .set(price: "$3.2")
    .asSwiftUI
    .frame(width: 56, height: 80)
}
