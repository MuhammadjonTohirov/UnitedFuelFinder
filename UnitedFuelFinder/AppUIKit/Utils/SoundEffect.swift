//
//  SoundEffect.swift
//  UnitedUIKit
//
//  Created by applebro on 23/10/23.
//

import Foundation
import AVKit

public struct SEffect {
//    public static var soundPlayer: AVAudioPlayer?
    
    public static func rigid() {
        let generator = UIImpactFeedbackGenerator(style: .rigid)
        generator.impactOccurred()
    }
}
