//
//  ScriptureViewController.swift
//  Victor's Crown
//
//  Created by Ha Na Gill on 6/11/17.
//  Copyright © 2017 cosmostream. All rights reserved.
//

import UIKit
import CoreData

class ScriptureViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    let chapterNavButton =  UIButton(type: .custom)
    var navigationTitle:String!
    
    @IBOutlet weak var tableView: UITableView!
    private let reuseIdentifier = "ScriptureCell"
    
    //var selectedBook:Book!
    var selectedChapter:Chapter!
    var scriptures:[Scripture] = []
    var scriptureLoaded = false
    
    @IBAction func unWindToScriptureView(segue:UIStoryboardSegue) { }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if DataModel.bible.count == nil {
            
            //Mark: if Books doesn't exist in Core Data GET from the network
            BiblesClient.sharedInstance.getBookList() { (result, error) in
                if let books = result {
                    DataModel.bible = books
                    print("bible book list returned!")
                }else{
                    performUIUpdatesOnMain {
                        self.displayAlert(title: "Invalid Link", message: "There was an error.")
                        print(error)
                    }
                }
            }
            
        }
            
        //Get Data to display
        if let bookName = DataModel.selectedBook?.name {
            print("selected book: \(bookName)")
            bookFetchRequest(bookName: bookName)
        } else {
            bookFetchRequest(bookName: "Genesis")
        }
        
        if let selectedChapterId = DataModel.selectedChapter?.id {
            print("selected chapter: \(selectedChapterId)")
            scriptureFetchRequest(chapterId: selectedChapterId)
        } else {
            scriptureFetchRequest(chapterId: "eng-KJV:Gen.1")
        }
        
        scriptureLoaded = true
        
        // Set delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set navigtaion buttons
        bookNavigationButton()
        chapterNavigationButton()
        
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {

        return DataModel.bible.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //let numberOfVerses = DataModel.selectedChapter?.verses?.count
        //print("number of verses: \(numberOfVerses!)")
        return 100
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ScriptureCell
        
        //Q: filtering verses??
        let verse = scriptures[(indexPath as NSIndexPath).row]
        
        cell.verseNumberLabel.text = verse.verseNumber
        cell.verseTextView.text = verse.verseText
        
        return cell
    }

    func bookNavigationButton(){
        //Mark: Create a book list navigation
        let bookNavButton = UIBarButtonItem(title: "Books", style: .plain, target: self, action: #selector(self.clickOnBookName))
        self.navigationItem.leftBarButtonItem = bookNavButton
    }
    
    
    //Mark: Navigation set-up
    
    func chapterNavigationButton(){
        
        //Mark: Create a chapter list navigation
        if scriptureLoaded {
            chapterNavButton.setTitle(DataModel.selectedBook?.name, for: .normal)
        } else {
            chapterNavButton.setTitle("No Book", for: .normal)
        }
        chapterNavButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        chapterNavButton.setTitleColor(UIColor(red: 3/255, green: 121/255, blue: 251/255, alpha: 1.0), for: .normal)
        chapterNavButton.addTarget(self, action: #selector(self.clickOnBookTitle), for: .touchUpInside)
        self.navigationItem.titleView = chapterNavButton
    }
    
    func clickOnBookName(button: UIButton) {
        performSegue(withIdentifier: "BookListSegue", sender: self)
    }
    
    func clickOnBookTitle(button: UIButton) {
        performSegue(withIdentifier: "ChapterListSegue", sender: self)
    }
    
    func recordToTimeline(name:String, chapter:String, text:String){
        let context = CoreDataStack.getContext()
        let note:Note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context ) as! Note
        note.readingRecord = "testing..."
        CoreDataStack.saveContext()
    }

}
