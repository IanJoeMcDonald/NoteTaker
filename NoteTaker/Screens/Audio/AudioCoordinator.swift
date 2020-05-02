//
//  AudioCoordinator.swift
//  NoteTaker
//
//  Created by Ian McDonald on 02/05/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class AudioCoordinator: Coordinator {
    var splitViewController = UISplitViewController()
    var primaryNavigationController = UINavigationController()
    
    var notesListViewController = AudioNotesListViewController.instantiate()
    
    init() {
        notesListViewController.coordinator = self
        primaryNavigationController.viewControllers = [notesListViewController]
        
        let detailViewController = EmptyScreenViewController.instantiate()
        
        let detailNav = UINavigationController(rootViewController: detailViewController)
        splitViewController.viewControllers = [primaryNavigationController, detailNav]
        splitViewController.delegate = SplitViewControllerDelegate.shared
        splitViewController.preferredDisplayMode = .allVisible
        
        splitViewController.tabBarItem.image = UIImage(systemName: "music.mic")
        splitViewController.tabBarItem.title = "Audio"
    }
    
    
    
}
