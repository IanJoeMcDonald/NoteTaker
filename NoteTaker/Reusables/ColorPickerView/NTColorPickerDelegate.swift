//
//  NTColorPickerDelegate.swift
//  NoteTaker
//
//  Created by Ian McDonald on 07/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

protocol NTColorPickerDelegate: AnyObject {
    /// Called when a color picker color was selected or when the color picker will disappear
    func colorPickerDidPickColor(_ color: UIColor)
}
