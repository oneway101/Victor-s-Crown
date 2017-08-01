//
//  DataModel.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/7/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import Foundation
import CoreData

class DataModel:NSObject {
    
    //Notes
    static var notes = [Note]()    
    
    //Bible
    static var bookLists = [Book]()
    static var chapters = [Chapter]()
    static var scriptures = [Scripture]()
    
    static var selectedBook:Book?
    static var selectedChapter:Chapter?
    static var selectedScripture = [Scripture]()
    
    static var selectedBookName:String?
    static var selectedChapterId:String?
    static var selectedChapterNumber:String?
    
}
