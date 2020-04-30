//
//  TextToSpeech.swift
//  NoteTaker
//
//  Created by Ian McDonald on 29/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation
import AVFoundation

class TextToSpeech {
    
    static func say(_ text: String) {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: text)

        speechSynthesizer.speak(speechUtterance)
    }
}
