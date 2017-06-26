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
    
    func clearData(entity:String){
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
    
    func loadData(){
        
        let fetchRequest:NSFetchRequest<Book> = Book.fetchRequest()

        let context = CoreDataStack.getContext()
        
        do {
            
           DataModel.bookLists = try context.fetch(fetchRequest)
            
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
        
    }
    
    func bookFetchRequest(bookName:String, chapterId:String){
        
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
            performUIUpdatesOnMain {
                DataModel.selectedBook = data[0]
                print("\(bookName) is fetched and set as a selectedBook: \(String(describing: DataModel.selectedBook))")
            }
            self.chapterFetchRequest(chapterId: chapterId)
            
        } else {
            print("No data returned from the bookFetcheRquest. Getting the Book list from the network...")
            
            BiblesClient.sharedInstance.getBookList() { (books, chapters, error) in
                if let allBooks = books, let allChapters = chapters {
                    performUIUpdatesOnMain {
                        DataModel.bookLists = allBooks
                        DataModel.chapters = allChapters
                    }
                    self.chapterFetchRequest(chapterId: chapterId)
                    
                    print("Bible book list returned!")
                }else{
                    performUIUpdatesOnMain {
                        self.displayAlert(title: "Invalid Link", message: "There was an error.")
                        print(error)
                    }
                }
            }//getBookList
        }
        
    }
    
    func chapterFetchRequest(chapterId:String){
        
        //MARK: Get Initial Chapter from Core Data
        let fetchRequest:NSFetchRequest<Chapter> = Chapter.fetchRequest()
        //let sortDescriptor = NSSortDescriptor(key: "number", ascending: true)
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
            performUIUpdatesOnMain {
                DataModel.selectedChapter = data[0]
                print("\(chapterId) is fetched and set as a selectedChapter: \(String(describing: DataModel.selectedChapter))")
                print("Fetching all scriptures of selected chapter...")
                self.scriptureFetchRequest(selectedChapter: data[0], chapterId: chapterId)
            }
        }else {
            print("No data returned from the chapter fetch request.")
        }
        
    }
    
    func scriptureFetchRequest(selectedChapter:Chapter, chapterId:String){
        
        //MARK: Get Chapters from Core Data
        let fetchRequest:NSFetchRequest<Scripture> = Scripture.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "chapterId = %@", chapterId)
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
            performUIUpdatesOnMain {
                DataModel.selectedScripture = data
                print("Scriputres fetched for \(chapterId) and set as selectedScripture.")
            }
            
        } else {
            print("No data returned from the scripture fetch request. Getting the scripture from the network...")
            
            BiblesClient.sharedInstance.getScriptures(selectedChapter, selectedChapter.id!) { (result, error) in
                
                if let result = result {
                    DataModel.selectedScripture = result
                    print("Selected chapter scriptures are returned!")
                } else {
                    performUIUpdatesOnMain {
                        self.displayAlert(title: "Error", message: "There was an error.")
                        print(error)
                    }
                }
            } // getScriptures
            
        }
        
    }
    
    
    
}
