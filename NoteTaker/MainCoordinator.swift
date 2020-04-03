//
//  MainCoordinator.swift
//  NoteTaker
//
//  Created by Ian McDonald on 01/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var splitViewController: UISplitViewController
    
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }
    
    func start() {
        let masterVc = NotesListViewController.instantiate()
        let detailVc = NoteViewController.instantiate()
        let navController = UINavigationController()
        navController.viewControllers = [masterVc]
        splitViewController.viewControllers = [navController, detailVc]
    }
    
}
