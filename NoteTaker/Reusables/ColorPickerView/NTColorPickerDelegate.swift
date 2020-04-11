//
//  NTColorPickerDelegate.swift
//  NoteTaker
//
//  Created by Ian McDonald on 07/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

@objc protocol NTColorPickerDelegate: AnyObject {
    /// Called when a color picker color was selected or when the color picker will disappear
    func colorPickerDidPickColor(_ color: UIColor)
    @objc optional func colorPickerDidDisappear(_ color:UIColor)
}
