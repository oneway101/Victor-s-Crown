//
//  Scripture+CoreDataProperties.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/13/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import Foundation
import CoreData


extension Scripture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scripture> {
        return NSFetchRequest<Scripture>(entityName: "Scripture")
    }

    @NSManaged public var chapter: String?
    @NSManaged public var verse: String?
    @NSManaged public var chapters: Book?

}
