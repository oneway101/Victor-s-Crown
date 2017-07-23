//
//  Note+CoreDataProperties.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 7/22/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var date: String?
    @NSManaged public var day: String?
    @NSManaged public var prayerRecord: Int16
    @NSManaged public var readingRecord: NSObject?

}
