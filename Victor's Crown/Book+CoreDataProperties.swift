//
//  Book+CoreDataProperties.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/7/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import Foundation
import CoreData


extension Book {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Book> {
        return NSFetchRequest<Book>(entityName: "Book")
    }

    @NSManaged public var chapter: String?
    @NSManaged public var name: String?
    @NSManaged public var text: String?

}
