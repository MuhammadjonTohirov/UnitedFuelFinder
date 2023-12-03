//
//  MarkerImageView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 30/10/23.
//

import Foundation
import UIKit
import Kingfisher

public class MarkerImageView: UIView, Identifiable {
    public var id: String
    
    private(set) var imageView: UIImageView = .init()
    
    private(set) var url: URL?
    private(set) var placeholder: UIImage?
    private(set) var nameLabel: UILabel = .init()
    private(set) var label: UILabel = .init()
    
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
        
    }
    
    private func setupView() {

        self.addSubview(nameLabel)
        self.addSubview(imageView)
        self.addSubview(label)
        
        self.label.font = .systemFont(ofSize: 11, weight: .semibold)
        self.label.textAlignment = .center
        self.label.numberOfLines = 1
        
        self.nameLabel.font = .systemFont(ofSize: 11, weight: .semibold)
        self.nameLabel.textAlignment = .center
        self.nameLabel.numberOfLines = 1

        self.nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.nameLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.nameLabel.heightAnchor.constraint(equalToConstant: 12).isActive = true

        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.label.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.label.topAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.image = placeholder
    }
    
    func set(url: URL?, placeholder: UIImage?, backgroundColor color: UIColor = .clear) {
        self.placeholder = placeholder
        self.url = url
        setupImage()
    }
    
    func set(price: String) {
        self.label.text = price
    }
    
    func set(name: String) {
        self.nameLabel.text = name
    }
    
    private func setupImage() {
        imageView.kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(0.2)), .scaleFactor(0.1)])
    }
    
    static func create(url: URL? = nil, placeholder: UIImage? = nil) -> MarkerImageView {
        return MarkerImageView(id: "marker_item", url: url, placeholder: placeholder)
    }
}
