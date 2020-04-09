//
//  NoteViewController.swift
//  NoteTaker
//
//  Created by Ian McDonald on 01/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class WrittenNoteViewController: UIViewController, Storyboarded {
    
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addMenuItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func addMenuItems() {
        let setColor = UIMenuItem(title: "Color", action: #selector(selectColor))
        
        UIMenuController.shared.menuItems = [setColor]
    }
    
    @objc func selectColor() {
        // Hide Keyboard
        textView.resignFirstResponder()
        
        // Instantiate view
        let cpView = NTColorPickerView()
        cpView.translatesAutoresizingMaskIntoConstraints = false
        cpView.delegate = self
        
        // Add view
        view.addSubview(cpView)
        
    }
    
    func setColor(_ color: UIColor) {
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        string.setColor(color, for: textView.selectedRange)
        textView.attributedText = string
    }
}

extension WrittenNoteViewController: NTColorPickerDelegate {
    func colorPickerDidPickColor(_ color: UIColor) {
        setColor(color)
    }
}
