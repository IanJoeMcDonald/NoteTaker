//
//  NotesListViewController.swift
//  NoteTaker
//
//  Created by Ian McDonald on 01/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit
import CoreData

class NotesListViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var coordinator: WrittenCoordinator?
    var notes = [WrittenNote]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureAddButton()
        loadNotes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func configureAddButton() {
        addButton.layer.cornerRadius = addButton.bounds.height / 2
        addButton.backgroundColor = .systemBlue
        addButton.setTitleColor(.white, for: .normal)
        addButton.clipsToBounds = true
        addButton.addTarget(self, action: #selector(addNewNote), for: .touchUpInside)
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
        note.title = "New Note"
        notes.append(note)
        PersistanceService.saveContext()
        tableView.reloadData()
        tableView.selectRow(at: IndexPath(row: notes.count - 1, section: 0), animated: true,
                            scrollPosition: .none)
        tableView(self.tableView, didSelectRowAt: IndexPath(row: notes.count - 1, section: 0))
    }
    
}

extension NotesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let note = notes[indexPath.row]
        let modified = note.modified?.formatStringTodayYesterday(format: "HH:mm",
                                                                 otherTime: "d MMM y, HH:mm")
                                                                 ?? "Unknown"
        let created = note.created?.formatStringTodayYesterday(format: nil,
                                                               otherTime: "d MMM y") ?? "Unknown"

        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = "Modified: \(modified), Created: \(created)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showDetailView(with: notes[indexPath.row])
    }
}
