//
//  Note.swift
//  NoteTaker
//
//  Created by Ian McDonald on 13/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import Foundation

class Note: Codable {
    var id = UUID()
    var text: String
    var created: Date
    var modified: Date
    
    
    init(text: String) {
        self.text = text
        created = Date()
        modified = Date()
    }
}
