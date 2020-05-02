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
    let audio = AudioCoordinator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [written.splitViewController, audio.splitViewController]
    }
}
