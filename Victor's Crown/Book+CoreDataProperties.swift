//
//  Book+CoreDataProperties.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/23/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var numOfChapters: Int16
    @NSManaged public var chapters: NSSet?

}

// MARK: Generated accessors for chapters
extension Book {

    @objc(addChaptersObject:)
    @NSManaged public func addToChapters(_ value: Chapter)

    @objc(removeChaptersObject:)
    @NSManaged public func removeFromChapters(_ value: Chapter)

    @objc(addChapters:)
    @NSManaged public func addToChapters(_ values: NSSet)

    @objc(removeChapters:)
    @NSManaged public func removeFromChapters(_ values: NSSet)

}
