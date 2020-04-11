//
//  NSMutableAttributedStringExtension.swift
//  NoteTaker
//
//  Created by Ian McDonald on 04/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    func setColor(_ color: UIColor, for range: NSRange) {
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    func setFont(_ font: UIFont, for range: NSRange) {
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
}
