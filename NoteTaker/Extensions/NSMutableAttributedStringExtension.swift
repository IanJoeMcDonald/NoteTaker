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
        var alreadyColor = true
        let location = range.location
        for index in location ..< location + range.length {
            let attributedColor = self.attribute(NSAttributedString.Key.foregroundColor,
                                                 at: index, effectiveRange: nil) as? UIColor
            if attributedColor ?? UIColor.black != color {
                alreadyColor = false
                break
            }
        }
        
        let colorToSet = alreadyColor ? UIColor.black : color
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: colorToSet, range: range)
    }
}
