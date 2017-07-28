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
    
    private let reuseIdentifier = "ScriptureCell"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var breadButton: UIButton!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    let chapterNavButton =  UIButton(type: .custom)
    var navigationTitle:String!
    var bookName:String!
    var chapterNumber:String!
    var chapterId:String!
    var scriptures:[Scripture] = []
    var scriptureLoaded = false
    
    let today = Date()
    var timestamp = ""
    var dayOfWeek = ""
    
    var readingRecordArray:[String] = []
    
    @IBAction func unWindToScriptureView(segue:UIStoryboardSegue) { }
    
    override func viewWillAppear(_ animated: Bool) {
        //Fetch all Core Data first.
        loadBookData()
        
        //clearData(entity: "Book")
        //clearData(entity: "Chapter")
        //clearData(entity: "Scripture")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        bookName = DataModel.selectedBook?.name
        
        if bookName == nil {
            print("Genesis 1 set as a default chapter")
            bookName = "Genesis"
            chapterId = "eng-KJV:Gen.1"
            chapterNumber = "1"
        } else {
            print("\(bookName!)'s chapter number, id and scriptures are set.")
            chapterNumber = DataModel.selectedChapter?.number
            chapterId = DataModel.selectedChapterId
            scriptures = DataModel.selectedScripture
        }
        
        performUIUpdatesOnMain {
            self.showActivityIndicator(self.activityIndicator)
        }
        
        //Get Data to display
        bookFetchRequest(bookName: bookName, chapterId: chapterId) { (result, error) in
            if let result = result {
                performUIUpdatesOnMain {
                    self.hideActivityIndicator(self.activityIndicator)
                    self.scriptures = result
                    self.tableView.reloadData()
                    print("Scripture tableView reloaded.")
                }
            } else {
                performUIUpdatesOnMain {
                    self.hideActivityIndicator(self.activityIndicator)
                    let message = error?.localizedDescription
                    self.displayAlert(title: "Error", message: message)
                }
                
            }
        }
        
        // Set navigtaion buttons
        bookNavigationButton()
        chapterNavigationButton(bookName, chapterNumber)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegates
        tableView.delegate = self
        tableView.dataSource = self
        
        // Set row heights
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        breadButton.isHidden = true
        
        timestamp = DateFormatter.localizedString(from: today, dateStyle: .short, timeStyle: .none)
        dayOfWeek = today.dayOfWeek()!
        
    }
    
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return DataModel.selectedScripture.count
        return scriptures.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ScriptureCell
        
        //let verse = DataModel.selectedScripture[(indexPath as NSIndexPath).row]
        let verse = scriptures[(indexPath as NSIndexPath).row]
  
        cell.verseTextView.setHTMLFromString(htmlText: verse.verseText as! String)
 
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == scriptures.count {
            print("end of the row")
            breadButton.isHidden = false

        }
    }
    
    
    
    func bookNavigationButton(){
        //Mark: Create a book list navigation
        let bookNavButton = UIBarButtonItem(title: "Books", style: .plain, target: self, action: #selector(self.clickOnBookName))
        self.navigationItem.leftBarButtonItem = bookNavButton
    }
    
    
    //Mark: Navigation set-up
    
    func chapterNavigationButton(_ bookName:String, _ chapterNumber:String){
        
        //Mark: Create a chapter list navigation
        chapterNavButton.setTitle("\(bookName) \(chapterNumber)", for: .normal)
      
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
    
    @IBAction func recordToTimeline(){
        //MARK: Fetch Request
        let fetchRequest:NSFetchRequest<Note> = Note.fetchRequest()
        fetchRequest.sortDescriptors = []
        fetchRequest.predicate = NSPredicate(format: "date = %@", timestamp)
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
            if let bookname = bookName, let chapternumber = chapterNumber {
                readingRecordArray.append("\(bookname) \(chapternumber)")
                data[0].readingRecord = readingRecordArray as NSObject
            }
            print("Reading record has been upated to \(data[0].readingRecord!).")
            CoreDataStack.saveContext()
        } else {
            let note:Note = NSEntityDescription.insertNewObject(forEntityName: "Note", into: context ) as! Note
            note.date = timestamp
            note.day = dayOfWeek
            note.prayerRecord = 0
            if let bookname = bookName, let chapternumber = chapterNumber {
                readingRecordArray.append("\(bookname) \(chapternumber)")
                note.readingRecord = readingRecordArray as NSObject
            }
            
            CoreDataStack.saveContext()
            print("Today's reading record has been saved: \(note.readingRecord!).")
        }
        
        breadButton.isHidden = true
        
    }

}


extension UITextView {
    func setHTMLFromString(htmlText: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(self.font!.pointSize)\">%@</span>" as NSString, htmlText) as String
        
        
        //process collection values
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: .unicode, allowLossyConversion: true)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        
        self.attributedText = attrStr
    }
}
