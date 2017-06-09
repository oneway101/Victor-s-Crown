//
//  TextsViewController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 5/31/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit
import CoreData

class BibleReadingViewController: UIViewController, UINavigationControllerDelegate {
    
    //var book:[Book] = [Book]()
    let navTitleButton =  UIButton(type: .custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookNavigationButton()
        
        BiblesClient.sharedInstance.getScriptures { (books, error) in
            if let books = books {
                print("books data returned!")
            }else{
                performUIUpdatesOnMain {
                    self.displayAlert(title: "Invalid Link", message: "There was an error.")
                }
                print(error)
            }
        }
        
    }
    
    func bookNavigationButton(){
        //Mark: Create a button navigation title
        navTitleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navTitleButton.setTitle("Psalms", for: .normal)
        navTitleButton.setTitleColor(UIColor(red: 3/255, green: 121/255, blue: 251/255, alpha: 1.0), for: .normal)
        navTitleButton.addTarget(self, action: #selector(self.clickOnTitle), for: .touchUpInside)
        self.navigationItem.titleView = navTitleButton
    }
    
    func clickOnTitle(button: UIButton) {
        performSegue(withIdentifier: "ChapterList", sender: self)
    }
    
    func saveBook(name:String, chapter:String, text:String){
        let context = CoreDataStack.getContext()
        let book:Book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context ) as! Book
        book.name = name
        book.chapter = chapter
        book.text = text
        CoreDataStack.saveContext()
    }

}
