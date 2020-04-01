//
//  NotesListViewController.swift
//  NoteTaker
//
//  Created by Ian McDonald on 01/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit

class NotesListViewController: UITableViewController, Storyboarded {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = "Test \(indexPath.row)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "NoteView", bundle: .main).instantiateInitialViewController() as? NoteViewController else { return }
        
        vc.text = "Test \(indexPath.row)"
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
