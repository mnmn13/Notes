//
//  Note+CoreDataProperties.swift
//  Notes
//
//  Created by MN on 26.11.2022.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var content: String?
    @NSManaged public var title: String?
}

extension Note : Identifiable {

}
