//
//  DestinationMarkerView.swift
//  UnitedFuelFinder
//
//  Created by applebro on 12/06/24.
//

import Foundation
import UIKit

final class DestinationMarkerView: UIView {
    enum Position {
        case start
        case middle
        case end
    }
    var label: UILabel = .init()
    
    func set(label: String) {
        self.label.text = label
    }
    
    func set(color: UIColor) {
        self.backgroundColor = color
    }
    
    func set(position: DestinationMarkerView.Position) {
        switch position {
        case .start:
            self.set(color: .systemRed)
        case .middle:
            self.set(color: .systemBlue)
        case .end:
            self.set(color: .appIcon)
            self.label.textColor = .appBackground
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
        self.layer.cornerRadius = min(self.frame.width, self.frame.height) / 2
    }
}
