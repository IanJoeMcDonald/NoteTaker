//
//  WrittenNotesListViewController.swift
//  NoteTaker
//
//  Created by Ian McDonald on 01/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import UIKit
import CoreData

class WrittenNotesListViewController: UIViewController, Storyboarded {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    
    var coordinator: WrittenCoordinator?
    var dataSource: WrittenNotesListDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        dataSource.fetchData()
    }
    
    private func configureTableView() {
        dataSource = WrittenNotesListDataSource()
        dataSource.delegate = self
        dataSource.persistanceDelegate = self
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func configureAddButton() {
        addButton.layer.cornerRadius = addButton.bounds.height / 2
        addButton.backgroundColor = .systemBlue
        addButton.setTitleColor(.white, for: .normal)
        addButton.clipsToBounds = true
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        dataSource.addNote()
    }
}

extension WrittenNotesListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showDetailView(with: dataSource.note(at: indexPath.row))
    }
}

extension WrittenNotesListViewController: WrittenNotesListDataSourceDelegate {
    func updateTableView() {
        tableView.reloadData()
    }
    
    func removeRowInTable(at index: Int) {
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func insertRowInTable(at index: Int) {
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func selectRowInTable(at index: Int) {
        tableView.selectRow(at: IndexPath(row: index, section: 0), animated: true,
                            scrollPosition: .none)
        tableView(self.tableView, didSelectRowAt: IndexPath(row: index, section: 0))
    }
}

extension WrittenNotesListViewController: WrittenNotesListDataSourcePersistanceDelegate {
    func saveContext() {
        PersistanceService.saveContext()
    }
    
    func deleteNote(_ note: WrittenNote) {
        PersistanceService.deleteNote(note)
    }
}
