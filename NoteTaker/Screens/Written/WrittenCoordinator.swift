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
    var primaryNavigationController = UINavigationController()
    
    var notesListViewController = WrittenNotesListViewController.instantiate()
    
    init() {
        notesListViewController.coordinator = self
        primaryNavigationController.viewControllers = [notesListViewController]
        
        let detailViewController = EmptyScreenViewController.instantiate()
        detailViewController.imageName = "doc.text"
        
        let detailNav = UINavigationController(rootViewController: detailViewController)
        splitViewController.viewControllers = [primaryNavigationController, detailNav]
        splitViewController.delegate = SplitViewControllerDelegate.shared
        splitViewController.preferredDisplayMode = .allVisible
        
        setTabBarItem()
    }
    
    func setTabBarItem() {
        splitViewController.tabBarItem.image = UIImage(systemName: "doc.text")
        splitViewController.tabBarItem.title = "Written"
    }
    
    func showDetailView(with note: WrittenNote) {
        let detailVc = WrittenNoteViewController.instantiate()
        let detailNav = UINavigationController(rootViewController: detailVc)
        detailVc.note = note
        splitViewController.showDetailViewController(detailNav, sender: self)
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.splitViewController.preferredDisplayMode = .primaryHidden
        }
    }
    
    func reloadData() {
        notesListViewController.tableView.reloadData()
    }
}
