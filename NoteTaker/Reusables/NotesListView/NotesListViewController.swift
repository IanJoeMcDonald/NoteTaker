//
//  NotesListViewController.swift
//  NoteTaker
//
//  Created by Ian McDonald on 01/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit
import CoreData

class NotesListViewController: UITableViewController, Storyboarded {

    var coordinator: WrittenCoordinator?
    var notes = [WrittenNote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(addNewNote))
        loadNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func loadNotes() {
        let fetchRequest: NSFetchRequest<WrittenNote> = WrittenNote.fetchRequest()
        
        guard let loadedNotes = try? PersistanceService.context.fetch(fetchRequest) else {
            return
        }
        
        notes = loadedNotes
    }
    
    @objc private func addNewNote() {
        let note = WrittenNote(context: PersistanceService.context)
        note.created = Date()
        note.modified = Date()
        note.id = UUID()
        note.text = NSAttributedString(string: "")
        notes.append(note)
        PersistanceService.saveContext()
        tableView.reloadData()
        tableView.selectRow(at: IndexPath(row: notes.count - 1, section: 0), animated: true,
                            scrollPosition: .none)
        tableView(self.tableView, didSelectRowAt: IndexPath(row: notes.count - 1, section: 0))
    }
    
}

extension NotesListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = notes[indexPath.row].text?.string
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showDetailView(with: notes[indexPath.row])
    }
}
