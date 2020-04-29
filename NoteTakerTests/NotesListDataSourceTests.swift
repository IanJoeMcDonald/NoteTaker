//
//  NotesListDataSourceTests.swift
//  NoteTakerTests
//
//  Created by Ian McDonald on 28/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//

import XCTest
import CoreData
@testable import NoteTaker

class NotesListDataSourceTests: XCTestCase {
    
    var context: NSManagedObjectContext!
    var sut: NotesListDataSource!

    override func setUpWithError() throws {
        sut = NotesListDataSource()
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    }

    override func tearDownWithError() throws {
        sut = nil
        context = nil
    }

    func testNewDataSourceHasZeroNotes() {
        // given
        
        // when
        
        // then
        XCTAssertEqual(sut.notesCount, 0)
    }
    
    func testAddOneNoteMakesDataSourceHaveOneNote() {
        // given
        
        // when
        sut.addNote(context: context)
        
        //then
        XCTAssertEqual(sut.notesCount, 1)
    }
    
    func testNoteReturnsTheCorrectNote() {
        // given
        
        // when
        let note1 = WrittenNote(context: context)
        note1.id = UUID()
        note1.title = "Title 1"
        note1.text = NSAttributedString(string: "Text 1")
        note1.created = Date()
        note1.modified = Date()
        
        let note2 = WrittenNote(context: context)
        note2.id = UUID()
        note2.title = "Title 2"
        note2.text = NSAttributedString(string: "Text 2")
        note2.created = Date()
        note2.modified = Date()
        
        sut.addNote(note1)
        sut.addNote(note2)
        
        // then
        XCTAssertEqual(sut.note(at: 0).id, note2.id)
    }
    
    func testDeleteNoteReducesNoteCount() {
        // given
        sut.addNote(context: context)
        sut.addNote(context: context)
        sut.addNote(context: context)
        XCTAssertEqual(sut.notesCount, 3)
        
        // when
        sut.deleteNote(at: 0)
        
        // then
        XCTAssertEqual(sut.notesCount, 2)
    }
    
    func testSortDataOrdersByModifiedDate() {
        // given
        
        // when
        let note1 = WrittenNote(context: context)
        note1.id = UUID()
        note1.title = "Title 1"
        note1.text = NSAttributedString(string: "Text 1")
        note1.created = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 1
        note1.modified = Calendar.current.date(byAdding: dateComponent, to: Date())
        
        let note2 = WrittenNote(context: context)
        note2.id = UUID()
        note2.title = "Title 2"
        note2.text = NSAttributedString(string: "Text 2")
        note2.created = Date()
        note2.modified = Date()
        
        sut.addNote(note1)
        sut.addNote(note2)
        sut.sortData()
        
        // then
        XCTAssertEqual(sut.note(at: 0).id, note1.id)
    }
}
