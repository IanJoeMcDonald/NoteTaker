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
        
        // TODO: Here we are showing the color picker, this needs to move to the coordinator
        let vc = NTColorPickerViewController()
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func setColor(_ color: UIColor) {
        let string = NSMutableAttributedString(attributedString: textView.attributedText)
        string.setColor(color, for: textView.selectedRange)
        textView.attributedText = string
    }
}
