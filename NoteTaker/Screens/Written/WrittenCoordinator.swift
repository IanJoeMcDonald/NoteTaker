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
        
        let detailViewController = WrittenNoteViewController.instantiate()
        
        let detailNav = CoordinatedNavigationController(rootViewController: detailViewController)
        detailNav.coordinator = self
        splitViewController.viewControllers = [primaryNavigationController, detailNav]
        splitViewController.delegate = SplitViewControllerDelegate.shared
        splitViewController.preferredDisplayMode = .primaryOverlay
    }
    
    func showDetailView(with note: WrittenNote) {
        let detailVc = WrittenNoteViewController.instantiate()
        let detailNav = CoordinatedNavigationController(rootViewController: detailVc)
        detailVc.coordinator = self
        detailVc.note = note
        splitViewController.showDetailViewController(detailNav, sender: self)
    }
    
    func reloadData() {
        notesListViewController.tableView.reloadData()
    }
}
