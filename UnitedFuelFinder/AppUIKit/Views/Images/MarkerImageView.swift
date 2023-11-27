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
    private(set) var label: UILabel = .init()
    private(set) var backgroundView: UIView = .init()
    
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
        self.backgroundView.layer.cornerRadius = self.backgroundView.frame.height / 2
    }
    
    private func setupView() {
        self.backgroundView.backgroundColor = .systemBackground

        self.addSubview(imageView)
        self.addSubview(backgroundView)
        self.backgroundView.addSubview(label)
        self.label.font = .systemFont(ofSize: 10, weight: .medium)
        self.label.textAlignment = .center
        self.label.numberOfLines = 1
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.backgroundView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor).isActive = true
        self.backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor).isActive = true
        self.label.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor).isActive = true
        self.label.topAnchor.constraint(equalTo: backgroundView.topAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.clipsToBounds = true
        self.imageView.image = placeholder
    }
    
    func set(url: URL?, placeholder: UIImage?) {
        self.placeholder = placeholder
        self.url = url
        setupImage()
    }
    
    func set(text: String) {
        self.label.text = text
    }
    
    private func setupImage() {
        imageView.kf.setImage(with: url, placeholder: placeholder, options: [.transition(.fade(0.2)), .scaleFactor(0.1)])
    }
    
    static func create(url: URL? = nil, placeholder: UIImage? = nil) -> MarkerImageView {
        return MarkerImageView(id: "marker_item", url: url, placeholder: placeholder)
    }
}
