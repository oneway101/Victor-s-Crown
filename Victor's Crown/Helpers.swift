//
//  Helpers.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/2/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    // Alert
    func displayAlert(title:String, message:String?) {
        
        if let message = message {
            let alert = UIAlertController(title: title, message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func getCurrentDate() -> (date:String, weekday:String, today:Date){
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let weekday = date.dayOfWeek()
        let currentDate = "\(month)/\(day)/\(year)"
        let currentWeekday = "\(weekday!)"
        return (currentDate, currentWeekday, date)
    }
    
    func deleteAll(entity:String){
        let context = CoreDataStack.getContext()
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }

    }
    
}
