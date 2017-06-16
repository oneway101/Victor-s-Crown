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
    //Q: Do I need shared instance for the DataModel?
    static let sharedInstance = DataModel()
    
    static var notes:[Note] = [Note]()
    static var bible:[Book] = [Book]()
    static var chapters:[Chapter] = [Chapter]()
    static var scripture:[Scripture] = [Scripture]()
    
}
