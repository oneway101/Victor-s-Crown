//
//  Chapter+CoreDataProperties.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/15/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import Foundation
import CoreData


extension Chapter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chapter> {
        return NSFetchRequest<Chapter>(entityName: "Chapter")
    }

    @NSManaged public var id: String?
    @NSManaged public var number: String?
    @NSManaged public var book: Book?
    @NSManaged public var verses: NSSet?

}

// MARK: Generated accessors for verses
extension Chapter {

    @objc(addVersesObject:)
    @NSManaged public func addToVerses(_ value: Scripture)

    @objc(removeVersesObject:)
    @NSManaged public func removeFromVerses(_ value: Scripture)

    @objc(addVerses:)
    @NSManaged public func addToVerses(_ values: NSSet)

    @objc(removeVerses:)
    @NSManaged public func removeFromVerses(_ values: NSSet)

}
