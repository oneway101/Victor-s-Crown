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
    
    func bookFetchRequest(bookName:String){
        
        //MARK: Get Books from Core Data
        let fetchRequest:NSFetchRequest<Book> = Book.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "name = %@", bookName)
        let context = CoreDataStack.getContext()
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        if let data = fetchedResultsController.fetchedObjects, data.count > 0 {
            DataModel.bible = data
        } else {
            print("No matching data returned from the chapter request")
        }
        
    }
    
    func scriptureFetchRequest(chapterId:String){
        
        //MARK: Get Chapters from Core Data
        let fetchRequest:NSFetchRequest<Chapter> = Chapter.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "id = %@", chapterId)
        let context = CoreDataStack.getContext()
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
        if let data = fetchedResultsController.fetchedObjects, data.count > 0 {
            
            //Q:How to only select or get only one chapter?
            let selectedChapter = data[0]
            
            BiblesClient.sharedInstance.getScriptures(selectedChapter, selectedChapter.id!) { (result, error) in
                
                if let result = result {
                    
                    DataModel.scripture = result
                    
                } else {
                    performUIUpdatesOnMain {
                        self.displayAlert(title: "Error", message: "There was an error.")
                        print(error)
                    }
                }
            } // getScripture
            
        } else {
            print("No Data returned from the scripture request")
        }
        
    }
    
    
    
}
