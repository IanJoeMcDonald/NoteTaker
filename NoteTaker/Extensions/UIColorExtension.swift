//
//  UIColorExtension.swift
//  NoteTaker
//
//  Created by Ian McDonald on 09/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

extension UIColor {
    
    var name: String? {
        let allColors = UIColor.listAllColorsInBundle()
        
        if allColors.keys.contains(self){
            return allColors[self]
        } else {
            return nil
        }
    }
    
    static func listAllColorsInBundle() -> [UIColor:String] {
        var allColors = [UIColor:String]()
        // Grayscale
        for index in 0 ..< 12 {
            let color = UIColor(forName: ColorConstants.grayscale, shade: index)
            allColors[color] = ColorConstants.grayscale + String(index)
        }
        
        for colorIndex in 0 ..< ColorConstants.array.count {
            for numberIndex in 0 ..< 9 {
                let color = UIColor(forName: ColorConstants.array[colorIndex], shade: numberIndex)
                allColors[color] = ColorConstants.array[colorIndex] + String(numberIndex)
            }
        }
        
        return allColors
    }
    
    convenience init(forName name: String, shade: Int) {
        let colorName = name + String(shade)
        guard let _ = UIColor(named: colorName) else {
            fatalError("Invalid color name: \(colorName)")
        }
        
        self.init(named: colorName)!
    }
    
}
