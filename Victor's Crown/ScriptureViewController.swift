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
    //var selectedChapter:Chapter!
    var scriptures:[Scripture] = []
    var scriptureLoaded = false
    
    @IBAction func unWindToScriptureView(segue:UIStoryboardSegue) { }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Fetch all Core Data first.
        loadData()
        
        //if books does not exist in Core Data, GET from the book list network request.
        if DataModel.bookLists.count == 0 {
            print("Selected Book and Chapter don't exist. Getting the book list from the network...")
            BiblesClient.sharedInstance.getBookList() { (books, chapters, error) in
                if let allBooks = books, let allChapters = chapters {
                    performUIUpdatesOnMain {
                        DataModel.bookLists = allBooks
                        print(DataModel.bookLists)
                        DataModel.chapters = allChapters
                        print(DataModel.chapters)
                    }
                    print("Bible book list returned!")
                }else{
                    performUIUpdatesOnMain {
                        self.displayAlert(title: "Invalid Link", message: "There was an error.")
                        print(error)
                    }
                }
            }//getBookList
        }
        //clearData(entity: "Book")
        //clearData(entity: "Chapter")
        //clearData(entity: "Scripture")
        
        
        //Get Data to display
        bookFetchRequest(bookName: DataModel.selectedBookName, chapterId: DataModel.selectedChapterId)
        
        // Set delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set navigtaion buttons
        bookNavigationButton()
        chapterNavigationButton()
        
        performUIUpdatesOnMain {
            self.scriptures = DataModel.selectedScripture
            for scripture in self.scriptures {
                let text = scripture.verseText
                print("text: \(text)")
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataModel.selectedScripture.count
        //return scriptures.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ScriptureCell
        
        let verse = DataModel.selectedScripture[(indexPath as NSIndexPath).row]
        //let verse = scriptures[(indexPath as NSIndexPath).row]
        
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
        chapterNavButton.setTitle(DataModel.selectedBookName, for: .normal)
      
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
