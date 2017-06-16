//
//  TextsViewController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 5/31/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit
import CoreData

class BibleRootViewController: UIViewController, UINavigationControllerDelegate {
    
    //@IBOutlet weak var scrollView: UIScrollView!
    
    let chapterNavButton =  UIButton(type: .custom)
    let selectedBookName = "Psalms"
    let selectedBookChapter = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookNavigationButton()
        chapterNavigationButton()
        BiblesClient.sharedInstance.getBookList() { (books, error) in
            if let books = books {
                print("books data returned!")
            }else{
                performUIUpdatesOnMain {
                    self.displayAlert(title: "Invalid Link", message: "There was an error.")
                    print(error)
                }
            }
        }
        
    }
    
    func bookNavigationButton(){
        //Mark: Create a book list navigation
        let bookNavButton = UIBarButtonItem(title: "Books", style: .plain, target: self, action: #selector(self.clickOnBookName))
        self.navigationItem.leftBarButtonItem = bookNavButton
    }
    
    
    func chapterNavigationButton(){
        //Mark: Create a chapter list navigation
        chapterNavButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        chapterNavButton.setTitle(selectedBookName, for: .normal)
        chapterNavButton.setTitleColor(UIColor(red: 3/255, green: 121/255, blue: 251/255, alpha: 1.0), for: .normal)
        chapterNavButton.addTarget(self, action: #selector(self.clickOnBookTitle), for: .touchUpInside)
        self.navigationItem.titleView = chapterNavButton
    }
    
    func clickOnBookName(button: UIButton) {
        performSegue(withIdentifier: "BookList", sender: self)
    }
    
    func clickOnBookTitle(button: UIButton) {
        performSegue(withIdentifier: "ChapterList", sender: self)
    }
    
    func saveBook(name:String, chapter:String, text:String){
        let context = CoreDataStack.getContext()
        let book:Book = NSEntityDescription.insertNewObject(forEntityName: "Book", into: context ) as! Book
        book.name = name
        CoreDataStack.saveContext()
    }

}
