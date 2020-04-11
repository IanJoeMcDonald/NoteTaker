//
//  NTTextViewToolbarDelegate.swift
//  NoteTaker
//
//  Created by Ian McDonald on 11/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

protocol NTTextViewTolbarDelegate: AnyObject {
    /// Called when a color picker color was selected or when the color picker will disappear
    func colorPickerDidPickColor(_ color: UIColor)
    func fontPickerDidPickFont(_ font: UIFont)
    func resignFirstResponder()
    func showKeyboard()
    func presentVC(_ controller: UIViewController, animated: Bool)
}

