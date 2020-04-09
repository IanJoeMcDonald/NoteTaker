//
//  NTColorPickerDelegate.swift
//  NoteTaker
//
//  Created by Ian McDonald on 07/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

protocol NTColorPickerDelegate: AnyObject {
    func colorPickerDidPickColor(_ color: UIColor)
}
