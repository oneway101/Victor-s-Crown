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
    
    var selectedBook:Book!
    var selectedChapter:Chapter!
    var scriptures:[Scripture] = []
    
    @IBAction func unwindToScriptureView(segue:UIStoryboardSegue) { }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        if selectedChapter != nil {
            
            BiblesClient.sharedInstance.getScriptures(selectedChapter, selectedChapter.id!) { (success, error) in
                if let result = success {
                    self.scriptures = result
                    performUIUpdatesOnMain {
                        print(self.scriptures)
                    }
                    
                } else {
                    performUIUpdatesOnMain {
                        self.displayAlert(title: "Error", message: "There was an error.")
                        print(error)
                    }
                }
            }
            
            print("You've seleted \(String(describing: selectedBook.name)) Chapter \(String(describing: selectedChapter.number))")
            print("Chapter Id: \(selectedChapter.id!)")
            
            
        } else {
            
            performSegue(withIdentifier: "BookListSegue", sender: self)
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        bookNavigationButton()
        chapterNavigationButton()
        
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {

        return DataModel.bible.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DataModel.scripture.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ScriptureCell
        
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
        if selectedChapter != nil {
            chapterNavButton.setTitle(selectedBook.name!, for: .normal)
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
