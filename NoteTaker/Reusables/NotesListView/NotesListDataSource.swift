//
//  NotesListDataSource.swift
//  NoteTaker
//
//  Created by Ian McDonald on 27/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit
import CoreData

class NotesListDataSource: NSObject {
    var delegate: NotesListDataSourceDelegate?
    var persistanceDelegate: NotesListDataSourcePersistanceDelegate?
    
    var notesCount: Int {
        return notes.count
    }
    
    private var notes = [WrittenNote]()
    
    func fetchData(fromContext context: NSManagedObjectContext? = PersistanceService.context,
                   request: NSFetchRequest<WrittenNote>? = WrittenNote.fetchRequest()) {
        guard let context = context, let request = request else {
            return
        }
        
        guard let loadedNotes = try? context.fetch(request) else {
            return
        }
        
        notes = loadedNotes
        sortData()
        delegate?.updateTableView()
    }
    
    func sortData() {
        notes.sort(by: { $0.modifiedDate.compare($1.modifiedDate) == .orderedDescending })
    }
    
    func note(at index: Int) -> WrittenNote {
        guard index >= 0, index < notes.count else {
            fatalError("Invalid index selected in table view")
        }
        return notes[index]
    }
    
    func addNote(context: NSManagedObjectContext = PersistanceService.context) {
        let note = WrittenNote(context: context)
        note.created = Date()
        note.modified = Date()
        note.id = UUID()
        note.text = NSAttributedString(string: "")
        note.title = "New Note"
        addNote(note)
    }
    
    func addNote(_ note: WrittenNote) {
        notes.insert(note, at: 0)
        persistanceDelegate?.saveContext()
        sortData()
        delegate?.insertRowInTable(at: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            self.delegate?.selectRowInTable(at: 0)
        }
    }
    
    func deleteNote(at index: Int) {
        guard index >= 0, index < notes.count else {
            fatalError("Invalid index selected in tableView")
        }
        let deletedNote = notes.remove(at: index)
        persistanceDelegate?.deleteNote(deletedNote)
        delegate?.removeRowInTable(at: index)
    }
}

extension NotesListDataSource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let note = notes[indexPath.row]
        let modified = note.modified?.formatStringTodayYesterday(format: "HH:mm",
                                                                 otherTime: "d MMM yy, HH:mm")
                                                                 ?? "Unknown"
        let created = note.created?.formatStringTodayYesterday(format: nil,
                                                               otherTime: "d MMM yy") ?? "Unknown"

        cell.textLabel?.text = note.title
        cell.detailTextLabel?.text = "Updated: \(modified), Created: \(created)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteNote(at: indexPath.row)
        }
    }
}

protocol NotesListDataSourceDelegate {
    func updateTableView()
    func removeRowInTable(at index: Int)
    func insertRowInTable(at index: Int)
    func selectRowInTable(at index: Int)
}

protocol NotesListDataSourcePersistanceDelegate {
    func saveContext()
    func deleteNote(_ note: WrittenNote)
}
