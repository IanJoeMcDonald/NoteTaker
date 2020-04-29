//
//  MainTabBarController.swift
//  NoteTaker
//
//  Created by Ian McDonald on 04/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    let written = WrittenCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [written.splitViewController]
        
        /// Currently the app only has 1 tab for written notes. In the future this will be expanded. Until this happens hide the tab bar
        tabBar.isHidden = true
    }
}
