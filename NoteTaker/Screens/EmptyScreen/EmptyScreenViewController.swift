//
//  EmptyScreenViewController.swift
//  NoteTaker
//
//  Created by Ian McDonald on 25/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class EmptyScreenViewController: UIViewController, Storyboarded {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    private func configure() {
        textLabel.text = """
        No Note Selected
        Please select a note from the list or create a new note.
        """
        
        let imageWeight = UIImage.SymbolConfiguration(weight: .ultraLight)
        imageView.image = UIImage(systemName: "doc.text", withConfiguration: imageWeight)
        imageView.tintColor = .systemGray6
    }
}
