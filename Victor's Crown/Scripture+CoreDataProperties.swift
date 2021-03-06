//
//  Scripture+CoreDataProperties.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 7/21/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import Foundation
import CoreData


extension Scripture {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Scripture> {
        return NSFetchRequest<Scripture>(entityName: "Scripture")
    }

    @NSManaged public var chapterId: String?
    @NSManaged public var verseNumber: String?
    @NSManaged public var verseText: NSObject?
    @NSManaged public var chapter: Chapter?

}
