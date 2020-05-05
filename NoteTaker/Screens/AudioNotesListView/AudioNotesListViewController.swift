//
//  AudioNotesListViewController.swift
//  NoteTaker
//
//  Created by Ian McDonald on 02/05/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class AudioNotesListViewController: UIViewController, Storyboarded {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var coordinator: AudioCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        coordinator?.showDetailView()
    }
}
