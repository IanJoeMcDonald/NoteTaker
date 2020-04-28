//
//  WrittenNote+CoreDataProperties.swift
//  NoteTaker
//
//  Created by Ian McDonald on 25/04/20.
//  Copyright © 2020 Ian McDonald. All rights reserved.
//
//

import Foundation
import CoreData


extension WrittenNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WrittenNote> {
        return NSFetchRequest<WrittenNote>(entityName: "WrittenNote")
    }

    @NSManaged public var created: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var modified: Date?
    @NSManaged public var text: NSAttributedString?
    @NSManaged public var title: String?
    
    var modifiedDate : Date {
        return modified ?? Date()
    }
    
    var unwrappedId : UUID {
        return id ?? UUID()
    }
    
    var uuidString : String {
        return id?.uuidString ?? UUID().uuidString
    }

}
