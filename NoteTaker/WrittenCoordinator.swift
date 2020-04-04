//
//  WrittenCoordinator.swift
//  NoteTaker
//
//  Created by Ian McDonald on 04/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class WrittenCoordinator: Coordinator {
    var splitViewController = UISplitViewController()
    var primaryNavigationController = CoordinatedNavigationController()
    
    var notesListViewController = NotesListViewController()
    
    init() {
        primaryNavigationController.coordinator = self
        
        notesListViewController.coordinator = self
        primaryNavigationController.viewControllers = [notesListViewController]
        
        let detailViewController = NoteViewController.instantiate()
        
        let detailNav = CoordinatedNavigationController(rootViewController: detailViewController)
        detailNav.coordinator = self
        splitViewController.viewControllers = [primaryNavigationController, detailNav]
        splitViewController.delegate = SplitViewControllerDelegate.shared
        splitViewController.preferredDisplayMode = .primaryOverlay
    }
    
    func showDetailView(with text: String) {
        let detailVc = NoteViewController.instantiate()
        detailVc.text = text
        let detailNav = CoordinatedNavigationController(rootViewController: detailVc)
        splitViewController.showDetailViewController(detailNav, sender: self)
    }
}
